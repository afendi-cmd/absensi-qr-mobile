# 📖 Panduan Step-by-Step Membangun Modul Dosen

**Aplikasi Absensi Kampus - Modul Dosen**  
**Target:** 4-6 Minggu  
**Tanggal Mulai:** 1 Juni 2026

---

## 📋 Daftar Isi

1. [Persiapan](#persiapan)
2. [Step 1: Dashboard Dosen](#step-1-dashboard-dosen)
3. [Step 2: Generate QR Code](#step-2-generate-qr-code)
4. [Step 3: Manajemen Mata Kuliah](#step-3-manajemen-mata-kuliah)
5. [Step 4: Rekap Kehadiran](#step-4-rekap-kehadiran)
6. [Step 5: Manajemen Tugas](#step-5-manajemen-tugas)
7. [Step 6: Manajemen Materi](#step-6-manajemen-materi)
8. [Step 7: Profile & Settings](#step-7-profile--settings)
9. [Step 8: Testing & Polish](#step-8-testing--polish)

---

## 🛠 Persiapan

### A. Install Dependencies

**File:** `pubspec.yaml`

```yaml
dependencies:
  # QR Code Generation
  qr_flutter: ^4.1.0

  # Charts
  fl_chart: ^0.66.0

  # Export
  excel: ^4.0.2
  pdf: ^3.10.7
  printing: ^5.12.0

  # Timer
  timer_builder: ^2.0.0
```

**Command:**

```bash
cd jayq_app
flutter pub get
```

---

### B. Create Folder Structure

```
lib/
├── screens/
│   └── dosen/
│       ├── dosen_dashboard_screen.dart (sudah ada)
│       ├── generate_qr_screen.dart (baru)
│       ├── mata_kuliah_list_screen.dart (baru)
│       ├── mata_kuliah_detail_screen.dart (baru)
│       ├── rekap_kehadiran_screen.dart (baru)
│       ├── tugas_list_screen.dart (baru)
│       ├── tugas_form_screen.dart (baru)
│       ├── tugas_penilaian_screen.dart (baru)
│       ├── materi_list_screen.dart (baru)
│       ├── materi_form_screen.dart (baru)
│       └── profile_screen.dart (sudah ada)
├── data/
│   ├── models/
│   │   ├── qr_session_model.dart (baru)
│   │   └── rekap_kehadiran_model.dart (baru)
│   └── services/
│       ├── qr_session_service.dart (baru)
│       ├── rekap_service.dart (baru)
│       └── dashboard_dosen_service.dart (baru)
└── providers/
    └── dashboard_dosen_provider.dart (baru)
```

---

## 📱 STEP 1: Dashboard Dosen

**Estimasi:** 2-3 hari  
**Priority:** 🔥 High

### 1.1 Backend - Create API Endpoints

**File:** `backendabsensi/app/Http/Controllers/Api/DashboardController.php`

**Tambahkan method:**

```php
public function getDosenStats($dosenId)
{
    try {
        $dosen = User::findOrFail($dosenId);

        // Total mata kuliah yang diampu
        $totalMataKuliah = MataKuliah::where('dosen_id', $dosenId)->count();

        // Total mahasiswa dari semua kelas
        $totalMahasiswa = PesertaMk::whereIn(
            'mata_kuliah_id',
            MataKuliah::where('dosen_id', $dosenId)->pluck('id')
        )->distinct('mahasiswa_id')->count();

        // Kehadiran hari ini
        $today = Carbon::today();
        $hadirHariIni = Absensi::whereIn(
            'mata_kuliah_id',
            MataKuliah::where('dosen_id', $dosenId)->pluck('id')
        )
        ->whereDate('tanggal', $today)
        ->where('status', 'hadir')
        ->count();

        // Tugas aktif (belum deadline)
        $tugasAktif = Tugas::whereIn(
            'mata_kuliah_id',
            MataKuliah::where('dosen_id', $dosenId)->pluck('id')
        )
        ->where('deadline', '>', now())
        ->count();

        return response()->json([
            'success' => true,
            'data' => [
                'total_mata_kuliah' => $totalMataKuliah,
                'total_mahasiswa' => $totalMahasiswa,
                'hadir_hari_ini' => $hadirHariIni,
                'tugas_aktif' => $tugasAktif,
            ]
        ]);
    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Gagal mengambil statistik dosen',
            'error' => $e->getMessage()
        ], 500);
    }
}
```

**Route:** `backendabsensi/routes/api.php`

```php
Route::middleware('auth:sanctum')->group(function () {
    // Dashboard Dosen
    Route::get('/dashboard/dosen/{id}/stats', [DashboardController::class, 'getDosenStats']);
});
```

---

### 1.2 Frontend - Create Service

**File:** `jayq_app/lib/data/services/dashboard_dosen_service.dart`

```dart
import 'package:dio/dio.dart';
import '../models/user_model.dart';
import 'storage_service.dart';

class DashboardDosenService {
  final Dio _dio;
  final StorageService _storageService = StorageService();

  DashboardDosenService(this._dio);

  Future<Map<String, dynamic>> getDosenStats(int dosenId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.get(
        '/dashboard/dosen/$dosenId/stats',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      if (response.data['success']) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengambil statistik: $e');
    }
  }
}
```

---

### 1.3 Frontend - Create Provider

**File:** `jayq_app/lib/providers/dashboard_dosen_provider.dart`

```dart
import 'package:flutter/material.dart';
import '../data/services/dashboard_dosen_service.dart';

class DashboardDosenProvider with ChangeNotifier {
  final DashboardDosenService _service;

  DashboardDosenProvider(this._service);

  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStats(int dosenId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await _service.getDosenStats(dosenId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

---

### 1.4 Frontend - Update Dashboard Screen

**File:** `jayq_app/lib/screens/dosen/dosen_dashboard_screen.dart`

**Replace dengan:**

```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_dosen_provider.dart';
import '../../providers/theme_provider.dart';

class DosenDashboardScreen extends StatefulWidget {
  const DosenDashboardScreen({super.key});

  @override
  State<DosenDashboardScreen> createState() => _DosenDashboardScreenState();
}

class _DosenDashboardScreenState extends State<DosenDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final dashboardProvider = Provider.of<DashboardDosenProvider>(
        context,
        listen: false,
      );

      if (authProvider.user != null) {
        dashboardProvider.loadStats(authProvider.user!.id);
      }
    });
  }

  Future<void> _refreshData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardDosenProvider>(
      context,
      listen: false,
    );

    if (authProvider.user != null) {
      await dashboardProvider.loadStats(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FB),
      body: SafeArea(
        child: _selectedIndex == 0
            ? _buildHomeContent()
            : _selectedIndex == 1
            ? _buildQRContent()
            : _selectedIndex == 2
            ? _buildTugasContent()
            : _buildProfileContent(),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildHomeContent() {
    // Implementation here...
  }

  // ... other methods
}
```

---

### 1.5 Testing

**Checklist:**

- [ ] API endpoint `/dashboard/dosen/{id}/stats` berfungsi
- [ ] Service dapat fetch data dari API
- [ ] Provider dapat manage state
- [ ] Dashboard menampilkan real data
- [ ] Pull-to-refresh berfungsi
- [ ] Dark mode berfungsi
- [ ] Loading state ditampilkan
- [ ] Error handling berfungsi

---

## 📷 STEP 2: Generate QR Code

**Estimasi:** 2-3 hari  
**Priority:** 🔥 High

### 2.1 Backend - Create Migration

**Command:**

```bash
cd backendabsensi
php artisan make:migration create_qr_sessions_table
```

**File:** `backendabsensi/database/migrations/xxxx_create_qr_sessions_table.php`

```php
public function up()
{
    Schema::create('qr_sessions', function (Blueprint $table) {
        $table->id();
        $table->foreignId('mata_kuliah_id')->constrained('mata_kuliah')->onDelete('cascade');
        $table->foreignId('dosen_id')->constrained('users')->onDelete('cascade');
        $table->string('qr_code')->unique();
        $table->dateTime('started_at');
        $table->dateTime('expires_at');
        $table->dateTime('closed_at')->nullable();
        $table->boolean('is_active')->default(true);
        $table->timestamps();
    });
}
```

**Run migration:**

```bash
php artisan migrate
```

---

### 2.2 Backend - Create Model

**Command:**

```bash
php artisan make:model QrSession
```

**File:** `backendabsensi/app/Models/QrSession.php`

```php
<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class QrSession extends Model
{
    protected $fillable = [
        'mata_kuliah_id',
        'dosen_id',
        'qr_code',
        'started_at',
        'expires_at',
        'closed_at',
        'is_active',
    ];

    protected $casts = [
        'started_at' => 'datetime',
        'expires_at' => 'datetime',
        'closed_at' => 'datetime',
        'is_active' => 'boolean',
    ];

    public function mataKuliah()
    {
        return $this->belongsTo(MataKuliah::class);
    }

    public function dosen()
    {
        return $this->belongsTo(User::class, 'dosen_id');
    }

    public function absensi()
    {
        return $this->hasMany(Absensi::class, 'qr_session_id');
    }
}
```

---

### 2.3 Backend - Create Controller

**Command:**

```bash
php artisan make:controller Api/QrSessionController
```

**File:** `backendabsensi/app/Http/Controllers/Api/QrSessionController.php`

```php
<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\QrSession;
use Illuminate\Http\Request;
use Illuminate\Support\Str;
use Carbon\Carbon;

class QrSessionController extends Controller
{
    public function generate(Request $request)
    {
        $request->validate([
            'mata_kuliah_id' => 'required|exists:mata_kuliah,id',
            'duration' => 'required|integer|min:15|max:120', // minutes
        ]);

        try {
            // Close any active session for this mata kuliah
            QrSession::where('mata_kuliah_id', $request->mata_kuliah_id)
                ->where('is_active', true)
                ->update([
                    'is_active' => false,
                    'closed_at' => now(),
                ]);

            // Generate unique QR code
            $qrCode = Str::random(32);

            $session = QrSession::create([
                'mata_kuliah_id' => $request->mata_kuliah_id,
                'dosen_id' => $request->user()->id,
                'qr_code' => $qrCode,
                'started_at' => now(),
                'expires_at' => now()->addMinutes($request->duration),
                'is_active' => true,
            ]);

            $session->load('mataKuliah');

            return response()->json([
                'success' => true,
                'message' => 'QR Session berhasil dibuat',
                'data' => $session,
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat QR Session',
                'error' => $e->getMessage(),
            ], 500);
        }
    }

    public function show($id)
    {
        try {
            $session = QrSession::with(['mataKuliah', 'absensi.mahasiswa'])
                ->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $session,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'QR Session tidak ditemukan',
            ], 404);
        }
    }

    public function close($id)
    {
        try {
            $session = QrSession::findOrFail($id);

            $session->update([
                'is_active' => false,
                'closed_at' => now(),
            ]);

            return response()->json([
                'success' => true,
                'message' => 'QR Session ditutup',
                'data' => $session,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal menutup QR Session',
            ], 500);
        }
    }

    public function getAttendances($id)
    {
        try {
            $session = QrSession::with([
                'absensi' => function($query) {
                    $query->orderBy('created_at', 'desc');
                },
                'absensi.mahasiswa:id,nama,nim'
            ])->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => [
                    'session' => $session,
                    'attendances' => $session->absensi,
                    'total' => $session->absensi->count(),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal mengambil data kehadiran',
            ], 500);
        }
    }
}
```

---

### 2.4 Backend - Add Routes

**File:** `backendabsensi/routes/api.php`

```php
Route::middleware('auth:sanctum')->group(function () {
    // QR Session
    Route::post('/qr-session/generate', [QrSessionController::class, 'generate']);
    Route::get('/qr-session/{id}', [QrSessionController::class, 'show']);
    Route::put('/qr-session/{id}/close', [QrSessionController::class, 'close']);
    Route::get('/qr-session/{id}/attendances', [QrSessionController::class, 'getAttendances']);
});
```

---

### 2.5 Frontend - Create Model

**File:** `jayq_app/lib/data/models/qr_session_model.dart`

```dart
class QrSessionModel {
  final int id;
  final int mataKuliahId;
  final String qrCode;
  final DateTime startedAt;
  final DateTime expiresAt;
  final DateTime? closedAt;
  final bool isActive;
  final Map<String, dynamic>? mataKuliah;
  final List<dynamic>? absensi;

  QrSessionModel({
    required this.id,
    required this.mataKuliahId,
    required this.qrCode,
    required this.startedAt,
    required this.expiresAt,
    this.closedAt,
    required this.isActive,
    this.mataKuliah,
    this.absensi,
  });

  factory QrSessionModel.fromJson(Map<String, dynamic> json) {
    return QrSessionModel(
      id: json['id'],
      mataKuliahId: json['mata_kuliah_id'],
      qrCode: json['qr_code'],
      startedAt: DateTime.parse(json['started_at']),
      expiresAt: DateTime.parse(json['expires_at']),
      closedAt: json['closed_at'] != null
          ? DateTime.parse(json['closed_at'])
          : null,
      isActive: json['is_active'],
      mataKuliah: json['mata_kuliah'],
      absensi: json['absensi'],
    );
  }

  Duration get remainingTime {
    if (!isActive || closedAt != null) {
      return Duration.zero;
    }
    final now = DateTime.now();
    if (now.isAfter(expiresAt)) {
      return Duration.zero;
    }
    return expiresAt.difference(now);
  }

  bool get isExpired {
    return DateTime.now().isAfter(expiresAt) || !isActive;
  }
}
```

---

**[Lanjutan di bagian berikutnya...]**

Apakah Anda ingin saya lanjutkan dengan:

- Step 2.6 - 2.8 (Frontend Generate QR Screen)?
- Atau langsung ke Step 3 (Manajemen Mata Kuliah)?
- Atau fokus ke step tertentu?
