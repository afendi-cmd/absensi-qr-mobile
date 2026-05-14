<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Materi;
use App\Models\MataKuliah;
use App\Models\PesertaMk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;

class MateriController extends Controller
{
    /**
     * Display a listing of materi (Dosen)
     */
    public function index(Request $request)
    {
        $query = Materi::with('mataKuliah:id,nama_mk,kode_mk')
            ->whereHas('mataKuliah', function($q) use ($request) {
                $q->where('dosen_id', $request->user()->id);
            })
            ->orderBy('created_at', 'desc');

        // Filter by mata kuliah
        if ($request->has('mata_kuliah_id')) {
            $query->where('mata_kuliah_id', $request->mata_kuliah_id);
        }

        $materi = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Data materi berhasil diambil',
            'data' => $materi
        ], 200);
    }

    /**
     * Store a newly created materi (Dosen)
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mata_kuliah_id' => 'required|exists:mata_kuliah,id',
            'judul' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'file_materi' => 'required|file|mimes:pdf,doc,docx,ppt,pptx|max:20480', // max 20MB
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

        // Upload file materi
        $file = $request->file('file_materi');
        $filename = time() . '_' . $file->getClientOriginalName();
        $path = $file->storeAs('materi', $filename, 'public');

        $materi = Materi::create([
            'mata_kuliah_id' => $request->mata_kuliah_id,
            'judul' => $request->judul,
            'deskripsi' => $request->deskripsi,
            'file_materi' => $path,
        ]);

        $materi->load('mataKuliah:id,nama_mk,kode_mk');

        return response()->json([
            'success' => true,
            'message' => 'Materi berhasil diupload',
            'data' => $materi
        ], 201);
    }

    /**
     * Display the specified materi
     */
    public function show($id)
    {
        $materi = Materi::with('mataKuliah:id,nama_mk,kode_mk')->find($id);

        if (!$materi) {
            return response()->json([
                'success' => false,
                'message' => 'Materi tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Data materi berhasil diambil',
            'data' => $materi
        ], 200);
    }

    /**
     * Remove the specified materi (Dosen)
     */
    public function destroy(Request $request, $id)
    {
        $materi = Materi::find($id);

        if (!$materi) {
            return response()->json([
                'success' => false,
                'message' => 'Materi tidak ditemukan'
            ], 404);
        }

        // Validasi dosen mengajar mata kuliah ini
        $mataKuliah = MataKuliah::find($materi->mata_kuliah_id);
        if ($mataKuliah->dosen_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak mengajar mata kuliah ini'
            ], 403);
        }

        // Hapus file
        if ($materi->file_materi) {
            Storage::disk('public')->delete($materi->file_materi);
        }

        $materi->delete();

        return response()->json([
            'success' => true,
            'message' => 'Materi berhasil dihapus'
        ], 200);
    }

    /**
     * Get materi untuk mahasiswa
     */
    public function getMateriMahasiswa(Request $request)
    {
        // Get mata kuliah yang diambil mahasiswa
        $mataKuliahIds = PesertaMk::where('mahasiswa_id', $request->user()->id)
            ->pluck('mata_kuliah_id');

        $query = Materi::with(['mataKuliah:id,nama_mk,kode_mk'])
            ->whereIn('mata_kuliah_id', $mataKuliahIds)
            ->orderBy('created_at', 'desc');

        // Filter by mata kuliah
        if ($request->has('mata_kuliah_id')) {
            $query->where('mata_kuliah_id', $request->mata_kuliah_id);
        }

        $materi = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Data materi berhasil diambil',
            'data' => $materi
        ], 200);
    }
}
