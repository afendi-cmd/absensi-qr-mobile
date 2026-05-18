# Integrasi Database - Dashboard Real Data

## Perubahan yang Dilakukan

### 1. Backend (Laravel)

#### Controller Baru

- **DashboardController.php** - Controller untuk menangani statistik dashboard
  - `adminStats()` - Statistik untuk admin (total mata kuliah, dosen, mahasiswa, absensi hari ini)
  - `mahasiswaStats()` - Statistik untuk mahasiswa (total MK, kehadiran, tugas)
  - `dosenStats()` - Statistik untuk dosen (total MK, mahasiswa, absensi, tugas)

#### Routes API Baru

```php
// Admin
GET /api/admin/dashboard/stats

// Mahasiswa
GET /api/mahasiswa/{id}/stats

// Dosen
GET /api/dosen/{id}/dashboard/stats
```

### 2. Frontend (Flutter)

#### Model Baru

- **mata_kuliah.dart** - Model untuk data mata kuliah
- **dashboard_stats.dart** - Model untuk statistik dashboard (Admin & Mahasiswa)

#### Service Baru

- **dashboard_service.dart** - Service untuk mengambil data dashboard dari API
  - `getAdminStats()` - Ambil statistik admin
  - `getMahasiswaStats()` - Ambil statistik mahasiswa
  - `getAllMataKuliah()` - Ambil semua mata kuliah
  - `getMahasiswaMataKuliah()` - Ambil mata kuliah mahasiswa
  - `getAllUsers()` - Ambil semua users
  - `getUsersByRole()` - Ambil users berdasarkan role

#### Provider Baru

- **dashboard_provider.dart** - State management untuk data dashboard
  - Mengelola loading states
  - Mengelola error handling
  - Menyimpan data statistik dan mata kuliah

#### Screen Updates

- **admin_dashboard_screen.dart**
  - Menggunakan `Consumer<DashboardProvider>` untuk menampilkan data real
  - Menampilkan total mata kuliah, dosen, dan mahasiswa dari database
  - Loading indicator saat data sedang diambil

- **mahasiswa_dashboard_screen.dart**
  - Menggunakan `Consumer<DashboardProvider>` untuk statistik
  - Menampilkan mata kuliah yang diambil mahasiswa dari database
  - Menampilkan statistik kehadiran dan tugas

#### Main.dart

- Menambahkan `DashboardProvider` ke MultiProvider

## Data yang Ditampilkan dari Database

### Admin Dashboard

- ✅ Total Mata Kuliah Aktif (dari tabel `mata_kuliah`)
- ✅ Total Dosen (dari tabel `users` dengan role='dosen')
- ✅ Total Mahasiswa (dari tabel `users` dengan role='mahasiswa')
- ⏳ Total Absensi Hari Ini (dari tabel `absensi`)

### Mahasiswa Dashboard

- ✅ Total Mata Kuliah yang Diambil (dari tabel `peserta_mk`)
- ✅ Daftar Mata Kuliah dengan Dosen (dari tabel `mata_kuliah` join `users`)
- ⏳ Persentase Kehadiran (dari tabel `absensi`)
- ⏳ Tugas Selesai/Pending (dari tabel `tugas` dan `pengumpulan_tugas`)

## Cara Kerja

1. **Saat Dashboard Dibuka**
   - `initState()` memanggil provider untuk load data
   - Provider memanggil service
   - Service memanggil API backend
   - Backend query database dan return JSON
   - Data ditampilkan di UI

2. **Loading State**
   - Saat data sedang diambil, tampilkan `CircularProgressIndicator`
   - Setelah selesai, tampilkan data atau pesan error

3. **Error Handling**
   - Jika API gagal, tampilkan pesan error
   - Fallback ke data kosong jika tidak ada data

## Testing

### Test Backend API

```bash
# Test admin stats
curl -H "Authorization: Bearer {token}" http://localhost:8000/api/admin/dashboard/stats

# Test mahasiswa stats
curl -H "Authorization: Bearer {token}" http://localhost:8000/api/mahasiswa/4/stats
```

### Test Flutter App

1. Pastikan backend Laravel sudah running
2. Update `baseUrl` di `app_constants.dart` sesuai device
3. Login sebagai admin atau mahasiswa
4. Dashboard akan menampilkan data dari database

## Data Saat Ini di Database

### Users

- Admin: admin@jayq.com
- Dosen: budi@jayq.com, siti@jayq.com
- Mahasiswa: ahmad@jayq.com, dewi@jayq.com, eko@jayq.com

### Mata Kuliah

1. Pemrograman Mobile (IF301) - Dr. Budi Santoso
2. Basis Data (IF302) - Dr. Budi Santoso
3. Pemrograman Web (IF303) - Dr. Siti Nurhaliza

### Peserta MK

- Ahmad Rizki: terdaftar di 3 mata kuliah
- Dewi Lestari: terdaftar di 2 mata kuliah
- Eko Prasetyo: terdaftar di 1 mata kuliah

## Next Steps

- [ ] Implementasi data absensi real-time
- [ ] Implementasi data tugas dan pengumpulan
- [ ] Tambah refresh button untuk reload data
- [ ] Implementasi caching untuk performa
- [ ] Tambah pull-to-refresh gesture
