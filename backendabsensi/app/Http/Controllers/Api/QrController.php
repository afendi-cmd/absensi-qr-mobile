<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\QrSession;
use App\Models\MataKuliah;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Str;
use Carbon\Carbon;

class QrController extends Controller
{
    /**
     * Generate QR Code for absensi
     */
    public function generate(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mata_kuliah_id' => 'required|exists:mata_kuliah,id',
            'duration' => 'required|integer|min:1|max:60', // durasi dalam menit
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Validasi dosen mengajar mata kuliah ini
        $mataKuliah = MataKuliah::find($request->mata_kuliah_id);
        if ($mataKuliah->dosen_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak mengajar mata kuliah ini'
            ], 403);
        }

        // Generate unique QR code
        $kodeQr = Str::random(32) . '-' . time();
        $expiredAt = Carbon::now()->addMinutes($request->duration);

        $qrSession = QrSession::create([
            'mata_kuliah_id' => $request->mata_kuliah_id,
            'kode_qr' => $kodeQr,
            'expired_at' => $expiredAt,
        ]);

        $qrSession->load('mataKuliah:id,nama_mk,kode_mk');

        AuditLog::record('Absensi', 'Generate QR', "Generate QR untuk {$mataKuliah->nama_mk} ({$request->duration} mnt)", $request->user()->id);

        return response()->json([
            'success' => true,
            'message' => 'QR Code berhasil digenerate',
            'data' => [
                'id' => $qrSession->id,
                'kode_qr' => $qrSession->kode_qr,
                'mata_kuliah' => $qrSession->mataKuliah,
                'expired_at' => $qrSession->expired_at->format('Y-m-d H:i:s'),
                'duration_minutes' => $request->duration,
            ]
        ], 201);
    }

    /**
     * Get QR sessions history
     */
    public function index(Request $request)
    {
        $query = QrSession::with('mataKuliah:id,nama_mk,kode_mk')
            ->whereHas('mataKuliah', function($q) use ($request) {
                $q->where('dosen_id', $request->user()->id);
            })
            ->orderBy('created_at', 'desc');

        // Filter by mata kuliah
        if ($request->has('mata_kuliah_id')) {
            $query->where('mata_kuliah_id', $request->mata_kuliah_id);
        }

        // Filter by status (active/expired)
        if ($request->has('status')) {
            if ($request->status === 'active') {
                $query->where('expired_at', '>', Carbon::now());
            } elseif ($request->status === 'expired') {
                $query->where('expired_at', '<=', Carbon::now());
            }
        }

        $qrSessions = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Data QR sessions berhasil diambil',
            'data' => $qrSessions
        ], 200);
    }

    /**
     * Get QR session detail with attendances
     */
    public function show($id)
    {
        $qrSession = QrSession::with([
            'mataKuliah:id,nama_mk,kode_mk',
            'absensi.mahasiswa:id,nama,nim'
        ])->find($id);

        if (!$qrSession) {
            return response()->json([
                'success' => false,
                'message' => 'QR Session tidak ditemukan'
            ], 404);
        }

        // Validasi dosen
        if ($qrSession->mataKuliah->dosen_id !== auth()->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak memiliki akses ke QR session ini'
            ], 403);
        }

        $attendances = $qrSession->absensi->map(function($absen) {
            return [
                'id' => $absen->id,
                'mahasiswa' => [
                    'id' => $absen->mahasiswa->id,
                    'nama' => $absen->mahasiswa->nama,
                    'nim' => $absen->mahasiswa->nim,
                ],
                'waktu_absen' => $absen->created_at->format('Y-m-d H:i:s'),
                'status' => $absen->status,
            ];
        });

        return response()->json([
            'success' => true,
            'message' => 'Data QR session berhasil diambil',
            'data' => [
                'id' => $qrSession->id,
                'kode_qr' => $qrSession->kode_qr,
                'mata_kuliah' => $qrSession->mataKuliah,
                'expired_at' => $qrSession->expired_at->format('Y-m-d H:i:s'),
                'is_active' => $qrSession->isActive(),
                'total_hadir' => $attendances->count(),
                'attendances' => $attendances,
            ]
        ], 200);
    }

    /**
     * Close QR session manually
     */
    public function close($id)
    {
        $qrSession = QrSession::with('mataKuliah')->find($id);

        if (!$qrSession) {
            return response()->json([
                'success' => false,
                'message' => 'QR Session tidak ditemukan'
            ], 404);
        }

        // Validasi dosen
        if ($qrSession->mataKuliah->dosen_id !== auth()->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak memiliki akses ke QR session ini'
            ], 403);
        }

        // Set expired_at to now
        $qrSession->expired_at = Carbon::now();
        $qrSession->save();

        return response()->json([
            'success' => true,
            'message' => 'QR Session berhasil ditutup',
            'data' => $qrSession
        ], 200);
    }
}
