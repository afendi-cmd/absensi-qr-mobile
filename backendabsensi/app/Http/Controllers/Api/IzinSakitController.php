<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\IzinSakit;
use App\Models\MataKuliah;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class IzinSakitController extends Controller
{
    /**
     * Ajukan izin/sakit (Mahasiswa).
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mata_kuliah_id' => 'nullable|exists:mata_kuliah,id',
            'tanggal' => 'required|date',
            'jenis' => 'required|in:izin,sakit',
            'alasan' => 'required|string',
            'file_surat' => 'nullable|file|mimes:pdf,jpg,jpeg,png|max:5120',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $data = [
            'mahasiswa_id' => $request->user()->id,
            'mata_kuliah_id' => $request->mata_kuliah_id,
            'tanggal' => $request->tanggal,
            'jenis' => $request->jenis,
            'alasan' => $request->alasan,
            'status' => 'pending',
        ];

        if ($request->hasFile('file_surat')) {
            $file = $request->file('file_surat');
            $filename = time() . '_' . $request->user()->id . '_' . $file->getClientOriginalName();
            $data['file_surat'] = $file->storeAs('izin_sakit', $filename, 'public');
        }

        $izin = IzinSakit::create($data);
        $izin->load('mataKuliah:id,nama_mk,kode_mk');

        return response()->json([
            'success' => true,
            'message' => 'Pengajuan izin/sakit berhasil dikirim',
            'data' => $izin
        ], 201);
    }

    /**
     * Daftar pengajuan milik mahasiswa yang login.
     */
    public function getMine(Request $request)
    {
        $izin = IzinSakit::where('mahasiswa_id', $request->user()->id)
            ->with(['mataKuliah:id,nama_mk,kode_mk', 'reviewer:id,nama'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data pengajuan berhasil diambil',
            'data' => $izin
        ], 200);
    }

    /**
     * Daftar pengajuan untuk mata kuliah yang diampu dosen.
     */
    public function index(Request $request)
    {
        $mataKuliahIds = MataKuliah::where('dosen_id', $request->user()->id)->pluck('id');

        $izin = IzinSakit::whereIn('mata_kuliah_id', $mataKuliahIds)
            ->with(['mahasiswa:id,nama,nim', 'mataKuliah:id,nama_mk,kode_mk'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data pengajuan berhasil diambil',
            'data' => $izin
        ], 200);
    }

    /**
     * Tinjau pengajuan (setujui/tolak) oleh Dosen.
     */
    public function review(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'status' => 'required|in:disetujui,ditolak',
            'catatan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $izin = IzinSakit::find($id);
        if (!$izin) {
            return response()->json(['success' => false, 'message' => 'Pengajuan tidak ditemukan'], 404);
        }

        // Validasi dosen mengampu mata kuliah terkait
        $mk = MataKuliah::find($izin->mata_kuliah_id);
        if (!$mk || $mk->dosen_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak berwenang meninjau pengajuan ini'
            ], 403);
        }

        $izin->update([
            'status' => $request->status,
            'catatan' => $request->catatan,
            'reviewed_by' => $request->user()->id,
        ]);

        $izin->load(['mahasiswa:id,nama,nim', 'mataKuliah:id,nama_mk,kode_mk', 'reviewer:id,nama']);

        AuditLog::record('review_izin', "Pengajuan #{$izin->id} di-{$request->status}");

        return response()->json([
            'success' => true,
            'message' => 'Pengajuan berhasil ditinjau',
            'data' => $izin
        ], 200);
    }

    /**
     * Semua pengajuan (Admin).
     */
    public function allIndex()
    {
        $izin = IzinSakit::with(['mahasiswa:id,nama,nim', 'mataKuliah:id,nama_mk,kode_mk', 'reviewer:id,nama'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data pengajuan berhasil diambil',
            'data' => $izin
        ], 200);
    }
}
