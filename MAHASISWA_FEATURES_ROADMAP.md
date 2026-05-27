# Roadmap Fitur Mahasiswa 🎓

## ✅ TAHAP 1: Scan QR Absensi (SELESAI)

**Status:** COMPLETE

- [x] QR Scanner Screen dengan camera view
- [x] Auto-detect QR code
- [x] Flashlight toggle & switch camera
- [x] Success/Error dialog
- [x] Auto reload stats setelah absensi
- [x] FAB button "Scan QR" di dashboard

---

## 📋 TAHAP 2: Jadwal Kuliah (NEXT)

**Prioritas:** HIGH
**Fitur yang akan dibuat:**

- [ ] **Schedule Screen** - Tampilan jadwal kuliah mahasiswa
  - List jadwal per hari (Senin - Jumat)
  - Filter by hari/minggu
  - Detail mata kuliah (waktu, ruangan, dosen)
  - Status kehadiran per pertemuan
  - Kalender view (opsional)

**API yang dibutuhkan:**

- `GET /api/mahasiswa/{id}/jadwal` - Get jadwal mahasiswa
- `GET /api/mahasiswa/{id}/jadwal?hari=senin` - Filter by hari

**Komponen:**

- `schedule_screen.dart` - Main schedule view
- `schedule_service.dart` - API service untuk jadwal
- `schedule_model.dart` - Model untuk jadwal

---

## 📊 TAHAP 3: Riwayat Absensi

**Prioritas:** HIGH
**Fitur yang akan dibuat:**

- [ ] **History Screen** - Riwayat absensi mahasiswa
  - List semua absensi (hadir/izin/alpha)
  - Filter by mata kuliah
  - Filter by tanggal/bulan
  - Detail per absensi (waktu, lokasi, status)
  - Statistik kehadiran per mata kuliah
  - Export riwayat (PDF/Excel)

**API yang sudah ada:**

- `GET /api/mahasiswa/{id}/absensi` - Get riwayat absensi
- `GET /api/mahasiswa/{id}/absensi?mata_kuliah_id=1` - Filter by MK

**Komponen:**

- `history_screen.dart` - Main history view
- Sudah ada: `absensi_service.dart` (getRiwayatAbsensi)

---

## 👤 TAHAP 4: Profil Mahasiswa

**Prioritas:** MEDIUM
**Fitur yang akan dibuat:**

- [ ] **Profile Screen** - Profil & pengaturan mahasiswa
  - Info mahasiswa (nama, NIM, email, foto)
  - Edit profil (nama, email, password, foto)
  - Statistik keseluruhan (total kehadiran, persentase)
  - Pengaturan notifikasi
  - Logout
  - Dark mode toggle

**API yang dibutuhkan:**

- `GET /api/user/profile` - Get user profile
- `PUT /api/user/profile` - Update profile
- `POST /api/user/change-password` - Change password
- `POST /api/user/upload-photo` - Upload foto profil

**Komponen:**

- `profile_screen.dart` - Main profile view
- `edit_profile_screen.dart` - Edit profile form
- `user_service.dart` - API service untuk user

---

## 📢 TAHAP 5: Notifikasi & Pengumuman

**Prioritas:** MEDIUM
**Fitur yang akan dibuat:**

- [ ] **Notification Center** - Pusat notifikasi mahasiswa
  - Bell icon dengan badge counter di dashboard
  - List pengumuman dari admin/dosen
  - Mark as read functionality
  - Detail pengumuman dengan attachment
  - Push notification integration
  - Filter by kategori (umum/mata kuliah)

**API yang sudah ada:**

- `GET /api/pengumuman` - Get all pengumuman
- `GET /api/pengumuman/unread/count` - Get unread count
- `POST /api/pengumuman/{id}/mark-as-read` - Mark as read

**Komponen:**

- `notification_center_screen.dart` - Notification list
- `pengumuman_service.dart` - API service untuk pengumuman
- Update dashboard: Add bell icon dengan badge

---

## 📝 TAHAP 6: Tugas & Materi

**Prioritas:** MEDIUM
**Fitur yang akan dibuat:**

- [ ] **Tugas Screen** - Manajemen tugas kuliah
  - List tugas per mata kuliah
  - Status tugas (belum dikerjakan/sudah dikumpulkan)
  - Upload tugas (file/dokumen)
  - Deadline countdown
  - Riwayat pengumpulan tugas
