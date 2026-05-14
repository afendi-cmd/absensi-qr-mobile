<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\PesertaMk;
use App\Models\MataKuliah;
use App\Models\User;
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
        $peserta->load(['mahasiswa:id,nama,email', 'mataKuliah:id,nama_mk,kode_mk']);

        return response()->json([
            'success' => true,
            'message' => 'Mahasiswa berhasil ditambahkan ke mata kuliah',
            'data' => $peserta
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
            ->with('mahasiswa:id,nama,email')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data peserta berhasil diambil',
            'data' => [
                'mata_kuliah' => $mataKuliah,
                'peserta' => $peserta
            ]
        ], 200);
    }
}
