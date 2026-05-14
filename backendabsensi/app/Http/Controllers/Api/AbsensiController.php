<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Absensi;
use App\Models\QrSession;
use App\Models\PesertaMk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Carbon\Carbon;

class AbsensiController extends Controller
{
    /**
     * Scan QR Code untuk absensi (Mahasiswa)
     */
    public function scanQr(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'kode_qr' => 'required|string',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Cari QR Session
        $qrSession = QrSession::where('kode_qr', $request->kode_qr)->first();

        if (!$qrSession) {
            return response()->json([
                'success' => false,
                'message' => 'QR Code tidak valid'
            ], 404);
        }

        // Validasi QR belum expired
        if ($qrSession->isExpired()) {
            return response()->json([
                'success' => false,
                'message' => 'QR Code sudah expired'
            ], 422);
        }

        // Validasi mahasiswa terdaftar pada mata kuliah
        $isPeserta = PesertaMk::where('mahasiswa_id', $request->user()->id)
            ->where('mata_kuliah_id', $qrSession->mata_kuliah_id)
            ->exists();

        if (!$isPeserta) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak terdaftar pada mata kuliah ini'
            ], 403);
        }

        // Validasi belum absen pada session ini
        $sudahAbsen = Absensi::where('mahasiswa_id', $request->user()->id)
            ->where('qr_session_id', $qrSession->id)
            ->exists();

        if ($sudahAbsen) {
            return response()->json([
                'success' => false,
                'message' => 'Anda sudah melakukan absensi pada sesi ini'
            ], 422);
        }

        // Simpan absensi
        $absensi = Absensi::create([
            'mahasiswa_id' => $request->user()->id,
            'mata_kuliah_id' => $qrSession->mata_kuliah_id,
            'qr_session_id' => $qrSession->id,
            'tanggal' => Carbon::now()->toDateString(),
            'jam' => Carbon::now()->toTimeString(),
            'status' => 'hadir',
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
        ]);

        $absensi->load(['mataKuliah:id,nama_mk,kode_mk']);

        return response()->json([
            'success' => true,
            'message' => 'Absensi berhasil',
            'data' => $absensi
        ], 201);
    }

    /**
     * Riwayat absensi mahasiswa
     */
    public function riwayatAbsensi(Request $request)
    {
        $query = Absensi::where('mahasiswa_id', $request->user()->id)
            ->with(['mataKuliah:id,nama_mk,kode_mk'])
            ->orderBy('tanggal', 'desc')
            ->orderBy('jam', 'desc');

        // Filter by mata kuliah
        if ($request->has('mata_kuliah_id')) {
            $query->where('mata_kuliah_id', $request->mata_kuliah_id);
        }

        // Filter by tanggal
        if ($request->has('tanggal_mulai')) {
            $query->where('tanggal', '>=', $request->tanggal_mulai);
        }
        if ($request->has('tanggal_selesai')) {
            $query->where('tanggal', '<=', $request->tanggal_selesai);
        }

        $absensi = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Riwayat absensi berhasil diambil',
            'data' => $absensi
        ], 200);
    }

    /**
     * Rekap absensi untuk dosen
     */
    public function rekapAbsensi(Request $request)
    {
        $query = Absensi::with(['mahasiswa:id,nama,email', 'mataKuliah:id,nama_mk,kode_mk'])
            ->whereHas('mataKuliah', function($q) use ($request) {
                $q->where('dosen_id', $request->user()->id);
            })
            ->orderBy('tanggal', 'desc')
            ->orderBy('jam', 'desc');

        // Filter by mata kuliah
        if ($request->has('mata_kuliah_id')) {
            $query->where('mata_kuliah_id', $request->mata_kuliah_id);
        }

        // Filter by tanggal
        if ($request->has('tanggal_mulai')) {
            $query->where('tanggal', '>=', $request->tanggal_mulai);
        }
        if ($request->has('tanggal_selesai')) {
            $query->where('tanggal', '<=', $request->tanggal_selesai);
        }

        $absensi = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Rekap absensi berhasil diambil',
            'data' => $absensi
        ], 200);
    }

    /**
     * Get absensi by mata kuliah
     */
    public function getAbsensiByMataKuliah($id)
    {
        $absensi = Absensi::where('mata_kuliah_id', $id)
            ->with(['mahasiswa:id,nama,email'])
            ->orderBy('tanggal', 'desc')
            ->orderBy('jam', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data absensi berhasil diambil',
            'data' => $absensi
        ], 200);
    }

    /**
     * Get all absensi (Admin)
     */
    public function getAllAbsensi(Request $request)
    {
        $query = Absensi::with(['mahasiswa:id,nama,email', 'mataKuliah:id,nama_mk,kode_mk'])
            ->orderBy('tanggal', 'desc')
            ->orderBy('jam', 'desc');

        // Filter by mata kuliah
        if ($request->has('mata_kuliah_id')) {
            $query->where('mata_kuliah_id', $request->mata_kuliah_id);
        }

        // Filter by mahasiswa
        if ($request->has('mahasiswa_id')) {
            $query->where('mahasiswa_id', $request->mahasiswa_id);
        }

        // Filter by tanggal
        if ($request->has('tanggal_mulai')) {
            $query->where('tanggal', '>=', $request->tanggal_mulai);
        }
        if ($request->has('tanggal_selesai')) {
            $query->where('tanggal', '<=', $request->tanggal_selesai);
        }

        $absensi = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Data absensi berhasil diambil',
            'data' => $absensi
        ], 200);
    }
}
