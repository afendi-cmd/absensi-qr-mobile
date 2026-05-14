<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\MataKuliahController;
use App\Http\Controllers\Api\PesertaMkController;
use App\Http\Controllers\Api\QrController;
use App\Http\Controllers\Api\AbsensiController;
use App\Http\Controllers\Api\TugasController;
use App\Http\Controllers\Api\MateriController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

// Public routes
Route::post('/login', [AuthController::class, 'login']);

// Protected routes
Route::middleware('auth:sanctum')->group(function () {
    
    // Logout (semua role)
    Route::post('/logout', [AuthController::class, 'logout']);
    
    // Get authenticated user
    Route::get('/user', function (Request $request) {
        return response()->json([
            'success' => true,
            'data' => $request->user()
        ]);
    });

    // ========== ADMIN ROUTES ==========
    Route::middleware('role:admin')->group(function () {
        // User Management
        Route::get('/users', [UserController::class, 'index']);
        Route::post('/users', [UserController::class, 'store']);
        Route::get('/users/{id}', [UserController::class, 'show']);
        Route::put('/users/{id}', [UserController::class, 'update']);
        Route::delete('/users/{id}', [UserController::class, 'destroy']);

        // Mata Kuliah Management
        Route::get('/mata-kuliah', [MataKuliahController::class, 'index']);
        Route::post('/mata-kuliah', [MataKuliahController::class, 'store']);
        Route::get('/mata-kuliah/{id}', [MataKuliahController::class, 'show']);
        Route::put('/mata-kuliah/{id}', [MataKuliahController::class, 'update']);
        Route::delete('/mata-kuliah/{id}', [MataKuliahController::class, 'destroy']);

        // Peserta Mata Kuliah Management
        Route::post('/peserta-mk', [PesertaMkController::class, 'store']);
        Route::delete('/peserta-mk/{id}', [PesertaMkController::class, 'destroy']);
        Route::get('/mata-kuliah/{id}/peserta', [PesertaMkController::class, 'getPesertaByMataKuliah']);

        // View all absensi
        Route::get('/absensi/all', [AbsensiController::class, 'getAllAbsensi']);
    });

    // ========== DOSEN ROUTES ==========
    Route::middleware('role:dosen')->group(function () {
        // Generate QR
        Route::post('/generate-qr', [QrController::class, 'generate']);
        Route::get('/qr-sessions', [QrController::class, 'index']);

        // Rekap Absensi
        Route::get('/rekap-absensi', [AbsensiController::class, 'rekapAbsensi']);
        Route::get('/mata-kuliah/{id}/absensi', [AbsensiController::class, 'getAbsensiByMataKuliah']);

        // Kelola Tugas
        Route::post('/tugas', [TugasController::class, 'store']);
        Route::get('/tugas', [TugasController::class, 'index']);
        Route::get('/tugas/{id}', [TugasController::class, 'show']);
        Route::put('/tugas/{id}', [TugasController::class, 'update']);
        Route::delete('/tugas/{id}', [TugasController::class, 'destroy']);
        Route::get('/tugas/{id}/pengumpulan', [TugasController::class, 'getPengumpulan']);
        Route::put('/pengumpulan-tugas/{id}/nilai', [TugasController::class, 'beriNilai']);

        // Upload Materi
        Route::post('/materi', [MateriController::class, 'store']);
        Route::get('/materi', [MateriController::class, 'index']);
        Route::get('/materi/{id}', [MateriController::class, 'show']);
        Route::delete('/materi/{id}', [MateriController::class, 'destroy']);

        // Lihat mata kuliah yang diajar
        Route::get('/mata-kuliah/dosen/me', [MataKuliahController::class, 'getMataKuliahDosen']);
        Route::get('/mata-kuliah/{id}/peserta', [PesertaMkController::class, 'getPesertaByMataKuliah']);
    });

    // ========== MAHASISWA ROUTES ==========
    Route::middleware('role:mahasiswa')->group(function () {
        // Scan QR Absensi
        Route::post('/scan-qr', [AbsensiController::class, 'scanQr']);

        // Riwayat Absensi
        Route::get('/riwayat-absensi', [AbsensiController::class, 'riwayatAbsensi']);

        // Upload Tugas
        Route::post('/upload-tugas', [TugasController::class, 'uploadTugas']);
        Route::get('/tugas/mahasiswa/me', [TugasController::class, 'getTugasMahasiswa']);
        Route::get('/pengumpulan-tugas/me', [TugasController::class, 'getPengumpulanMahasiswa']);

        // Lihat mata kuliah yang diambil
        Route::get('/mata-kuliah/mahasiswa/me', [MataKuliahController::class, 'getMataKuliahMahasiswa']);

        // Lihat materi
        Route::get('/materi/mahasiswa/me', [MateriController::class, 'getMateriMahasiswa']);
    });
});
