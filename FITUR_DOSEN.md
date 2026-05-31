# 📱 Dokumentasi Fitur Aplikasi Dosen

**Aplikasi Absensi Kampus - Modul Dosen**  
**Tanggal:** 1 Juni 2026  
**Status:** 🔄 In Development (20% Complete)

---

## 📋 Daftar Isi

1. [Status Saat Ini](#status-saat-ini)
2. [Fitur yang Perlu Dibangun](#fitur-yang-perlu-dibangun)
3. [Prioritas Pengembangan](#prioritas-pengembangan)
4. [Technical Requirements](#technical-requirements)

---

## 🔍 Status Saat Ini

### ✅ Yang Sudah Ada (Minimal)

**File:** `dosen_dashboard_screen.dart`

**Fitur Basic:**

- ✅ Welcome section dengan nama dosen dan NIP
- ✅ Statistics cards (dummy data):
  - Mata Kuliah: 5
  - Total Mahasiswa: 120
  - Hadir Hari Ini: 95
  - Tugas Aktif: 8
- ✅ Quick actions (belum fungsional):
  - Generate QR
  - Upload Materi
- ✅ List mata kuliah (dummy data)
- ✅ Bottom navigation (4 tabs)

### ❌ Yang Belum Ada

- ❌ Integrasi dengan backend API
- ❌ Generate QR Code untuk absensi
- ❌ Manajemen mata kuliah
- ❌ Manajemen tugas
- ❌ Manajemen materi
- ❌ Lihat daftar mahasiswa per kelas
- ❌ Rekap kehadiran mahasiswa
- ❌ Penilaian tugas
- ❌ Profile management
- ❌ Dark mode support
- ❌ Push notification

---

## 🚀 Fitur yang Perlu Dibangun

### 1. 🏠 Dashboard Dosen (Enhanced)

**Priority:** 🔥 High  
**Estimasi:** 2-3 hari

**Fitur Detail:**

- ✅ Header dengan foto profil dan info dosen
- ✅ Real statistics dari API:
  - Total mata kuliah yang diampu
  - Total mahasiswa dari semua kelas
  - Kehadiran hari ini (total yang sudah absen)
  - Tugas aktif (belum deadline)
- ✅ Jadwal mengajar hari ini
- ✅ Quick actions:
  - Generate QR untuk absensi
  - Upload materi baru
  - Buat tugas baru
  - Lihat pengumuman
- ✅ List mata kuliah dengan:
  - Kode MK
  - Nama MK
  - Jumlah mahasiswa
  - Persentase kehadiran rata-rata
  - Jadwal (hari, jam)
- ✅ Dark mode support
- ✅ Pull-to-refresh

**API Endpoints:**

- `GET /dashboard/dosen/{id}/stats` - Statistik dosen
- `GET /mata-kuliah/dosen/me` - Mata kuliah yang diampu

---

### 2. 📷 Generate QR Code untuk Absensi

**Priority:** 🔥 High  
**Estimasi:** 2-3 hari

**Fitur Detail:**

- ✅ Pilih mata kuliah dari dropdown
- ✅ Set durasi QR aktif (15, 30, 45, 60 menit)
- ✅ Generate QR code dengan session ID unik
- ✅ Display QR code fullscreen
- ✅ Timer countdown durasi QR
- ✅ Auto-refresh QR setiap generate
- ✅ Tombol "Stop Session" untuk menutup QR
- ✅ Real-time counter mahasiswa yang sudah absen
- ✅ List mahasiswa yang sudah absen (live update)
- ✅ Notifikasi saat ada mahasiswa absen
- ✅ History QR sessions
- ✅ Dark mode support

**API Endpoints:**

- `POST /qr-session/generate` - Generate QR session
- `GET /qr-session/{id}` - Get session detail
- `PUT /qr-session/{id}/close` - Close session
- `GET /qr-session/{id}/attendances` - List mahasiswa yang absen
- `GET /qr-session/history` - History sessions

**Dependencies:**

- `qr_flutter` - Generate QR code
- `timer_builder` - Countdown timer

---

### 3. 📚 Manajemen Mata Kuliah

**Priority:** 🔥 High  
**Estimasi:** 2-3 hari

**Fitur Detail:**

- ✅ List mata kuliah yang diampu
- ✅ Detail mata kuliah:
  - Info: Kode, Nama, SKS, Semester
  - Jadwal: Hari, Jam, Ruangan
  - Jumlah mahasiswa terdaftar
  - Persentase kehadiran rata-rata
- ✅ Daftar mahasiswa per mata kuliah:
  - Nama, NIM
  - Foto profil
  - Persentase kehadiran
  - Status (Aman/Bahaya jika < 75%)
- ✅ Filter mahasiswa:
  - Semua
  - Kehadiran Aman (≥ 75%)
  - Kehadiran Bahaya (< 75%)
- ✅ Search mahasiswa by nama/NIM
- ✅ Export daftar mahasiswa ke Excel/PDF
- ✅ Dark mode support
- ✅ Pull-to-refresh

**API Endpoints:**

- `GET /mata-kuliah/dosen/me` - List mata kuliah
- `GET /mata-kuliah/{id}` - Detail mata kuliah
- `GET /mata-kuliah/{id}/mahasiswa` - Daftar mahasiswa
- `GET /mata-kuliah/{id}/export` - Export data

---

### 4. 📊 Rekap Kehadiran

**Priority:** 🔥 High  
**Estimasi:** 3-4 hari

**Fitur Detail:**

- ✅ Pilih mata kuliah
- ✅ Pilih periode (minggu ini, bulan ini, semester ini, custom)
- ✅ Tabel rekap kehadiran:
  - Kolom: Nama, NIM, Hadir, Izin, Sakit, Alpa, %
  - Sort by nama, NIM, atau persentase
  - Color coding: Hijau (≥75%), Kuning (60-74%), Merah (<60%)
- ✅ Grafik kehadiran:
  - Bar chart per mahasiswa
  - Line chart trend kehadiran per pertemuan
  - Pie chart status kehadiran (Hadir, Izin, Sakit, Alpa)
- ✅ Summary statistics:
  - Total pertemuan
  - Rata-rata kehadiran kelas
  - Mahasiswa dengan kehadiran tertinggi
  - Mahasiswa dengan kehadiran terendah
- ✅ Filter mahasiswa bermasalah (< 75%)
- ✅ Export rekap ke Excel/PDF
- ✅ Send email reminder ke mahasiswa bermasalah
- ✅ Dark mode support

**API Endpoints:**

- `GET /absensi/rekap/{mataKuliahId}` - Rekap kehadiran
- `POST /absensi/rekap/export` - Export rekap
- `POST /absensi/send-reminder` - Send reminder email

**Dependencies:**

- `fl_chart` - Charts
- `excel` - Export to Excel
- `pdf` - Export to PDF

---

### 5. 📝 Manajemen Tugas

**Priority:** 🔶 Medium  
**Estimasi:** 3-4 hari

**Fitur Detail:**

- ✅ List tugas yang dibuat
- ✅ Filter by mata kuliah
- ✅ Filter by status (Aktif, Selesai, Overdue)
- ✅ Create tugas baru:
  - Pilih mata kuliah
  - Judul tugas
  - Deskripsi
  - Deadline (tanggal & waktu)
  - Upload file tugas (opsional)
- ✅ Edit tugas (sebelum ada yang submit)
- ✅ Delete tugas
- ✅ Detail tugas:
  - Info tugas
  - Statistik pengumpulan:
    - Sudah mengumpulkan: X/Y mahasiswa
    - Belum mengumpulkan: Y mahasiswa
    - Terlambat: Z mahasiswa
  - List pengumpulan:
    - Nama mahasiswa
    - Tanggal upload
    - Status (Tepat Waktu/Terlambat)
    - Nilai (jika sudah dinilai)
- ✅ Download file jawaban mahasiswa
- ✅ Penilaian tugas:
  - Input nilai (0-100)
  - Catatan untuk mahasiswa
  - Bulk grading (nilai sama untuk semua)
- ✅ Send reminder ke mahasiswa yang belum submit
- ✅ Dark mode support
- ✅ Pull-to-refresh

**API Endpoints:**

- `GET /tugas/dosen` - List tugas dosen
- `POST /tugas` - Create tugas
- `PUT /tugas/{id}` - Update tugas
- `DELETE /tugas/{id}` - Delete tugas
- `GET /tugas/{id}/pengumpulan` - List pengumpulan
- `POST /tugas/pengumpulan/{id}/nilai` - Beri nilai
- `POST /tugas/{id}/send-reminder` - Send reminder

---

### 6. 📖 Manajemen Materi

**Priority:** 🔶 Medium  
**Estimasi:** 2-3 hari

**Fitur Detail:**

- ✅ List materi yang diupload
- ✅ Filter by mata kuliah
- ✅ Upload materi baru:
  - Pilih mata kuliah
  - Judul materi
  - Deskripsi
  - Upload file (PDF, PPT, DOCX, ZIP)
  - Multiple files support
- ✅ Edit materi
- ✅ Delete materi
- ✅ Detail materi:
  - Info materi
  - Statistik download:
    - Total download
    - Mahasiswa yang sudah download
    - Mahasiswa yang belum download
- ✅ Send notification ke mahasiswa saat upload materi baru
- ✅ Dark mode support
- ✅ Pull-to-refresh

**API Endpoints:**

- `GET /materi/dosen` - List materi dosen
- `POST /materi` - Upload materi
- `PUT /materi/{id}` - Update materi
- `DELETE /materi/{id}` - Delete materi
- `GET /materi/{id}/stats` - Statistik download

**Dependencies:**

- `file_picker` - File selection
- `dio` - File upload with progress

---

### 7. 📢 Pengumuman

**Priority:** 🔶 Medium  
**Estimasi:** 2 hari

**Fitur Detail:**

- ✅ List pengumuman (sama seperti mahasiswa)
- ✅ Filter (Semua, Info, Penting, Urgent)
- ✅ Detail pengumuman
- ✅ Mark as read
- ✅ Push notification untuk pengumuman baru
- ✅ Dark mode support
- ✅ Pull-to-refresh

**Note:** Fitur ini sama dengan mahasiswa, hanya perlu copy dan adjust.

---

### 8. 👤 Profile Management

**Priority:** 🔶 Medium  
**Estimasi:** 1-2 hari

**Fitur Detail:**

- ✅ Header dengan foto profil dan info dosen
- ✅ Info: Nama, NIP, Email, No HP
- ✅ Menu Akun:
  - Edit Profil
  - Ubah Password
  - Upload Foto Profil
- ✅ Menu Pengaturan:
  - Mode Gelap (toggle)
  - Notifikasi (preferences)
  - Bahasa
- ✅ Menu Bantuan:
  - Bantuan & Dukungan
  - Syarat & Ketentuan
  - Kebijakan Privasi
  - Tentang Aplikasi
- ✅ Logout dengan konfirmasi
- ✅ Dark mode support

**API Endpoints:**

- `GET /user/profile` - Get profile
- `PUT /user/profile` - Update profile
- `PUT /user/change-password` - Change password
- `POST /user/upload-photo` - Upload photo

---

### 9. 📅 Jadwal Mengajar

**Priority:** 🔷 Low  
**Estimasi:** 2 hari

**Fitur Detail:**

- ✅ Calendar view dengan jadwal mengajar
- ✅ Filter per hari (Senin-Sabtu)
- ✅ Info jadwal:
  - Mata kuliah
  - Waktu
  - Ruangan
  - Jumlah mahasiswa
- ✅ Quick action: Generate QR dari jadwal
- ✅ Dark mode support
- ✅ Pull-to-refresh

---

## 📊 Prioritas Pengembangan

### Sprint 1 (Week 1-2) - Core Features

**Target:** Dashboard + QR Generator + Mata Kuliah

1. ✅ **Dashboard Dosen (Enhanced)**
   - Integrasi API real data
   - Statistics cards
   - Jadwal hari ini
   - Quick actions
   - Dark mode

2. ✅ **Generate QR Code**
   - Generate QR session
   - Display QR fullscreen
   - Timer countdown
   - Real-time attendance list
   - Close session

3. ✅ **Manajemen Mata Kuliah**
   - List mata kuliah
   - Detail mata kuliah
   - Daftar mahasiswa
   - Filter & search

**Estimasi Total:** 6-9 hari

---

### Sprint 2 (Week 3-4) - Attendance & Grading

**Target:** Rekap Kehadiran + Manajemen Tugas

4. ✅ **Rekap Kehadiran**
   - Tabel rekap
   - Grafik kehadiran
   - Export Excel/PDF
   - Send reminder

5. ✅ **Manajemen Tugas**
   - CRUD tugas
   - List pengumpulan
   - Penilaian tugas
   - Send reminder

**Estimasi Total:** 6-8 hari

---

### Sprint 3 (Week 5-6) - Content & Profile

**Target:** Materi + Pengumuman + Profile

6. ✅ **Manajemen Materi**
   - Upload materi
   - CRUD materi
   - Statistik download

7. ✅ **Pengumuman**
   - List & detail
   - Push notification

8. ✅ **Profile Management**
   - Edit profile
   - Change password
   - Settings

**Estimasi Total:** 5-7 hari

---

### Sprint 4 (Week 7) - Polish & Testing

**Target:** Jadwal + Testing + Bug Fixes

9. ✅ **Jadwal Mengajar**
   - Calendar view
   - Quick actions

10. ✅ **Testing & Bug Fixes**
    - Unit tests
    - Integration tests
    - Bug fixes
    - Performance optimization

**Estimasi Total:** 3-5 hari

---

## 🎯 Total Timeline

**Total Estimasi:** 20-29 hari kerja (4-6 minggu)

**Breakdown:**

- Sprint 1: 6-9 hari (Dashboard, QR, Mata Kuliah)
- Sprint 2: 6-8 hari (Rekap, Tugas)
- Sprint 3: 5-7 hari (Materi, Pengumuman, Profile)
- Sprint 4: 3-5 hari (Jadwal, Testing)

---

## 🛠 Technical Requirements

### Backend API Endpoints (Yang Perlu Dibuat)

**Dashboard:**

- `GET /dashboard/dosen/{id}/stats` - Statistik dosen

**Mata Kuliah:**

- `GET /mata-kuliah/dosen/me` - List mata kuliah dosen
- `GET /mata-kuliah/{id}` - Detail mata kuliah
- `GET /mata-kuliah/{id}/mahasiswa` - Daftar mahasiswa
- `GET /mata-kuliah/{id}/export` - Export data

**QR Session:**

- `POST /qr-session/generate` - Generate QR session
- `GET /qr-session/{id}` - Get session detail
- `PUT /qr-session/{id}/close` - Close session
- `GET /qr-session/{id}/attendances` - List mahasiswa yang absen
- `GET /qr-session/history` - History sessions

**Absensi:**

- `GET /absensi/rekap/{mataKuliahId}` - Rekap kehadiran
- `POST /absensi/rekap/export` - Export rekap
- `POST /absensi/send-reminder` - Send reminder email

**Tugas:**

- `GET /tugas/dosen` - List tugas dosen
- `POST /tugas` - Create tugas
- `PUT /tugas/{id}` - Update tugas
- `DELETE /tugas/{id}` - Delete tugas
- `GET /tugas/{id}/pengumpulan` - List pengumpulan
- `POST /tugas/pengumpulan/{id}/nilai` - Beri nilai
- `POST /tugas/{id}/send-reminder` - Send reminder

**Materi:**

- `GET /materi/dosen` - List materi dosen
- `POST /materi` - Upload materi
- `PUT /materi/{id}` - Update materi
- `DELETE /materi/{id}` - Delete materi
- `GET /materi/{id}/stats` - Statistik download

---

### Flutter Dependencies

```yaml
dependencies:
  # Existing
  flutter:
    sdk: flutter
  provider: ^6.1.1
  dio: ^5.4.0
  shared_preferences: ^2.2.2
  intl: ^0.19.0

  # QR Code
  qr_flutter: ^4.1.0

  # Charts
  fl_chart: ^0.66.0

  # File Handling
  file_picker: ^6.1.1

  # Export
  excel: ^4.0.2
  pdf: ^3.10.7
  printing: ^5.12.0

  # Timer
  timer_builder: ^2.0.0

  # Push Notification (already exists)
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9
```

---

### Database Tables (Yang Perlu Ditambahkan)

**qr_sessions table:**

```sql
CREATE TABLE qr_sessions (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    mata_kuliah_id BIGINT NOT NULL,
    dosen_id BIGINT NOT NULL,
    qr_code VARCHAR(255) UNIQUE NOT NULL,
    started_at DATETIME NOT NULL,
    expires_at DATETIME NOT NULL,
    closed_at DATETIME NULL,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (mata_kuliah_id) REFERENCES mata_kuliah(id),
    FOREIGN KEY (dosen_id) REFERENCES users(id)
);
```

**tugas table (if not exists):**

```sql
CREATE TABLE tugas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    mata_kuliah_id BIGINT NOT NULL,
    judul VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    file_tugas VARCHAR(255),
    deadline DATETIME NOT NULL,
    created_by BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (mata_kuliah_id) REFERENCES mata_kuliah(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);
```

**pengumpulan_tugas table (if not exists):**

```sql
CREATE TABLE pengumpulan_tugas (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    tugas_id BIGINT NOT NULL,
    mahasiswa_id BIGINT NOT NULL,
    file_jawaban VARCHAR(255) NOT NULL,
    tanggal_upload DATETIME NOT NULL,
    nilai INT NULL,
    catatan TEXT NULL,
    sudah_dinilai BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (tugas_id) REFERENCES tugas(id),
    FOREIGN KEY (mahasiswa_id) REFERENCES users(id)
);
```

**materi table (if not exists):**

```sql
CREATE TABLE materi (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    mata_kuliah_id BIGINT NOT NULL,
    judul VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    file_materi VARCHAR(255) NOT NULL,
    created_by BIGINT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (mata_kuliah_id) REFERENCES mata_kuliah(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
);
```

---

## 📝 Notes

### Perbedaan dengan Modul Mahasiswa:

**Mahasiswa (Consumer):**

- Melihat data
- Submit tugas
- Scan QR untuk absen
- Download materi
- Read-only untuk pengumuman

**Dosen (Creator/Manager):**

- Membuat dan mengelola data
- Generate QR untuk absensi
- Upload materi dan tugas
- Menilai tugas mahasiswa
- Melihat rekap dan statistik
- Export data
- Send notifications/reminders

### Key Features yang Membedakan:

1. **QR Generator** (Dosen) vs **QR Scanner** (Mahasiswa)
2. **Upload Materi/Tugas** (Dosen) vs **Download/Submit** (Mahasiswa)
3. **Penilaian** (Dosen) vs **Lihat Nilai** (Mahasiswa)
4. **Rekap & Analytics** (Dosen) vs **Personal Stats** (Mahasiswa)
5. **Manajemen Kelas** (Dosen) vs **Lihat Jadwal** (Mahasiswa)

---

## 🎯 Next Steps

### Immediate Actions:

1. ✅ Review dan approve dokumentasi ini
2. 🔄 Setup backend API endpoints
3. 🔄 Create database migrations
4. 🔄 Start Sprint 1 development

### Development Order:

1. **Backend First:** Create all API endpoints
2. **Frontend:** Build screens one by one
3. **Integration:** Connect frontend with backend
4. **Testing:** Test each feature thoroughly
5. **Polish:** Dark mode, animations, UX improvements

---

**Last Updated:** 1 Juni 2026  
**Next Review:** 8 Juni 2026

---

**© 2026 Aplikasi Absensi Kampus. All rights reserved.**
