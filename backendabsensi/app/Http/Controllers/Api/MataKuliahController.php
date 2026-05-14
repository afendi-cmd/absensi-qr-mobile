<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MataKuliah;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class MataKuliahController extends Controller
{
    /**
     * Display a listing of mata kuliah
     */
    public function index()
    {
        $mataKuliah = MataKuliah::with('dosen:id,nama,email')->orderBy('created_at', 'desc')->get();

        return response()->json([
            'success' => true,
            'message' => 'Data mata kuliah berhasil diambil',
            'data' => $mataKuliah
        ], 200);
    }

    /**
     * Store a newly created mata kuliah
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'nama_mk' => 'required|string|max:100',
            'kode_mk' => 'required|string|max:20|unique:mata_kuliah,kode_mk',
            'dosen_id' => 'required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Validasi dosen role
        $dosen = \App\Models\User::find($request->dosen_id);
        if ($dosen->role !== 'dosen') {
            return response()->json([
                'success' => false,
                'message' => 'User yang dipilih bukan dosen'
            ], 422);
        }

        $mataKuliah = MataKuliah::create($request->all());
        $mataKuliah->load('dosen:id,nama,email');

        return response()->json([
            'success' => true,
            'message' => 'Mata kuliah berhasil ditambahkan',
            'data' => $mataKuliah
        ], 201);
    }

    /**
     * Display the specified mata kuliah
     */
    public function show($id)
    {
        $mataKuliah = MataKuliah::with(['dosen:id,nama,email', 'peserta:id,nama,email'])->find($id);

        if (!$mataKuliah) {
            return response()->json([
                'success' => false,
                'message' => 'Mata kuliah tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Data mata kuliah berhasil diambil',
            'data' => $mataKuliah
        ], 200);
    }

    /**
     * Update the specified mata kuliah
     */
    public function update(Request $request, $id)
    {
        $mataKuliah = MataKuliah::find($id);

        if (!$mataKuliah) {
            return response()->json([
                'success' => false,
                'message' => 'Mata kuliah tidak ditemukan'
            ], 404);
        }

        $validator = Validator::make($request->all(), [
            'nama_mk' => 'sometimes|required|string|max:100',
            'kode_mk' => 'sometimes|required|string|max:20|unique:mata_kuliah,kode_mk,' . $id,
            'dosen_id' => 'sometimes|required|exists:users,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        // Validasi dosen role jika dosen_id diubah
        if ($request->has('dosen_id')) {
            $dosen = \App\Models\User::find($request->dosen_id);
            if ($dosen->role !== 'dosen') {
                return response()->json([
                    'success' => false,
                    'message' => 'User yang dipilih bukan dosen'
                ], 422);
            }
        }

        $mataKuliah->update($request->all());
        $mataKuliah->load('dosen:id,nama,email');

        return response()->json([
            'success' => true,
            'message' => 'Mata kuliah berhasil diupdate',
            'data' => $mataKuliah
        ], 200);
    }

    /**
     * Remove the specified mata kuliah
     */
    public function destroy($id)
    {
        $mataKuliah = MataKuliah::find($id);

        if (!$mataKuliah) {
            return response()->json([
                'success' => false,
                'message' => 'Mata kuliah tidak ditemukan'
            ], 404);
        }

        $mataKuliah->delete();

        return response()->json([
            'success' => true,
            'message' => 'Mata kuliah berhasil dihapus'
        ], 200);
    }

    /**
     * Get mata kuliah yang diajar oleh dosen (untuk dosen)
     */
    public function getMataKuliahDosen(Request $request)
    {
        $mataKuliah = MataKuliah::where('dosen_id', $request->user()->id)
            ->with('peserta:id,nama,email')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data mata kuliah berhasil diambil',
            'data' => $mataKuliah
        ], 200);
    }

    /**
     * Get mata kuliah yang diambil oleh mahasiswa (untuk mahasiswa)
     */
    public function getMataKuliahMahasiswa(Request $request)
    {
        $user = $request->user();
        $mataKuliah = $user->mataKuliahDiambil()->with('dosen:id,nama,email')->get();

        return response()->json([
            'success' => true,
            'message' => 'Data mata kuliah berhasil diambil',
            'data' => $mataKuliah
        ], 200);
    }
}
