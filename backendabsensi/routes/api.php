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
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\PengumumanController;
use App\Http\Controllers\Api\ExportController;
use App\Http\Controllers\Api\NotificationController;

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
        // Dashboard Stats
        Route::get('/admin/dashboard/stats', [DashboardController::class, 'adminStats']);
        Route::get('/admin/dashboard/advanced-stats', [DashboardController::class, 'advancedStats']);

        // User Management
        Route::get('/users', [UserController::class, 'index']);
        Route::post('/users', [UserController::class, 'store']);
        Route::get('/users/{id}', [UserController::class, 'show']);
        Route::put('/users/{id}', [UserController::class, 'update']);
        Route::delete('/users/{id}', [UserController::class, 'destroy']);
        Route::post('/users/{id}/reset-password', [UserController::class, 'resetPassword']);

        // Mata Kuliah Management
        Route::get('/mata-kuliah', [MataKuliahController::class, 'index']);
        Route::post('/mata-kuliah', [MataKuliahController::class, 'store']);
        Route::get('/mata-kuliah/{id}', [MataKuliahController::class, 'show']);
        Route::put('/mata-kuliah/{id}', [MataKuliahController::class, 'update']);
        Route::delete('/mata-kuliah/{id}', [MataKuliahController::class, 'destroy']);

        // View all absensi
        Route::get('/absensi/all', [AbsensiController::class, 'getAllAbsensi']);

        // Pengumuman Management
        Route::get('/pengumuman/admin', [PengumumanController::class, 'adminIndex']);
        Route::post('/pengumuman', [PengumumanController::class, 'store']);
        Route::put('/pengumuman/{id}', [PengumumanController::class, 'update']);
        Route::delete('/pengumuman/{id}', [PengumumanController::class, 'destroy']);
        Route::post('/pengumuman/{id}/toggle', [PengumumanController::class, 'toggleActive']);

        // Notification Management
        Route::post('/notifications/send', [NotificationController::class, 'sendToUsers']);
        Route::get('/notifications/history', [NotificationController::class, 'history']);

        // Export Data
        Route::get('/export/absensi', [ExportController::class, 'exportAbsensi']);
        Route::get('/export/rekap-mahasiswa', [ExportController::class, 'exportRekapMahasiswa']);
        Route::get('/export/mahasiswa', [ExportController::class, 'exportMahasiswa']);
        Route::get('/export/dosen', [ExportController::class, 'exportDosen']);
        Route::get('/export/mata-kuliah', [ExportController::class, 'exportMataKuliah']);
    });

    // ========== ADMIN & DOSEN SHARED ROUTES ==========
    Route::middleware('role:admin,dosen')->group(function () {
        // Peserta Mata Kuliah Management (accessible by both admin and dosen)
        Route::post('/peserta-mk', [PesertaMkController::class, 'store']);
        Route::delete('/peserta-mk/{id}', [PesertaMkController::class, 'destroy']);
        Route::get('/mata-kuliah/{id}/peserta', [PesertaMkController::class, 'getPesertaByMataKuliah']);
        
        // Absensi by Mata Kuliah (accessible by both admin and dosen)
        Route::get('/mata-kuliah/{id}/absensi', [AbsensiController::class, 'getAbsensiByMataKuliah']);
    });

    // ========== DOSEN ROUTES ==========
    Route::middleware('role:dosen')->group(function () {
        // Dashboard Stats
        Route::get('/dosen/{id}/dashboard/stats', [DashboardController::class, 'dosenStats']);

        // Generate QR
        Route::post('/generate-qr', [QrController::class, 'generate']);
        Route::get('/qr-sessions', [QrController::class, 'index']);

        // Rekap Absensi
        Route::get('/rekap-absensi', [AbsensiController::class, 'rekapAbsensi']);

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
    });

    // ========== MAHASISWA ROUTES ==========
    Route::middleware('role:mahasiswa')->group(function () {
        // Dashboard Stats
        Route::get('/mahasiswa/{id}/stats', [DashboardController::class, 'mahasiswaStats']);

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

    // ========== SHARED ROUTES (All authenticated users) ==========
    // FCM Token Management (accessible by all roles)
    Route::post('/user/fcm-token', [UserController::class, 'saveFcmToken']);
    
    // Pengumuman (accessible by all roles)
    Route::get('/pengumuman', [PengumumanController::class, 'index']);
    Route::get('/pengumuman/{id}', [PengumumanController::class, 'show']);
    Route::post('/pengumuman/{id}/mark-as-read', [PengumumanController::class, 'markAsRead']);
    Route::post('/pengumuman/mark-all-as-read', [PengumumanController::class, 'markAllAsRead']);
    Route::get('/pengumuman/unread/count', [PengumumanController::class, 'getUnreadCount']);
    
    // Profile Management (accessible by all roles)
    Route::put('/profile/update', [UserController::class, 'updateProfile']);
});
