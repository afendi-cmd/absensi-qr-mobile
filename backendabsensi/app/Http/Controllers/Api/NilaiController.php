<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Nilai;
use App\Models\MataKuliah;
use App\Models\PesertaMk;
use App\Models\AuditLog;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;

class NilaiController extends Controller
{
    // Bobot komponen nilai akhir
    private const BOBOT_TUGAS = 0.30;
    private const BOBOT_UTS   = 0.30;
    private const BOBOT_UAS   = 0.40;

    /**
     * Hitung nilai akhir & grade huruf dari komponen.
     */
    private function hitung(?float $tugas, ?float $uts, ?float $uas): array
    {
        if ($tugas === null && $uts === null && $uas === null) {
            return [null, null];
        }

        $akhir = round(
            ($tugas ?? 0) * self::BOBOT_TUGAS
            + ($uts ?? 0) * self::BOBOT_UTS
            + ($uas ?? 0) * self::BOBOT_UAS,
            2
        );

        $grade = match (true) {
            $akhir >= 80 => 'A',
            $akhir >= 70 => 'B',
            $akhir >= 60 => 'C',
            $akhir >= 50 => 'D',
            default      => 'E',
        };

        return [$akhir, $grade];
    }

    private function dosenMengajar(int $mataKuliahId, int $dosenId): bool
    {
        $mk = MataKuliah::find($mataKuliahId);
        return $mk && $mk->dosen_id === $dosenId;
    }

    /**
     * Simpan/perbarui nilai mahasiswa pada mata kuliah (Dosen).
     */
    public function store(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'mahasiswa_id' => 'required|exists:users,id',
            'mata_kuliah_id' => 'required|exists:mata_kuliah,id',
            'nilai_tugas' => 'nullable|numeric|min:0|max:100',
            'nilai_uts' => 'nullable|numeric|min:0|max:100',
            'nilai_uas' => 'nullable|numeric|min:0|max:100',
            'catatan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        if (!$this->dosenMengajar($request->mata_kuliah_id, $request->user()->id)) {
            return response()->json([
                'success' => false,
                'message' => 'Anda tidak mengajar mata kuliah ini'
            ], 403);
        }

        // Pastikan mahasiswa peserta mata kuliah
        $isPeserta = PesertaMk::where('mahasiswa_id', $request->mahasiswa_id)
            ->where('mata_kuliah_id', $request->mata_kuliah_id)
            ->exists();
        if (!$isPeserta) {
            return response()->json([
                'success' => false,
                'message' => 'Mahasiswa tidak terdaftar pada mata kuliah ini'
            ], 422);
        }

        [$akhir, $grade] = $this->hitung($request->nilai_tugas, $request->nilai_uts, $request->nilai_uas);

        $nilai = Nilai::updateOrCreate(
            [
                'mahasiswa_id' => $request->mahasiswa_id,
                'mata_kuliah_id' => $request->mata_kuliah_id,
            ],
            [
                'nilai_tugas' => $request->nilai_tugas,
                'nilai_uts' => $request->nilai_uts,
                'nilai_uas' => $request->nilai_uas,
                'nilai_akhir' => $akhir,
                'grade' => $grade,
                'catatan' => $request->catatan,
                'created_by' => $request->user()->id,
            ]
        );

        $nilai->load(['mahasiswa:id,nama,nim', 'mataKuliah:id,nama_mk,kode_mk']);

        AuditLog::record('Nilai', 'Input', "Input nilai mahasiswa #{$request->mahasiswa_id} pada MK #{$request->mata_kuliah_id}");