- [ ] **Materi Screen** - Akses materi kuliah
  - List materi per mata kuliah
  - Download materi (PDF/PPT/dokumen)
  - Preview materi
  - Bookmark materi favorit

**API yang dibutuhkan:**

- `GET /api/mahasiswa/{id}/tugas` - Get tugas mahasiswa
- `POST /api/tugas/{id}/submit` - Submit tugas
- `GET /api/mahasiswa/{id}/materi` - Get materi mahasiswa
- `GET /api/materi/{id}/download` - Download materi

**Komponen:**

- `tugas_screen.dart` - Tugas list & detail
- `submit_tugas_screen.dart` - Form submit tugas
- `materi_screen.dart` - Materi list & preview
- `tugas_service.dart` - API service untuk tugas
- `materi_service.dart` - API service untuk materi

---

## 📈 TAHAP 7: Statistik & Laporan

**Prioritas:** LOW
**Fitur yang akan dibuat:**

- [ ] **Statistics Screen** - Statistik kehadiran mahasiswa
  - Grafik kehadiran per bulan
  - Persentase kehadiran per mata kuliah
  - Perbandingan dengan rata-rata kelas
  - Prediksi kehadiran akhir semester
  - Export laporan (PDF)

**API yang dibutuhkan:**

- `GET /api/mahasiswa/{id}/statistics` - Get statistik mahasiswa
- `GET /api/mahasiswa/{id}/statistics/export` - Export statistik

**Komponen:**

- `mahasiswa_statistics_screen.dart` - Statistics view
- Chart library: `fl_chart` atau `syncfusion_flutter_charts`

---

## 🎯 TAHAP 8: Fitur Tambahan (Opsional)

**Prioritas:** LOW
**Fitur yang bisa ditambahkan:**

- [ ] **Izin/Sakit** - Form pengajuan izin/sakit
- [ ] **Chat/Forum** - Diskusi per mata kuliah
- [ ] **Kalender Akademik** - Kalender kegiatan kampus
- [ ] **Nilai** - Lihat nilai per mata kuliah
- [ ] **KRS** - Kartu Rencana Studi
- [ ] **Pembayaran** - Info pembayaran kuliah

---

## 📊 Progress Summary

| Tahap | Fitur                   | Status      | Prioritas |
| ----- | ----------------------- | ----------- | --------- |
| 1     | Scan QR Absensi         | ✅ COMPLETE | HIGH      |
| 2     | Jadwal Kuliah           | ⏳ NEXT     | HIGH      |
| 3     | Riwayat Absensi         | 📋 TODO     | HIGH      |
| 4     | Profil Mahasiswa        | 📋 TODO     | MEDIUM    |
| 5     | Notifikasi & Pengumuman | 📋 TODO     | MEDIUM    |
| 6     | Tugas & Materi          | 📋 TODO     | MEDIUM    |
| 7     | Statistik & Laporan     | 📋 TODO     | LOW       |
| 8     | Fitur Tambahan          | 📋 TODO     | LOW       |

---

## 🚀 Rekomendasi Urutan Pengerjaan

**Untuk pengalaman mahasiswa yang lengkap, urutan yang disarankan:**

1. ✅ **Scan QR Absensi** (SELESAI)
2. 🔥 **Jadwal Kuliah** (Penting untuk mahasiswa tahu jadwal)
3. 🔥 **Riwayat Absensi** (Mahasiswa perlu lihat riwayat kehadiran)
4. 📢 **Notifikasi & Pengumuman** (Komunikasi dengan admin/dosen)
5. 👤 **Profil Mahasiswa** (Manajemen akun)
6. 📝 **Tugas & Materi** (Fitur akademik lengkap)
7. 📈 **Statistik & Laporan** (Analisis kehadiran)
8. 🎯 **Fitur Tambahan** (Enhancement)

---

## 💡 Catatan Penting

- Semua screen harus support **dark mode**
- Gunakan **University Blue (#003D9B)** sebagai primary color
- Implementasi **pull to refresh** di semua list screen
- Tambahkan **loading state** dan **error handling**
- Gunakan **cached_network_image** untuk foto/gambar
- Implementasi **offline mode** untuk data penting (opsional)
- Pastikan **responsive** untuk berbagai ukuran layar

---

**Tahap berikutnya:** TAHAP 2 - Jadwal Kuliah
**Estimasi waktu:** 2-3 jam per tahap (tergantung kompleksitas)
