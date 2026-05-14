<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\QrSession;
use App\Models\MataKuliah;
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
}
