<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Tugas;
use App\Models\PengumpulanTugas;
use App\Models\MataKuliah;
use App\Models\PesertaMk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;

class TugasController extends Controller
{
    /**
     * Display a listing of tugas (Dosen)
     */
    public function index(Request $request)
    {
        $query = Tugas::with('mataKuliah:id,nama_mk,kode_mk')
            ->whereHas('mataKuliah', function($q) use ($request) {
                $q->where('dosen_id', $request->user()->id);
            })
            ->orderBy('deadline', 'desc');

        // Filter by mata kuliah
        if ($request->has('mata_kuliah_id')) {
            $query->where('mata_kuliah_id', $request->mata_kuliah_id);
        }

        $tugas = $query->get();

        return response()->json([
            'success' => true,
            'message' => 'Data tugas berhasil diambil',
            'data' => $tugas
        ], 200);
    }

    /**
     * Store a newly created tugas (Dosen)
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mata_kuliah_id' => 'required|exists:mata_kuliah,id',
            'judul' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'file_tugas' => 'nullable|file|mimes:pdf,doc,docx|max:10240', // max 10MB
            'deadline' => 'required|date',
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

        $data = $request->except('file_tugas');

        // Upload file tugas jika ada
        if ($request->hasFile('file_tugas')) {
            $file = $request->file('file_tugas');
            $filename = time() . '_' . $file->getClientOriginalName();
            $path = $file->storeAs('tugas', $filename, 'public');
            $data['file_tugas'] = $path;
        }

        $tugas = Tugas::create($data);
        $tugas->load('mataKuliah:id,nama_mk,kode_mk');

        return response()->json([
            'success' => true,
            'message' => 'Tugas berhasil ditambahkan',
            'data' => $tugas
        ], 201);
    }

    /**
     * Display the specified tugas
     */
    public function show($id)
    {
        $tugas = Tugas::with('mataKuliah:id,nama_mk,kode_mk')->find($id);

        if (!$tugas) {
            return response()->json([
                'success' => false,
                'message' => 'Tugas tidak ditemukan'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Data tugas berhasil diambil',
            'data' => $tugas
        ], 200);
    }

    /**
     * Update the specified tugas (Dosen)
     */
    public function update(Request $request, $id)
    {
        $tugas = Tugas::find($id);

        if (!$tugas) {
            return response()->json([
                'success' => false,
                'message' => 'Tugas tidak ditemukan'
            ], 404);
        }

        // Validasi dosen mengajar mata kuliah ini
        $mataKuliah = MataKuliah::find($tugas->mata_kuliah_id);
        if ($mataKuliah->dosen_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak mengajar mata kuliah ini'
            ], 403);
        }

