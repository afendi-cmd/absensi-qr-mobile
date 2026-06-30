<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PesertaMk;
use App\Models\MataKuliah;
use App\Models\User;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class PesertaMkController extends Controller
{
    /**
     * Add mahasiswa to mata kuliah
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mahasiswa_id' => 'required|exists:users,id',
            'mata_kuliah_id' => 'required|exists:mata_kuliah,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Validasi mahasiswa role
        $mahasiswa = User::find($request->mahasiswa_id);
        if ($mahasiswa->role !== 'mahasiswa') {
            return response()->json([
                'success' => false,
                'message' => 'User yang dipilih bukan mahasiswa'
            ], 422);
        }

        // Check if already exists
        $exists = PesertaMk::where('mahasiswa_id', $request->mahasiswa_id)
            ->where('mata_kuliah_id', $request->mata_kuliah_id)
            ->exists();

        if ($exists) {
            return response()->json([
                'success' => false,
                'message' => 'Mahasiswa sudah terdaftar pada mata kuliah ini'
            ], 422);
        }

        $peserta = PesertaMk::create($request->all());
        $peserta->load('mahasiswa:id,nama,email,role', 'mataKuliah:id,nama_mk,kode_mk');

        AuditLog::record('Peserta MK', 'Add', "Menambah {$peserta->mahasiswa->nama} ke {$peserta->mataKuliah->nama_mk}");

        // Format response
        $response = [
            'id' => $peserta->id,
            'mahasiswa_id' => $peserta->mahasiswa_id,
            'mata_kuliah_id' => $peserta->mata_kuliah_id,
            'created_at' => $peserta->created_at,
            'updated_at' => $peserta->updated_at,
            'mahasiswa' => $peserta->mahasiswa ? [
                'id' => $peserta->mahasiswa->id,
                'name' => $peserta->mahasiswa->nama,
                'nama' => $peserta->mahasiswa->nama,
                'email' => $peserta->mahasiswa->email,
                'role' => $peserta->mahasiswa->role,
            ] : null,
            'mata_kuliah' => $peserta->mataKuliah ? [
                'id' => $peserta->mataKuliah->id,
                'nama_mk' => $peserta->mataKuliah->nama_mk,
                'kode_mk' => $peserta->mataKuliah->kode_mk,
            ] : null,
        ];

        return response()->json([
            'success' => true,
            'message' => 'Mahasiswa berhasil ditambahkan ke mata kuliah',
            'data' => $response
        ], 201);
    }

    /**
     * Remove mahasiswa from mata kuliah
     */
    public function destroy($id)
    {
        $peserta = PesertaMk::find($id);

        if (!$peserta) {
            return response()->json([
                'success' => false,
                'message' => 'Data peserta tidak ditemukan'
            ], 404);
        }

        $peserta->delete();

        AuditLog::record('Peserta MK', 'Remove', "Menghapus peserta #{$peserta->mahasiswa_id} dari MK #{$peserta->mata_kuliah_id}");

        return response()->json([
            'success' => true,
            'message' => 'Mahasiswa berhasil dihapus dari mata kuliah'
        ], 200);
    }

    /**
     * Get peserta by mata kuliah
     */
    public function getPesertaByMataKuliah($id)
    {
        $mataKuliah = MataKuliah::find($id);

        if (!$mataKuliah) {
            return response()->json([
                'success' => false,
                'message' => 'Mata kuliah tidak ditemukan'
            ], 404);
        }

        $peserta = PesertaMk::where('mata_kuliah_id', $id)
            ->with('mahasiswa:id,nama,email,role')
            ->get()
            ->map(function ($item) {
                return [
                    'id' => $item->id,
                    'mahasiswa_id' => $item->mahasiswa_id,
                    'mata_kuliah_id' => $item->mata_kuliah_id,
                    'created_at' => $item->created_at,
                    'updated_at' => $item->updated_at,
                    'mahasiswa' => $item->mahasiswa ? [
                        'id' => $item->mahasiswa->id,
                        'name' => $item->mahasiswa->nama,
                        'nama' => $item->mahasiswa->nama,
                        'email' => $item->mahasiswa->email,
                        'role' => $item->mahasiswa->role,
                    ] : null,
                ];
            });

        return response()->json([
            'success' => true,
            'message' => 'Data peserta berhasil diambil',
            'data' => [
                'mata_kuliah' => [
                    'id' => $mataKuliah->id,
                    'kode_mk' => $mataKuliah->kode_mk,
                    'nama_mk' => $mataKuliah->nama_mk,
                    'sks' => $mataKuliah->sks,
                    'semester' => $mataKuliah->semester,
                    'dosen_id' => $mataKuliah->dosen_id,
                ],
                'peserta' => $peserta
            ]
        ], 200);
    }
}
