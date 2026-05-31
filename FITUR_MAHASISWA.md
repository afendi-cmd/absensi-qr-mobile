# 📱 Dokumentasi Fitur Aplikasi Mahasiswa

**Aplikasi Absensi Kampus - Modul Mahasiswa**  
**Tanggal:** 1 Juni 2026  
**Versi:** 1.0.0

---

## 📋 Daftar Isi

1. [Fitur yang Sudah Ada](#fitur-yang-sudah-ada)
2. [Fitur yang Bisa Ditambahkan](#fitur-yang-bisa-ditambahkan)
3. [Prioritas Pengembangan](#prioritas-pengembangan)
4. [Technical Stack](#technical-stack)

---

## ✅ Fitur yang Sudah Ada

### 1. 🏠 Dashboard/Beranda

**Status:** ✅ Selesai  
**File:** `mahasiswa_dashboard_screen.dart`

**Fitur:**

- ✅ Header dengan nama mahasiswa dan foto profil
- ✅ Badge notifikasi pengumuman dengan counter
- ✅ Greeting dinamis dengan tanggal
- ✅ Card persentase kehadiran dengan gradient
- ✅ Status kehadiran (Aman/Bahaya)
- ✅ Jadwal hari ini (3 teratas)
- ✅ Quick actions: Kalender Akademik, Tugas & Ujian
- ✅ FAB untuk QR Scanner (hanya di tab Beranda)
- ✅ Pull-to-refresh untuk reload data
- ✅ Dark mode support

**API Endpoints:**

- `GET /dashboard/mahasiswa/{id}/stats` - Statistik kehadiran
- `GET /mata-kuliah/mahasiswa/me` - Jadwal mata kuliah
- `GET /pengumuman/unread-count` - Jumlah pengumuman belum dibaca

---

### 2. 📅 Jadwal Kuliah

**Status:** ✅ Selesai  
**File:** `schedule_screen.dart`

**Fitur:**

- ✅ Filter jadwal per hari (Senin - Sabtu)
- ✅ Day selector dengan tanggal
- ✅ Status jadwal real-time:
  - Belum Mulai (abu-abu)
  - Berlangsung (biru, highlighted)
  - Selesai (hijau)
- ✅ Info lengkap: Waktu, Mata Kuliah, Dosen, Ruangan
- ✅ Tombol "Scan Kehadiran" untuk jadwal yang berlangsung
- ✅ Tombol "Lihat Presensi" untuk jadwal yang selesai
- ✅ Pull-to-refresh
- ✅ Dark mode support

**API Endpoints:**

- `GET /mata-kuliah/mahasiswa/me` - Daftar mata kuliah mahasiswa

---

### 3. 📜 Riwayat Absensi

**Status:** ✅ Selesai  
**File:** `history_screen.dart`

**Fitur:**

- ✅ List riwayat absensi dengan grouping per tanggal
- ✅ Header tanggal (Hari Ini, Kemarin, atau tanggal lengkap)
- ✅ Filter by mata kuliah (dropdown)
- ✅ Filter by bulan (dropdown)
- ✅ Status kehadiran dengan warna:
  - Hadir (hijau)
  - Izin (biru)
  - Sakit (kuning)
  - Alpa (merah)
- ✅ Info: Mata Kuliah, Waktu, Lokasi
- ✅ Pull-to-refresh
- ✅ Dark mode support

**API Endpoints:**

- `GET /absensi/riwayat` - Riwayat absensi dengan filter
- `GET /mata-kuliah/mahasiswa/me` - Untuk filter mata kuliah

---

### 4. 📷 QR Scanner

**Status:** ✅ Selesai  
**File:** `qr_scanner_screen.dart`

**Fitur:**

- ✅ Camera scanner untuk QR code
- ✅ Validasi QR session
- ✅ Submit absensi dengan lokasi (opsional)
- ✅ Feedback sukses/gagal
- ✅ Auto-close setelah sukses
- ✅ Dark mode support

**API Endpoints:**

- `POST /absensi/scan` - Submit absensi via QR

**Dependencies:**

- `mobile_scanner` - QR code scanning
- `geolocator` - Location services

---

### 5. 📚 Tugas & Materi

**Status:** ✅ Selesai  
**Files:** `tugas_materi_screen.dart`, `tugas_detail_screen.dart`, `materi_detail_screen.dart`

**Fitur Tugas:**

- ✅ Tab view: Tugas dan Materi
- ✅ List tugas dengan status:
  - Belum Dikumpulkan (kuning)
  - Sudah Dikumpulkan (hijau)
  - Terlambat (merah)
- ✅ Info: Judul, Mata Kuliah, Deadline, Sisa Waktu
- ✅ Detail tugas dengan deskripsi lengkap
- ✅ Download file tugas dari dosen
- ✅ Upload jawaban tugas (PDF, DOC, DOCX)
- ✅ File picker dengan preview
- ✅ Progress upload
- ✅ Lihat status pengumpulan
- ✅ Lihat nilai dan catatan dosen (jika sudah dinilai)
- ✅ Download file jawaban yang sudah diupload
- ✅ Dark mode support

**Fitur Materi:**

- ✅ List materi per mata kuliah
- ✅ Info: Judul, Mata Kuliah, Tanggal Upload
- ✅ Detail materi dengan deskripsi
- ✅ Download file materi
- ✅ Dark mode support

**API Endpoints:**

- `GET /tugas/mahasiswa` - Daftar tugas mahasiswa
- `GET /tugas/{id}` - Detail tugas
- `POST /tugas/{id}/upload` - Upload jawaban tugas
- `GET /materi/mahasiswa` - Daftar materi mahasiswa
- `GET /materi/{id}` - Detail materi

**Dependencies:**

- `file_picker` - File selection
- `url_launcher` - Open/download files

---

### 6. 📢 Pengumuman

**Status:** ✅ Selesai  
**Files:** `pengumuman_screen.dart`, `pengumuman_detail_screen.dart`

**Fitur:**

- ✅ List pengumuman dengan filter:
  - Semua
  - Belum Dibaca
  - Info (biru)
  - Penting (kuning)
  - Urgent (merah)
- ✅ Badge unread count di AppBar
- ✅ Tombol "Tandai Semua Sudah Dibaca"
- ✅ Auto mark as read saat buka detail
- ✅ Detail pengumuman dengan:
  - Judul
  - Tipe (Info/Penting/Urgent)
  - Isi lengkap
  - Tanggal publish
  - Nama pembuat
- ✅ Push notification saat ada pengumuman baru
- ✅ Pull-to-refresh
- ✅ Dark mode support

**API Endpoints:**

- `GET /pengumuman` - Daftar pengumuman
- `GET /pengumuman/{id}` - Detail pengumuman
- `POST /pengumuman/{id}/mark-as-read` - Tandai sudah dibaca
- `POST /pengumuman/mark-all-as-read` - Tandai semua sudah dibaca
- `GET /pengumuman/unread-count` - Jumlah belum dibaca

**Push Notification:**

- ✅ Firebase Cloud Messaging (FCM)
- ✅ Notification title: `📢 [Tipe]: [Judul]`
- ✅ Notification body: Preview isi (100 karakter)
- ✅ Data payload: pengumuman_id, tipe
- ✅ Auto-update badge count

---

### 7. 👤 Profile

**Status:** ✅ Selesai  
**Files:** `profile_screen.dart`, `edit_profile_screen.dart`, `change_password_screen.dart`

**Fitur:**

- ✅ Header dengan foto profil dan info mahasiswa
- ✅ Menu Akun:
  - Edit Profil (nama, email, no HP)
  - Ubah Password
- ✅ Menu Pengaturan:
  - Mode Gelap (toggle)
  - Notifikasi (info dialog)
  - Bahasa (info dialog)
- ✅ Menu Bantuan:
  - Bantuan & Dukungan (kontak admin)
  - Syarat & Ketentuan
  - Kebijakan Privasi
  - Tentang Aplikasi
- ✅ Logout dengan konfirmasi
- ✅ Dark mode support

**API Endpoints:**

- `GET /user/profile` - Data profil
- `PUT /user/profile` - Update profil
- `PUT /user/change-password` - Ubah password
- `POST /logout` - Logout

---

## 🆕 Fitur yang Bisa Ditambahkan

### 🔥 High Priority

#### 1. 🔔 Reminder Deadline Tugas

**Deskripsi:**  
Push notification otomatis untuk mengingatkan mahasiswa tentang deadline tugas yang akan datang.

**Fitur Detail:**

- Notifikasi H-3 sebelum deadline
- Notifikasi H-1 sebelum deadline
- Notifikasi 3 jam sebelum deadline
- Notifikasi untuk tugas yang belum dikumpulkan
- Setting custom reminder time
- Snooze notification

**Backend Requirements:**

- Cron job/scheduler untuk cek deadline
- FCM notification service
- User notification preferences table

**Estimasi:** 2-3 hari

---

#### 2. 📊 Grafik Kehadiran per Mata Kuliah

**Deskripsi:**  
Visualisasi statistik kehadiran mahasiswa dalam bentuk grafik untuk setiap mata kuliah.

**Fitur Detail:**

- Bar chart kehadiran per mata kuliah
- Pie chart status (Hadir, Izin, Sakit, Alpa)
- Line chart trend kehadiran per bulan
- Filter by semester
- Persentase kehadiran per mata kuliah
- Warning jika kehadiran < 75%

**Dependencies:**

- `fl_chart` atau `syncfusion_flutter_charts`

**Backend Requirements:**

- API endpoint untuk statistik kehadiran
- Agregasi data per mata kuliah

**Estimasi:** 2-3 hari

---

#### 3. 📤 Export Riwayat Absensi ke PDF

**Deskripsi:**  
Fitur untuk mengunduh riwayat absensi dalam format PDF.

**Fitur Detail:**

- Export semua riwayat atau by filter
- Filter by mata kuliah
- Filter by periode (bulan/semester)
- PDF dengan header kampus
- Tabel riwayat dengan status
- Total kehadiran dan persentase
- QR code untuk verifikasi

**Dependencies:**

- `pdf` package
- `printing` package
- `path_provider` untuk save file

**Backend Requirements:**

- API endpoint untuk generate PDF (opsional, bisa di Flutter)

**Estimasi:** 2-3 hari

---

### 🔶 Medium Priority

#### 4. ✏️ Edit File Tugas yang Sudah Diupload

**Deskripsi:**  
Mahasiswa bisa mengganti file jawaban yang sudah diupload sebelum deadline.

**Fitur Detail:**

- Tombol "Ganti File" di detail tugas
- Upload file baru menggantikan yang lama
- History upload (opsional)
- Konfirmasi sebelum replace
- Hanya bisa edit sebelum deadline
- Notifikasi ke dosen jika file diganti

**Backend Requirements:**

- Update endpoint upload tugas
- Soft delete file lama atau versioning

**Estimasi:** 1-2 hari

---

#### 5. 📅 Kalender Akademik

**Deskripsi:**  
Kalender lengkap dengan jadwal kuliah, deadline tugas, dan event kampus.

**Fitur Detail:**

- Calendar view (month/week)
- Highlight tanggal dengan jadwal
- Highlight deadline tugas
- Event kampus (libur, ujian, dll)
- Tap tanggal untuk lihat detail
- Add to device calendar
- Reminder untuk event penting

**Dependencies:**

- `table_calendar` package
- `add_2_calendar` untuk sync ke device

**Backend Requirements:**

- API endpoint untuk event akademik
- CRUD event kampus (admin)

**Estimasi:** 3-4 hari

---

#### 6. 🔐 Biometric Login

**Deskripsi:**  
Login menggunakan fingerprint atau face recognition.

**Fitur Detail:**

- Enable/disable biometric di settings
- Fingerprint authentication
- Face ID authentication (iOS)
- Fallback ke password jika gagal
- Security check saat enable
- Auto-login dengan biometric

**Dependencies:**

- `local_auth` package

**Backend Requirements:**

- Tidak ada (client-side only)

**Estimasi:** 1-2 hari

---

### 🔷 Low Priority

#### 7. 💬 Chat dengan Dosen

**Deskripsi:**  
Fitur chat real-time antara mahasiswa dan dosen.

**Fitur Detail:**

- List dosen dari mata kuliah yang diambil
- Chat room per dosen
- Send text message
- Send file/image
- Read receipt
- Typing indicator
- Push notification untuk pesan baru

**Dependencies:**

- `firebase_database` atau `socket_io_client`
- `image_picker` untuk send image

**Backend Requirements:**

- Real-time database (Firebase Realtime DB atau Socket.io)
- Chat messages table
- FCM untuk notification

**Estimasi:** 5-7 hari

---

#### 8. 🌐 Multi-Bahasa (Indonesia/English)

**Deskripsi:**  
Support multiple languages untuk aplikasi.

**Fitur Detail:**

- Switch bahasa di settings
- Indonesia (default)
- English
- Auto-detect device language
- Translate semua text di app
- Format tanggal sesuai locale

**Dependencies:**

- `flutter_localizations`
- `intl` package

**Backend Requirements:**

- Tidak ada (client-side only)

**Estimasi:** 3-4 hari

---

#### 9. 🏆 Achievement Badges

**Deskripsi:**  
Gamification dengan badge untuk motivasi mahasiswa.

**Fitur Detail:**

- Badge 100% kehadiran (per bulan/semester)
- Badge "Early Bird" (selalu hadir tepat waktu)
- Badge "Rajin" (tidak pernah telat submit tugas)
- Badge "Perfect Score" (nilai A semua tugas)
- Badge "Active Learner" (sering download materi)
- Display badges di profile
- Share badges ke social media

**Backend Requirements:**

- Achievement system logic
- Badges table
- API untuk check dan unlock badges

**Estimasi:** 4-5 hari

---

## 📊 Prioritas Pengembangan

### Sprint 1 (Week 1-2)

1. ✅ Reminder Deadline Tugas
2. ✅ Grafik Kehadiran per Mata Kuliah
3. ✅ Export Riwayat Absensi ke PDF

### Sprint 2 (Week 3-4)

4. ✅ Edit File Tugas yang Sudah Diupload
5. ✅ Kalender Akademik
6. ✅ Biometric Login

### Sprint 3 (Week 5-6)

7. ✅ Chat dengan Dosen
8. ✅ Multi-Bahasa
9. ✅ Achievement Badges

---

## 🛠 Technical Stack

### Frontend (Flutter)

- **Framework:** Flutter 3.x
- **State Management:** Provider
- **HTTP Client:** Dio
- **Local Storage:** SharedPreferences
- **Navigation:** Navigator 2.0

### Backend (Laravel)

- **Framework:** Laravel 11.x
- **Database:** MySQL
- **Authentication:** Laravel Sanctum
- **File Storage:** Local Storage
- **Push Notification:** Firebase Cloud Messaging (FCM)

### Dependencies (Flutter)

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # HTTP & API
  dio: ^5.4.0

  # Local Storage
  shared_preferences: ^2.2.2

  # UI Components
  intl: ^0.19.0

  # QR Scanner
  mobile_scanner: ^3.5.5

  # Location
  geolocator: ^11.0.0

  # File Handling
  file_picker: ^6.1.1
  url_launcher: ^6.2.2

  # Push Notification
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9

  # Charts (untuk fitur baru)
  fl_chart: ^0.66.0

  # PDF (untuk fitur baru)
  pdf: ^3.10.7
  printing: ^5.12.0

  # Calendar (untuk fitur baru)
  table_calendar: ^3.0.9

  # Biometric (untuk fitur baru)
  local_auth: ^2.1.8
```

### API Endpoints Summary

**Authentication:**

- `POST /login` - Login
- `POST /logout` - Logout
- `GET /user` - Get current user

**Dashboard:**

- `GET /dashboard/mahasiswa/{id}/stats` - Statistik mahasiswa

**Mata Kuliah:**

- `GET /mata-kuliah/mahasiswa/me` - Jadwal mahasiswa

**Absensi:**

- `POST /absensi/scan` - Submit absensi via QR
- `GET /absensi/riwayat` - Riwayat absensi

**Tugas:**

- `GET /tugas/mahasiswa` - Daftar tugas
- `GET /tugas/{id}` - Detail tugas
- `POST /tugas/{id}/upload` - Upload jawaban

**Materi:**

- `GET /materi/mahasiswa` - Daftar materi
- `GET /materi/{id}` - Detail materi

**Pengumuman:**

- `GET /pengumuman` - Daftar pengumuman
- `GET /pengumuman/{id}` - Detail pengumuman
- `POST /pengumuman/{id}/mark-as-read` - Mark as read
- `POST /pengumuman/mark-all-as-read` - Mark all as read
- `GET /pengumuman/unread-count` - Unread count

**Profile:**

- `GET /user/profile` - Get profile
- `PUT /user/profile` - Update profile
- `PUT /user/change-password` - Change password

---

## 📝 Notes

### Fitur yang Sudah Berfungsi dengan Baik:

1. ✅ Push notification untuk pengumuman baru
2. ✅ Pull-to-refresh di semua halaman
3. ✅ Dark mode di semua halaman
4. ✅ QR Scanner untuk absensi
5. ✅ Upload dan download file tugas/materi
6. ✅ Filter dan search di berbagai halaman

### Known Issues:

- ⚠️ Belum ada validasi ukuran file saat upload tugas
- ⚠️ Belum ada compress image untuk foto profil
- ⚠️ Belum ada offline mode/cache

### Improvement Ideas:

- 💡 Add skeleton loading untuk better UX
- 💡 Add shimmer effect saat loading
- 💡 Add empty state illustration
- 💡 Add error state illustration
- 💡 Add onboarding screen untuk user baru
- 💡 Add tutorial/guide untuk fitur-fitur

---

## 📞 Contact

**Developer:** [Your Name]  
**Email:** [your.email@example.com]  
**Project:** Aplikasi Absensi Kampus  
**Last Updated:** 1 Juni 2026

---

**© 2026 Aplikasi Absensi Kampus. All rights reserved.**