        $validator = Validator::make($request->all(), [
            'judul' => 'sometimes|required|string|max:255',
            'deskripsi' => 'nullable|string',
            'file_tugas' => 'nullable|file|mimes:pdf,doc,docx|max:10240',
            'deadline' => 'sometimes|required|date',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $data = $request->except('file_tugas');

        // Upload file tugas baru jika ada
        if ($request->hasFile('file_tugas')) {
            // Hapus file lama
            if ($tugas->file_tugas) {
                Storage::disk('public')->delete($tugas->file_tugas);
            }

            $file = $request->file('file_tugas');
            $filename = time() . '_' . $file->getClientOriginalName();
            $path = $file->storeAs('tugas', $filename, 'public');
            $data['file_tugas'] = $path;
        }

        $tugas->update($data);
        $tugas->load('mataKuliah:id,nama_mk,kode_mk');

        return response()->json([
            'success' => true,
            'message' => 'Tugas berhasil diupdate',
            'data' => $tugas
        ], 200);
    }

    /**
     * Remove the specified tugas (Dosen)
     */
    public function destroy($id)
    {
        $tugas = Tugas::find($id);

        if (!$tugas) {
            return response()->json([
                'success' => false,
                'message' => 'Tugas tidak ditemukan'
            ], 404);
        }

        // Hapus file jika ada
        if ($tugas->file_tugas) {
            Storage::disk('public')->delete($tugas->file_tugas);
        }

        $tugas->delete();

        return response()->json([
            'success' => true,
            'message' => 'Tugas berhasil dihapus'
        ], 200);
    }

    /**
     * Upload tugas (Mahasiswa)
     */
    public function uploadTugas(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'tugas_id' => 'required|exists:tugas,id',
            'file_jawaban' => 'required|file|mimes:pdf,doc,docx|max:10240', // max 10MB
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $tugas = Tugas::find($request->tugas_id);

        // Validasi mahasiswa terdaftar pada mata kuliah
        $isPeserta = PesertaMk::where('mahasiswa_id', $request->user()->id)
            ->where('mata_kuliah_id', $tugas->mata_kuliah_id)
            ->exists();

        if (!$isPeserta) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak terdaftar pada mata kuliah ini'
            ], 403);
        }

        // Check if already submitted
        $existingPengumpulan = PengumpulanTugas::where('tugas_id', $request->tugas_id)
            ->where('mahasiswa_id', $request->user()->id)
            ->first();

        // Upload file jawaban
        $file = $request->file('file_jawaban');
        $filename = time() . '_' . $request->user()->id . '_' . $file->getClientOriginalName();
        $path = $file->storeAs('pengumpulan_tugas', $filename, 'public');

        if ($existingPengumpulan) {
            // Update existing submission
            // Hapus file lama
            if ($existingPengumpulan->file_jawaban) {
                Storage::disk('public')->delete($existingPengumpulan->file_jawaban);
            }

            $existingPengumpulan->update([
                'file_jawaban' => $path,
                'tanggal_upload' => Carbon::now(),
            ]);

            $pengumpulan = $existingPengumpulan;
            $message = 'Tugas berhasil diupdate';
        } else {
            // Create new submission
            $pengumpulan = PengumpulanTugas::create([
                'tugas_id' => $request->tugas_id,
                'mahasiswa_id' => $request->user()->id,
                'file_jawaban' => $path,
                'tanggal_upload' => Carbon::now(),
            ]);

            $message = 'Tugas berhasil dikumpulkan';
        }

        $pengumpulan->load(['tugas.mataKuliah:id,nama_mk,kode_mk']);

        return response()->json([
            'success' => true,
            'message' => $message,
            'data' => $pengumpulan
        ], 201);
    }

    /**
     * Get tugas untuk mahasiswa
     */
    public function getTugasMahasiswa(Request $request)
    {
        // Get mata kuliah yang diambil mahasiswa
        $mataKuliahIds = PesertaMk::where('mahasiswa_id', $request->user()->id)
            ->pluck('mata_kuliah_id');

        $query = Tugas::with(['mataKuliah:id,nama_mk,kode_mk'])
            ->whereIn('mata_kuliah_id', $mataKuliahIds)
            ->orderBy('deadline', 'desc');

        // Filter by mata kuliah
        if ($request->has('mata_kuliah_id')) {
            $query->where('mata_kuliah_id', $request->mata_kuliah_id);
        }

        $tugas = $query->get();

        // Add status pengumpulan
        $tugas->each(function($item) use ($request) {
            $pengumpulan = PengumpulanTugas::where('tugas_id', $item->id)
                ->where('mahasiswa_id', $request->user()->id)
                ->first();
            
            $item->sudah_dikumpulkan = $pengumpulan ? true : false;
            $item->pengumpulan = $pengumpulan;
        });

        return response()->json([
            'success' => true,
            'message' => 'Data tugas berhasil diambil',
            'data' => $tugas
        ], 200);
    }

    /**
     * Get pengumpulan tugas mahasiswa
     */
    public function getPengumpulanMahasiswa(Request $request)
    {
        $pengumpulan = PengumpulanTugas::where('mahasiswa_id', $request->user()->id)
            ->with(['tugas.mataKuliah:id,nama_mk,kode_mk'])
            ->orderBy('tanggal_upload', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data pengumpulan tugas berhasil diambil',
            'data' => $pengumpulan
        ], 200);
    }

    /**
     * Get pengumpulan tugas by tugas_id (Dosen)
     */
    public function getPengumpulan($id)
    {
        $tugas = Tugas::find($id);

        if (!$tugas) {
            return response()->json([
                'success' => false,
                'message' => 'Tugas tidak ditemukan'
            ], 404);
        }

        $pengumpulan = PengumpulanTugas::where('tugas_id', $id)
            ->with(['mahasiswa:id,nama,email'])
            ->orderBy('tanggal_upload', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data pengumpulan tugas berhasil diambil',
            'data' => [
                'tugas' => $tugas,
                'pengumpulan' => $pengumpulan
            ]
        ], 200);
    }

    /**
     * Beri nilai pada pengumpulan tugas (Dosen)
     */
    public function beriNilai(Request $request, $id)
    {
        $validator = Validator::make($request->all(), [
            'nilai' => 'required|integer|min:0|max:100',
            'catatan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $pengumpulan = PengumpulanTugas::find($id);

        if (!$pengumpulan) {
            return response()->json([
                'success' => false,
                'message' => 'Pengumpulan tugas tidak ditemukan'
            ], 404);
        }

        // Validasi dosen mengajar mata kuliah ini
        $tugas = Tugas::find($pengumpulan->tugas_id);
        $mataKuliah = MataKuliah::find($tugas->mata_kuliah_id);
        
        if ($mataKuliah->dosen_id !== $request->user()->id) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak mengajar mata kuliah ini'
            ], 403);
        }

        $pengumpulan->update([
            'nilai' => $request->nilai,
            'catatan' => $request->catatan,
        ]);

        $pengumpulan->load(['mahasiswa:id,nama,email', 'tugas']);

        return response()->json([
            'success' => true,
            'message' => 'Nilai berhasil diberikan',
            'data' => $pengumpulan
        ], 200);
    }
}
