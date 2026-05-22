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

    /**
     * Get Advanced Statistics for Admin (Chart Data)
     */
    public function advancedStats()
    {
        try {
            // Absensi per hari (7 hari terakhir)
            $absensiPerHari = [];
            for ($i = 6; $i >= 0; $i--) {
                $date = Carbon::today()->subDays($i);
                $count = Absensi::whereDate('created_at', $date)->count();
                $absensiPerHari[] = [
                    'date' => $date->format('Y-m-d'),
                    'day' => $date->format('D'),
                    'count' => $count
                ];
            }

            // Absensi per mata kuliah (Top 5)
            $absensiPerMataKuliah = DB::table('absensi')
                ->join('mata_kuliah', 'absensi.mata_kuliah_id', '=', 'mata_kuliah.id')
                ->select('mata_kuliah.nama_mk', DB::raw('count(*) as total'))
                ->groupBy('mata_kuliah.id', 'mata_kuliah.nama_mk')
                ->orderBy('total', 'desc')
                ->limit(5)
                ->get();

            // Persentase kehadiran per mata kuliah
            $mataKuliahList = MataKuliah::with('dosen:id,nama')->get();
            $persentasePerMataKuliah = [];

            foreach ($mataKuliahList as $mk) {
                $totalPeserta = PesertaMk::where('mata_kuliah_id', $mk->id)->count();
                $totalPertemuan = Absensi::where('mata_kuliah_id', $mk->id)
                    ->distinct('qr_session_id')
                    ->count('qr_session_id');
                
                $totalAbsensi = Absensi::where('mata_kuliah_id', $mk->id)->count();
                $expectedAbsensi = $totalPeserta * $totalPertemuan;
                
                $persentase = $expectedAbsensi > 0 
                    ? round(($totalAbsensi / $expectedAbsensi) * 100, 2)
                    : 0;

                $persentasePerMataKuliah[] = [
                    'mata_kuliah' => $mk->nama_mk,
                    'kode_mk' => $mk->kode_mk,
                    'dosen' => $mk->dosen->nama ?? '-',
                    'total_peserta' => $totalPeserta,
                    'total_pertemuan' => $totalPertemuan,
                    'persentase_kehadiran' => $persentase
                ];
            }

            // Statistik user per role
            $userStats = [
                'admin' => User::where('role', 'admin')->count(),
                'dosen' => User::where('role', 'dosen')->count(),
                'mahasiswa' => User::where('role', 'mahasiswa')->count(),
            ];

            // Aktivitas terbaru
            $recentActivities = Absensi::with(['mahasiswa:id,nama', 'mataKuliah:id,nama_mk'])
                ->orderBy('created_at', 'desc')
                ->limit(10)
                ->get()
                ->map(function($item) {
                    return [
                        'user' => $item->mahasiswa->nama ?? '-',
                        'mata_kuliah' => $item->mataKuliah->nama_mk ?? '-',
                        'timestamp' => $item->created_at->format('Y-m-d H:i:s'),
                        'time_ago' => $item->created_at->diffForHumans()
                    ];
                });

            return response()->json([
                'success' => true,
                'data' => [
                    'absensi_per_hari' => $absensiPerHari,
                    'absensi_per_mata_kuliah' => $absensiPerMataKuliah,
                    'persentase_per_mata_kuliah' => $persentasePerMataKuliah,
                    'user_stats' => $userStats,
                    'recent_activities' => $recentActivities
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Failed to load advanced statistics',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
