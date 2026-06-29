<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Absensi;
use App\Models\User;
use App\Models\MataKuliah;
use App\Models\PesertaMk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ExportController extends Controller
{
    // Export absensi to CSV
    public function exportAbsensi(Request $request)
    {
        try {
            $mataKuliahId = $request->query('mata_kuliah_id');
            $startDate = $request->query('start_date');
            $endDate = $request->query('end_date');

            $query = Absensi::with(['mahasiswa:id,nama,nim', 'mataKuliah:id,nama_mk,kode_mk', 'qrSession'])
                ->orderBy('created_at', 'desc');

            if ($mataKuliahId) {
                $query->where('mata_kuliah_id', $mataKuliahId);
            }

            if ($startDate) {
                $query->whereDate('created_at', '>=', $startDate);
            }

            if ($endDate) {
                $query->whereDate('created_at', '<=', $endDate);
            }

            $absensi = $query->get();

            // Generate CSV
            $csvData = "No,NIM,Nama Mahasiswa,Mata Kuliah,Kode MK,Tanggal,Waktu,Status\n";
            
            foreach ($absensi as $index => $item) {
                $csvData .= ($index + 1) . ",";
                $csvData .= '"' . ($item->mahasiswa->nim ?? '-') . '",';
                $csvData .= '"' . ($item->mahasiswa->nama ?? '-') . '",';
                $csvData .= '"' . ($item->mataKuliah->nama_mk ?? '-') . '",';
                $csvData .= '"' . ($item->mataKuliah->kode_mk ?? '-') . '",';
                $csvData .= '"' . $item->created_at->format('Y-m-d') . '",';
                $csvData .= '"' . $item->created_at->format('H:i:s') . '",';
                $csvData .= '"Hadir"' . "\n";
            }

            return response()->json([
                'success' => true,
                'message' => 'Data absensi berhasil diekspor',
                'data' => [
                    'csv' => base64_encode($csvData),
                    'filename' => 'absensi_' . date('Y-m-d_His') . '.csv',
                    'total_records' => $absensi->count()
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengekspor data absensi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Export rekap absensi per mahasiswa
    public function exportRekapMahasiswa(Request $request)
    {
        try {
            $mataKuliahId = $request->query('mata_kuliah_id');

            if (!$mataKuliahId) {
                return response()->json([
                    'success' => false,
                    'message' => 'Mata kuliah ID harus diisi'
                ], 422);
            }

            $mataKuliah = MataKuliah::findOrFail($mataKuliahId);
            
            // Get all peserta
            $peserta = PesertaMk::where('mata_kuliah_id', $mataKuliahId)
                ->with('mahasiswa:id,nama,nim')
                ->get();

            // Get total pertemuan
            $totalPertemuan = Absensi::where('mata_kuliah_id', $mataKuliahId)
                ->distinct('qr_session_id')
                ->count('qr_session_id');

            $csvData = "No,NIM,Nama Mahasiswa,Total Hadir,Total Pertemuan,Persentase\n";

            foreach ($peserta as $index => $item) {
                $totalHadir = Absensi::where('mata_kuliah_id', $mataKuliahId)
                    ->where('mahasiswa_id', $item->mahasiswa_id)
                    ->count();

                $persentase = $totalPertemuan > 0 ? round(($totalHadir / $totalPertemuan) * 100, 2) : 0;

                $csvData .= ($index + 1) . ",";
                $csvData .= '"' . ($item->mahasiswa->nim ?? '-') . '",';
                $csvData .= '"' . ($item->mahasiswa->nama ?? '-') . '",';
                $csvData .= $totalHadir . ",";
                $csvData .= $totalPertemuan . ",";
                $csvData .= $persentase . "%\n";
            }

            return response()->json([
                'success' => true,
                'message' => 'Rekap absensi berhasil diekspor',
                'data' => [
                    'csv' => base64_encode($csvData),
                    'filename' => 'rekap_' . $mataKuliah->kode_mk . '_' . date('Y-m-d_His') . '.csv',
                    'total_records' => $peserta->count()
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengekspor rekap absensi',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Export data mahasiswa
    public function exportMahasiswa()
    {
        try {
            $mahasiswa = User::where('role', 'mahasiswa')
                ->orderBy('nama')
                ->get();

            $csvData = "No,NIM,Nama,Email,No HP,Alamat,Tanggal Daftar\n";

            foreach ($mahasiswa as $index => $item) {
                $csvData .= ($index + 1) . ",";
                $csvData .= '"' . ($item->nim ?? '-') . '",';
                $csvData .= '"' . $item->nama . '",';
                $csvData .= '"' . $item->email . '",';
                $csvData .= '"' . ($item->no_hp ?? '-') . '",';
                $csvData .= '"' . ($item->alamat ?? '-') . '",';
                $csvData .= '"' . $item->created_at->format('Y-m-d') . '"' . "\n";
            }

            return response()->json([
                'success' => true,
                'message' => 'Data mahasiswa berhasil diekspor',
                'data' => [
                    'csv' => base64_encode($csvData),
                    'filename' => 'mahasiswa_' . date('Y-m-d_His') . '.csv',
                    'total_records' => $mahasiswa->count()
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengekspor data mahasiswa',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Export data dosen
    public function exportDosen()
    {
        try {
            $dosen = User::where('role', 'dosen')
                ->orderBy('nama')
                ->get();

            $csvData = "No,NIDN,Nama,Email,No HP,Alamat,Tanggal Daftar\n";

            foreach ($dosen as $index => $item) {
                $csvData .= ($index + 1) . ",";
                $csvData .= '"' . ($item->nidn ?? '-') . '",';
                $csvData .= '"' . $item->nama . '",';
                $csvData .= '"' . $item->email . '",';
                $csvData .= '"' . ($item->no_hp ?? '-') . '",';
                $csvData .= '"' . ($item->alamat ?? '-') . '",';
                $csvData .= '"' . $item->created_at->format('Y-m-d') . '"' . "\n";
            }

            return response()->json([
                'success' => true,
                'message' => 'Data dosen berhasil diekspor',
                'data' => [
                    'csv' => base64_encode($csvData),
                    'filename' => 'dosen_' . date('Y-m-d_His') . '.csv',
                    'total_records' => $dosen->count()
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengekspor data dosen',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    // Export data mata kuliah
    public function exportMataKuliah()
    {
        try {
            $mataKuliah = MataKuliah::with('dosen:id,nama,nidn')
                ->orderBy('nama_mk')
                ->get();

            $csvData = "No,Kode MK,Nama Mata Kuliah,SKS,Semester,Dosen Pengajar,NIDN\n";

            foreach ($mataKuliah as $index => $item) {
                $csvData .= ($index + 1) . ",";
                $csvData .= '"' . $item->kode_mk . '",';
                $csvData .= '"' . $item->nama_mk . '",';
                $csvData .= $item->sks . ",";
                $csvData .= $item->semester . ",";
                $csvData .= '"' . ($item->dosen->nama ?? '-') . '",';
                $csvData .= '"' . ($item->dosen->nidn ?? '-') . '"' . "\n";
            }

            return response()->json([
                'success' => true,
                'message' => 'Data mata kuliah berhasil diekspor',
                'data' => [
                    'csv' => base64_encode($csvData),
                    'filename' => 'mata_kuliah_' . date('Y-m-d_His') . '.csv',
                    'total_records' => $mataKuliah->count()
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengekspor data mata kuliah',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}
