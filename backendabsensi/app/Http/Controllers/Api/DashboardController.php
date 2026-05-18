<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\MataKuliah;
use App\Models\Absensi;
use App\Models\PesertaMk;
use App\Models\Tugas;
use App\Models\PengumpulanTugas;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DashboardController extends Controller
{
    /**
     * Get Admin Dashboard Statistics
     */
    public function adminStats()
    {
        try {
            $totalMataKuliah = MataKuliah::count();
            $totalDosen = User::where('role', 'dosen')->count();
            $totalMahasiswa = User::where('role', 'mahasiswa')->count();
            $totalAbsensiHariIni = Absensi::whereDate('tanggal', Carbon::today())->count();

            return response()->json([
                'success' => true,
                'data' => [
                    'total_mata_kuliah' => $totalMataKuliah,
                    'total_dosen' => $totalDosen,
                    'total_mahasiswa' => $totalMahasiswa,
                    'total_absensi_hari_ini' => $totalAbsensiHariIni,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load admin statistics',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get Mahasiswa Dashboard Statistics
     */
    public function mahasiswaStats($mahasiswaId)
    {
        try {
            // Total mata kuliah yang diikuti
            $totalMataKuliah = PesertaMk::where('mahasiswa_id', $mahasiswaId)->count();

            // Hitung persentase kehadiran
            $totalAbsensi = Absensi::where('mahasiswa_id', $mahasiswaId)->count();
            $totalHadir = Absensi::where('mahasiswa_id', $mahasiswaId)
                ->where('status', 'hadir')
                ->count();
            
            $persentaseKehadiran = $totalAbsensi > 0 
                ? ($totalHadir / $totalAbsensi) * 100 
                : 0;

            // Hitung tugas
            $mataKuliahIds = PesertaMk::where('mahasiswa_id', $mahasiswaId)
                ->pluck('mata_kuliah_id');
            
            $totalTugas = Tugas::whereIn('mata_kuliah_id', $mataKuliahIds)->count();
            
            $tugasSelesai = PengumpulanTugas::where('mahasiswa_id', $mahasiswaId)
                ->whereNotNull('file_path')
                ->count();
            
            $tugasPending = $totalTugas - $tugasSelesai;

            return response()->json([
                'success' => true,
                'data' => [
                    'total_mata_kuliah' => $totalMataKuliah,
                    'persentase_kehadiran' => round($persentaseKehadiran, 2),
                    'tugas_selesai' => $tugasSelesai,
                    'tugas_pending' => max(0, $tugasPending),
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load mahasiswa statistics',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    /**
     * Get Dosen Dashboard Statistics
     */
    public function dosenStats($dosenId)
    {
        try {
            $totalMataKuliah = MataKuliah::where('dosen_id', $dosenId)->count();
            
            $mataKuliahIds = MataKuliah::where('dosen_id', $dosenId)
                ->pluck('id');
            
            $totalMahasiswa = PesertaMk::whereIn('mata_kuliah_id', $mataKuliahIds)
                ->distinct('mahasiswa_id')
                ->count();
            
            $totalAbsensiHariIni = Absensi::whereIn('mata_kuliah_id', $mataKuliahIds)
                ->whereDate('tanggal', Carbon::today())
                ->count();
            
            $totalTugas = Tugas::whereIn('mata_kuliah_id', $mataKuliahIds)->count();

            return response()->json([
                'success' => true,
                'data' => [
                    'total_mata_kuliah' => $totalMataKuliah,
                    'total_mahasiswa' => $totalMahasiswa,
                    'total_absensi_hari_ini' => $totalAbsensiHariIni,
                    'total_tugas' => $totalTugas,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load dosen statistics',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