        return response()->json([
            'success' => true,
            'message' => 'Nilai berhasil disimpan',
            'data' => $nilai
        ], 201);
    }

    /**
     * Update nilai by id (Dosen).
     */
    public function update(Request $request, $id)
    {
        $nilai = Nilai::find($id);
        if (!$nilai) {
            return response()->json(['success' => false, 'message' => 'Nilai tidak ditemukan'], 404);
        }

        if (!$this->dosenMengajar($nilai->mata_kuliah_id, $request->user()->id)) {
            return response()->json(['success' => false, 'message' => 'Anda tidak mengajar mata kuliah ini'], 403);
        }

        $validator = Validator::make($request->all(), [
            'nilai_tugas' => 'nullable|numeric|min:0|max:100',
            'nilai_uts' => 'nullable|numeric|min:0|max:100',
            'nilai_uas' => 'nullable|numeric|min:0|max:100',
            'catatan' => 'nullable|string',
        ]);

        if ($validator->fails()) {
            return response()->json([
                'success' => false,
                'message' => 'Validation error',
                'errors' => $validator->errors()
            ], 422);
        }

        $tugas = $request->has('nilai_tugas') ? $request->nilai_tugas : $nilai->nilai_tugas;
        $uts = $request->has('nilai_uts') ? $request->nilai_uts : $nilai->nilai_uts;
        $uas = $request->has('nilai_uas') ? $request->nilai_uas : $nilai->nilai_uas;

        [$akhir, $grade] = $this->hitung(
            $tugas !== null ? (float) $tugas : null,
            $uts !== null ? (float) $uts : null,
            $uas !== null ? (float) $uas : null
        );

        $nilai->update([
            'nilai_tugas' => $tugas,
            'nilai_uts' => $uts,
            'nilai_uas' => $uas,
            'nilai_akhir' => $akhir,
            'grade' => $grade,
            'catatan' => $request->has('catatan') ? $request->catatan : $nilai->catatan,
        ]);

        $nilai->load(['mahasiswa:id,nama,nim', 'mataKuliah:id,nama_mk,kode_mk']);

        return response()->json([
            'success' => true,
            'message' => 'Nilai berhasil diperbarui',
            'data' => $nilai
        ], 200);
    }

    /**
     * Hapus nilai (Dosen).
     */
    public function destroy(Request $request, $id)
    {
        $nilai = Nilai::find($id);
        if (!$nilai) {
            return response()->json(['success' => false, 'message' => 'Nilai tidak ditemukan'], 404);
        }
        if (!$this->dosenMengajar($nilai->mata_kuliah_id, $request->user()->id)) {
            return response()->json(['success' => false, 'message' => 'Anda tidak mengajar mata kuliah ini'], 403);
        }
        $nilai->delete();
        return response()->json(['success' => true, 'message' => 'Nilai berhasil dihapus'], 200);
    }

    /**
     * Daftar nilai per mata kuliah (Dosen).
     */
    public function getByMataKuliah(Request $request, $id)
    {
        if (!$this->dosenMengajar($id, $request->user()->id)) {
            return response()->json(['success' => false, 'message' => 'Anda tidak mengajar mata kuliah ini'], 403);
        }

        $nilai = Nilai::where('mata_kuliah_id', $id)
            ->with('mahasiswa:id,nama,nim,email')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data nilai berhasil diambil',
            'data' => $nilai
        ], 200);
    }

    /**
     * Nilai milik mahasiswa yang login (transkrip).
     */
    public function getMine(Request $request)
    {
        $nilai = Nilai::where('mahasiswa_id', $request->user()->id)
            ->with('mataKuliah:id,nama_mk,kode_mk,sks')
            ->get();

        $ipk = null;
        $bobot = ['A' => 4, 'B' => 3, 'C' => 2, 'D' => 1, 'E' => 0];
        $totalSks = 0; $totalMutu = 0;
        foreach ($nilai as $n) {
            $sks = (int) (($n->mataKuliah->sks ?? 0));
            if ($n->grade && $sks > 0) {
                $totalSks += $sks;
                $totalMutu += ($bobot[$n->grade] ?? 0) * $sks;
            }
        }
        if ($totalSks > 0) {
            $ipk = round($totalMutu / $totalSks, 2);
        }

        return response()->json([
            'success' => true,
            'message' => 'Data nilai berhasil diambil',
            'data' => [
                'nilai' => $nilai,
                'ipk' => $ipk,
                'total_sks' => $totalSks,
            ]
        ], 200);
    }

    /**
     * Semua nilai (Admin).
     */
    public function index()
    {
        $nilai = Nilai::with(['mahasiswa:id,nama,nim', 'mataKuliah:id,nama_mk,kode_mk', 'dosen:id,nama'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json([
            'success' => true,
            'message' => 'Data nilai berhasil diambil',
            'data' => $nilai
        ], 200);
    }
}
