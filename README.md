# 📱 JAYQ - Aplikasi Absensi Mahasiswa Berbasis QR Code

> **"Scan. Attend. Done."**

Sistem absensi mahasiswa berbasis mobile yang menggunakan teknologi QR Code untuk mempermudah proses presensi perkuliahan secara digital.

![Flutter](https://img.shields.io/badge/Flutter-3.11.4-02569B?logo=flutter)
![Laravel](https://img.shields.io/badge/Laravel-13-FF2D20?logo=laravel)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?logo=mysql)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📋 Daftar Isi

- [Tentang Proyek](#-tentang-proyek)
- [Spesifikasi Sistem](#-spesifikasi-sistem)
- [Role Pengguna](#-role-pengguna)
- [Fitur Utama (MVP)](#-fitur-utama-mvp)
- [Arsitektur Sistem](#-arsitektur-sistem)
- [UI/UX Design](#-uiux-design)
- [Keamanan Sistem](#-keamanan-sistem)
- [Struktur Proyek](#-struktur-proyek)
- [Instalasi](#-instalasi)
- [Penggunaan](#-penggunaan)
- [Screenshot](#-screenshot)
- [Output Sistem](#-output-sistem)
- [Kontribusi](#-kontribusi)
- [Lisensi](#-lisensi)

---

## 🎯 Tentang Proyek

### Nama Aplikasi

**JAYQ**

### Tagline

**"Scan. Attend. Done."**

### Deskripsi Singkat Sistem

**JAYQ** merupakan aplikasi absensi mahasiswa berbasis mobile yang menggunakan teknologi QR Code untuk mempermudah proses presensi perkuliahan secara digital. Aplikasi dikembangkan menggunakan **Flutter** sebagai frontend mobile dan **Laravel REST API** sebagai backend sistem.

Aplikasi memiliki **tiga role pengguna**:

- 👨‍💼 **Admin**
- 👨‍🏫 **Dosen**
- 👨‍🎓 **Mahasiswa**

Sistem dirancang agar proses absensi menjadi:

- ⚡ **Lebih cepat**
- 🎯 **Efisien**
- 🚀 **Modern**
- 🔗 **Terintegrasi secara digital**

---

## 🔧 Spesifikasi Sistem

### Platform

- **Android Mobile Application**

### Teknologi yang Digunakan

#### Frontend

| Komponen             | Teknologi                                  |
| -------------------- | ------------------------------------------ |
| **Framework**        | Flutter                                    |
| **Bahasa**           | Dart                                       |
| **State Management** | Provider                                   |
| **HTTP Client**      | Dio                                        |
| **QR Scanner**       | mobile_scanner                             |
| **QR Generator**     | qr_flutter                                 |
| **Storage**          | shared_preferences, flutter_secure_storage |
| **UI Components**    | Material Design 3                          |

#### Backend

| Komponen           | Teknologi                      |
| ------------------ | ------------------------------ |
| **Framework**      | Laravel REST API               |
| **Authentication** | Laravel Sanctum Authentication |
| **Database**       | MySQL                          |
| **API Format**     | JSON REST API                  |

### Arsitektur Sistem

#### Frontend Mobile

Frontend digunakan oleh:

- Admin
- Dosen
- Mahasiswa

Frontend bertugas:

- Menampilkan UI
- Mengakses API
- Mengelola interaksi pengguna

#### Backend API

Backend berfungsi:

- Mengelola database
- Autentikasi
- Validasi data
- Pengolahan absensi
- Komunikasi API

---

## 👥 Role Pengguna

### 1. 👨‍💼 Admin

Admin bertugas mengelola seluruh sistem.

**Hak Akses Admin:**

- ✅ Kelola dosen
- ✅ Kelola mahasiswa
- ✅ Kelola mata kuliah
- ✅ Kelola peserta mata kuliah
- ✅ Monitoring presensi
- ✅ Melihat laporan presensi
- ✅ Melihat statistik sistem

### 2. 👨‍🏫 Dosen

Dosen bertugas mengelola absensi dan perkuliahan.

**Hak Akses Dosen:**

- ✅ Generate QR absensi
- ✅ Melihat rekap absensi
- ✅ Membuat tugas
- ✅ Upload materi
- ✅ Melihat peserta kelas

### 3. 👨‍🎓 Mahasiswa

Mahasiswa menggunakan aplikasi untuk absensi dan tugas.

**Hak Akses Mahasiswa:**

- ✅ Scan QR absensi
- ✅ Lihat mata kuliah
- ✅ Upload tugas
- ✅ Lihat riwayat absensi

---

## 🚀 Fitur Utama (MVP)

### 1. 🔐 Login Multi Role

Pengguna login menggunakan:

- Email
- Password

Sistem otomatis mendeteksi role:

- Admin
- Dosen
- Mahasiswa

Dan mengarahkan ke dashboard masing-masing.

### 2. 📊 Dashboard Admin

**Fitur:**

- Statistik mata kuliah aktif
- Total dosen
- Total mahasiswa
- Tren presensi hari ini
- Quick action menu
- Pengumuman sistem

### 3. 👨‍🏫 CRUD Data Dosen

Admin dapat:

- ✅ Tambah dosen
- ✅ Edit dosen
- ✅ Hapus dosen
- ✅ Cari dosen

### 4. 👨‍🎓 CRUD Data Mahasiswa

Admin dapat:

- ✅ Tambah mahasiswa
- ✅ Edit mahasiswa
- ✅ Hapus mahasiswa
- ✅ Cari mahasiswa

### 5. 📚 CRUD Mata Kuliah

Admin dapat:

- ✅ Tambah mata kuliah
- ✅ Edit mata kuliah
- ✅ Hapus mata kuliah
- ✅ Menentukan dosen pengajar

### 6. 👥 Kelola Peserta Mata Kuliah

Admin dapat:

- ✅ Menambahkan mahasiswa ke mata kuliah
- ✅ Menghapus mahasiswa dari mata kuliah

### 7. 📱 Generate QR Absensi

Dosen dapat:

- ✅ Memilih mata kuliah
- ✅ Membuat QR absensi
- ✅ Menentukan masa aktif QR

**QR hanya berlaku dalam waktu tertentu.**

### 8. 📷 Scan QR Absensi

Mahasiswa dapat:

- ✅ Scan QR menggunakan kamera
- ✅ Melakukan absensi otomatis

**Sistem melakukan validasi:**

- QR aktif
- Mahasiswa terdaftar
- Absensi tidak ganda

### 9. 📋 Rekap Presensi

Dosen dan admin dapat:

- ✅ Melihat daftar kehadiran mahasiswa
- ✅ Filter berdasarkan mata kuliah
- ✅ Filter tanggal

### 10. 📤 Upload Tugas

Mahasiswa dapat:

- ✅ Upload file tugas
- ✅ Melihat deadline tugas

**Format file:**

- PDF
- DOC
- DOCX

### 11. 📖 Upload Materi

Dosen dapat:

- ✅ Upload materi pembelajaran
- ✅ Membagikan file materi ke mahasiswa

### 12. 📜 Riwayat Absensi

Mahasiswa dapat:

- ✅ Melihat histori kehadiran
- ✅ Melihat status hadir/alfa/izin

### 13. 📊 Laporan Presensi

Admin dapat:

- ✅ Melihat statistik presensi
- ✅ Melihat laporan kehadiran
- ⏳ Export laporan (opsional)

### 14. 🌙 Dark Mode

Aplikasi mendukung:

- ☀️ Light Mode
- 🌙 Dark Mode

**Theme tersimpan otomatis.**

### 15. 🔔 Notification System

Sistem menampilkan:

- Pengumuman
- Informasi sistem
- Update aktivitas

---

## 🏗️ Arsitektur Sistem

### Diagram Arsitektur

```
┌─────────────────────────────────────────────────────────┐
│                    MOBILE APP (Flutter)                  │
├─────────────────────────────────────────────────────────┤
│  Presentation Layer                                      │
│  ├── Screens (UI)                                        │
│  │   ├── Admin Dashboard                                 │
│  │   ├── Dosen Dashboard                                 │
│  │   └── Mahasiswa Dashboard                             │
│  ├── Widgets (Reusable Components)                       │
│  └── Providers (State Management)                        │
├─────────────────────────────────────────────────────────┤
│  Business Logic Layer                                    │
│  ├── Services (API Calls)                                │
│  ├── Models (Data Models)                                │
│  └── Utils (Helpers)                                     │
├─────────────────────────────────────────────────────────┤
│  Data Layer                                              │
│  ├── API Client (Dio)                                    │
│  ├── Local Storage (SharedPreferences)                   │
│  └── Secure Storage (FlutterSecureStorage)               │
└─────────────────────────────────────────────────────────┘
                            ↕
                    REST API (JSON)
                            ↕
┌─────────────────────────────────────────────────────────┐
│                   BACKEND (Laravel)                      │
├─────────────────────────────────────────────────────────┤
│  API Layer                                               │
│  ├── Controllers (Request Handling)                      │
│  ├── Middleware (Auth, CORS, etc)                        │
│  └── Routes (API Endpoints)                              │
├─────────────────────────────────────────────────────────┤
│  Business Logic Layer                                    │
│  ├── Models (Eloquent ORM)                               │
│  ├── Services (Business Logic)                           │
│  └── Validation (Form Requests)                          │
├─────────────────────────────────────────────────────────┤
│  Data Layer                                              │
│  ├── Database (MySQL)                                    │
│  ├── Migrations & Seeders                                │
│  └── File Storage (Local)                                │
└─────────────────────────────────────────────────────────┘
```

### Flow Absensi QR Code

```
1. Dosen Generate QR Code
   ↓
2. QR Code disimpan di database dengan expiration time
   ↓
3. Mahasiswa scan QR Code
   ↓
4. Validasi QR Code (expired? valid?)
   ↓
5. Validasi mahasiswa terdaftar
   ↓
6. Cek absensi tidak ganda
   ↓
7. Simpan record absensi
   ↓
8. Kirim konfirmasi ke mahasiswa
```

---

## 🎨 UI/UX Design

### Konsep Desain

Aplikasi JAYQ menggunakan konsep desain:

- 🎯 **Modern**
- ✨ **Clean**
- 🚀 **Startup Style**
- 💫 **Gen Z Mobile UI**

### Elemen Desain

Menggunakan:

- ⭕ **Rounded corner**
- 🌫️ **Soft shadow**
- 📝 **Clean typography**
- 📱 **Responsive layout**

### Color Palette

- **Primary**: Modern Blue
- **Secondary**: Soft Purple
- **Accent**: Vibrant Orange
- **Background**: Clean White / Dark Gray
- **Text**: Dark Gray / White

---

## 🔒 Keamanan Sistem

Sistem menggunakan:

### Authentication & Authorization

- ✅ **Token authentication**
- ✅ **Laravel Sanctum**
- ✅ **Middleware role access**
- ✅ **Secure token storage**

### Data Security

- ✅ **Hashing password**
- ✅ **Validasi request**
- ✅ **Input sanitization**
- ✅ **SQL injection prevention**

### QR Code Security

- ✅ **Time-based expiration**
- ✅ **One-time use validation**
- ✅ **Encrypted QR data**

---

## 📁 Struktur Proyek

```
abesensi/
├── jayq_app/                    # Flutter Mobile App
│   ├── lib/
│   │   ├── core/
│   │   │   ├── constants/       # App constants
│   │   │   ├── theme/           # Theme configuration
│   │   │   └── utils/           # Utility functions
│   │   ├── models/              # Data models
│   │   ├── providers/           # State management (Provider)
│   │   ├── routes/              # App routing
│   │   ├── screens/             # UI screens
│   │   │   ├── admin/           # Admin screens
│   │   │   ├── dosen/           # Dosen screens
│   │   │   ├── mahasiswa/       # Mahasiswa screens
│   │   │   ├── auth/            # Authentication screens
│   │   │   └── splash/          # Splash screen
│   │   ├── services/            # API services
│   │   └── widgets/             # Reusable widgets
│   ├── assets/                  # Images, icons, fonts
│   ├── pubspec.yaml             # Dependencies
│   └── README.md
│
├── backendabsensi/              # Laravel Backend API
│   ├── app/
│   │   ├── Http/
│   │   │   ├── Controllers/
│   │   │   │   └── Api/         # API Controllers
│   │   │   └── Middleware/      # Custom middleware
│   │   └── Models/              # Eloquent models
│   ├── config/                  # Configuration files
│   ├── database/
│   │   ├── migrations/          # Database migrations
│   │   └── seeders/             # Database seeders
│   ├── routes/
│   │   └── api.php              # API routes
│   ├── storage/                 # File storage
│   ├── .env.example             # Environment template
│   ├── composer.json            # PHP dependencies
│   └── API_DOCUMENTATION.md     # API docs
│
└── README.md                    # This file
```

---

## 🛠️ Instalasi

### Prerequisites

- **Flutter SDK**: 3.11.4 atau lebih baru
- **Dart SDK**: 3.11.4 atau lebih baru
- **PHP**: 8.2 atau lebih baru
- **Composer**: Latest version
- **MySQL**: 8.0 atau lebih baru
- **Android Studio** / **VS Code** dengan Flutter extension

### 1. Clone Repository

```bash
git clone https://github.com/yourusername/abesensi.git
cd abesensi
```

### 2. Setup Backend (Laravel)

```bash
cd backendabsensi

# Install dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate

# Configure database di .env
# DB_DATABASE=absensi_qr_mobile
# DB_USERNAME=root
# DB_PASSWORD=

# Run migrations dan seeders
php artisan migrate:fresh --seed

# Create storage link
php artisan storage:link

# Start server
php artisan serve
```

Backend akan berjalan di: `http://localhost:8000`

### 3. Setup Frontend (Flutter)

```bash
cd ../jayq_app

# Install dependencies
flutter pub get

# Update API base URL di lib/core/constants/app_constants.dart
# static const String baseUrl = 'http://localhost:8000/api';

# Run app
flutter run
```

### 4. Default Login Credentials

#### 👨‍💼 Admin

- Email: `admin@jayq.com`
- Password: `password`

#### 👨‍🏫 Dosen

- Email: `budi@jayq.com` atau `siti@jayq.com`
- Password: `password`

#### 👨‍🎓 Mahasiswa

- Email: `ahmad@jayq.com`, `dewi@jayq.com`, atau `eko@jayq.com`
- Password: `password`

---

## 📖 Penggunaan

### Untuk Admin 👨‍💼

1. Login dengan akun admin
2. Kelola pengguna:
   - Tambah/edit/hapus dosen
   - Tambah/edit/hapus mahasiswa
3. Kelola mata kuliah:
   - Buat mata kuliah baru
   - Assign dosen pengajar
4. Kelola peserta:
   - Tambah mahasiswa ke mata kuliah
   - Hapus mahasiswa dari mata kuliah
5. Monitor sistem:
   - Lihat statistik dashboard
   - Cek rekap absensi
   - Lihat laporan presensi

### Untuk Dosen 👨‍🏫

1. Login dengan akun dosen
2. Pilih mata kuliah yang diajar
3. Generate QR Code:
   - Pilih mata kuliah
   - Set durasi aktif QR
   - Tampilkan QR ke mahasiswa
4. Kelola tugas:
   - Buat tugas baru
   - Upload file tugas
   - Set deadline
5. Upload materi pembelajaran
6. Lihat rekap absensi:
   - Filter per mata kuliah
   - Filter per tanggal
   - Lihat detail kehadiran

### Untuk Mahasiswa 👨‍🎓

1. Login dengan akun mahasiswa
2. Scan QR Code untuk absensi:
   - Buka menu absensi
   - Scan QR yang ditampilkan dosen
   - Tunggu konfirmasi berhasil
3. Lihat dan download tugas:
   - Pilih mata kuliah
   - Download file tugas
4. Upload pengumpulan tugas:
   - Pilih tugas
   - Upload file jawaban
   - Cek status pengumpulan
5. Akses materi pembelajaran:
   - Pilih mata kuliah
   - Download materi
6. Cek riwayat absensi:
   - Lihat histori kehadiran
   - Cek persentase kehadiran

---

## 📸 Screenshot

## _Coming Soon_

## 📦 Output Sistem

Output akhir dari proyek JAYQ berupa:

### 1. 📱 Aplikasi Mobile Android

- File APK siap install
- Support Android 5.0 (Lollipop) ke atas
- Ukuran aplikasi < 50 MB
- Optimized performance

### 2. 🔌 Backend REST API

- Laravel REST API
- JSON response format
- Token-based authentication
- Comprehensive API documentation

### 3. 🗄️ Database MySQL

- Normalized database schema
- Seeder data untuk testing
- Migration files
- Relational data structure

### 4. 📊 Dashboard Multi Role

- Admin dashboard
- Dosen dashboard
- Mahasiswa dashboard
- Role-based access control

### 5. 🎯 Sistem Absensi QR Digital

- QR Code generator
- QR Code scanner
- Real-time validation
- Attendance tracking

---

## 🗺️ Roadmap

### ✅ Phase 1: MVP (Current)

- [x] Authentication system
- [x] Multi-role dashboard
- [x] QR Code absensi
- [x] CRUD pengguna
- [x] CRUD mata kuliah
- [x] Sistem tugas
- [x] Upload materi
- [x] Rekap absensi
- [x] Dark mode

### 🚧 Phase 2: Enhancement

- [ ] Push notifications
- [ ] Export data (CSV/Excel)
- [ ] Validasi lokasi GPS
- [ ] Email notifications
- [ ] Forgot password
- [ ] Profile management

### 📋 Phase 3: Advanced Features

- [ ] Chat/Forum diskusi
- [ ] Quiz/Ujian online
- [ ] Jadwal kuliah
- [ ] Calendar integration
- [ ] Attendance analytics
- [ ] Performance reports

### 🎯 Phase 4: Enterprise

- [ ] Multi-tenant support
- [ ] API documentation (Swagger)
- [ ] Automated testing
- [ ] CI/CD pipeline
- [ ] Cloud deployment (AWS/GCP)
- [ ] Performance monitoring
- [ ] iOS version

---

## 🤝 Kontribusi

Kontribusi sangat diterima! Silakan ikuti langkah berikut:

1. Fork repository ini
2. Buat branch fitur (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

### Coding Standards

- **Flutter**: Ikuti [Effective Dart](https://dart.dev/guides/language/effective-dart)
- **Laravel**: Ikuti [PSR-12](https://www.php-fig.org/psr/psr-12/)
- Gunakan meaningful variable names
- Tambahkan komentar untuk logic yang kompleks
- Write clean and maintainable code

---

## 📄 Lisensi

Distributed under the MIT License. See `LICENSE` for more information.

---

## 👥 Tim Pengembang

- **Ronal** - _Full Stack Developer_

---

## 📞 Kontak & Support

- **Email**: support@jayq.com
- **GitHub**: [JAYQ Repository](https://github.com/yourusername/abesensi)
- **Documentation**: [API Documentation](./backendabsensi/API_DOCUMENTATION.md)

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) - UI Framework
- [Laravel](https://laravel.com/) - Backend Framework
- [Material Design](https://m3.material.io/) - Design System
- [mobile_scanner](https://pub.dev/packages/mobile_scanner) - QR Scanner
- [Provider](https://pub.dev/packages/provider) - State Management
- [Dio](https://pub.dev/packages/dio) - HTTP Client

---

## 📚 Dokumentasi Tambahan

- [API Documentation](./backendabsensi/API_DOCUMENTATION.md) - Dokumentasi lengkap REST API
- [Flutter App README](./jayq_app/README.md) - Dokumentasi aplikasi mobile
- [Database Schema](./backendabsensi/database/migrations/) - Struktur database

---

<div align="center">

**⭐ Jika proyek ini membantu, berikan star di GitHub! ⭐**

**"Scan. Attend. Done."**

Made with ❤️ by Ronal

</div>
