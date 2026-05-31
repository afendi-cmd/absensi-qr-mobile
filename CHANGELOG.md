# 📝 Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.2.0] - 2026-06-01

### ✨ Added

- **Pull-to-Refresh:** Semua halaman mahasiswa sekarang support pull-to-refresh
  - Dashboard: Refresh stats, jadwal, dan notifikasi
  - Jadwal: Refresh daftar jadwal kuliah
  - Riwayat: Refresh riwayat absensi
  - Pengumuman: Refresh daftar pengumuman
- **Mark All as Read:** Tombol untuk tandai semua pengumuman sudah dibaca
- **Push Notification:** Notifikasi otomatis saat ada pengumuman baru
  - Title format: 📢 [Tipe]: [Judul]
  - Body: Preview isi pengumuman (100 karakter)
  - Auto-update badge count

### 🔧 Fixed

- Fixed badge notifikasi terlalu besar menutupi icon lonceng
- Fixed teks lokasi dan dosen tidak terlihat di light mode
- Fixed error 500 saat export data pengumuman
- Fixed field `name` vs `nama` di database
- Fixed QR button muncul di semua tab (sekarang hanya di Beranda)

### 🎨 Improved

- Improved dark mode consistency di semua halaman
- Improved badge positioning dan sizing
- Improved text contrast untuk better readability

---

## [1.1.0] - 2026-04-15

### ✨ Added

- **Dark Mode:** Support mode gelap di semua halaman mahasiswa
  - 12 halaman dengan dark mode support
  - Toggle di Profile → Pengaturan
  - Palet warna konsisten
- **Back Button:** Tambah back button di halaman pengumuman
- **Profile Menu:** Semua menu profile sekarang berfungsi
  - Edit Profil
  - Ubah Password
  - Notifikasi, Bahasa, Bantuan (info dialogs)

### 🔧 Fixed

- Fixed menu profile tidak bisa diakses
- Fixed pengumuman tidak ada back button

---

## [1.0.0] - 2026-03-01

### 🎉 Initial Release

### ✨ Features

- **Authentication**
  - Login dengan email/password
  - Logout dengan konfirmasi
  - Auto-login dengan saved token

- **Dashboard Mahasiswa**
  - Greeting dengan nama mahasiswa
  - Card persentase kehadiran
  - Jadwal hari ini (3 teratas)
  - Quick actions (Kalender, Tugas & Ujian)
  - Badge notifikasi pengumuman

- **Jadwal Kuliah**
  - Filter per hari (Senin-Sabtu)
  - Status jadwal (Belum Mulai, Berlangsung, Selesai)
  - Tombol scan QR untuk jadwal yang berlangsung
  - Info dosen dan ruangan

- **QR Scanner**
  - Scan QR code untuk absensi
  - Validasi lokasi
  - Feedback sukses/gagal

- **Riwayat Absensi**
  - List riwayat dengan grouping per tanggal
  - Filter by mata kuliah
  - Filter by bulan
  - Status kehadiran (Hadir, Izin, Sakit, Alpa)

- **Tugas & Materi**
  - Tab view: Tugas dan Materi
  - Upload jawaban tugas (PDF, DOC, DOCX)
  - Download file tugas dan materi
  - Lihat nilai dan catatan dosen
  - Status tugas (Belum Dikumpulkan, Sudah Dikumpulkan, Terlambat)

- **Pengumuman**
  - List pengumuman dengan filter
  - Filter: Semua, Belum Dibaca, Info, Penting, Urgent
  - Badge unread count
  - Mark as read otomatis
  - Detail pengumuman

- **Profile**
  - Edit profile (nama, email, no HP)
  - Ubah password
  - Logout

---

## [Unreleased]

### 🚀 Planned Features

- Reminder deadline tugas
- Grafik kehadiran per mata kuliah
- Export riwayat absensi ke PDF
- Edit file tugas yang sudah diupload
- Kalender akademik
- Biometric login
- Chat dengan dosen
- Multi-bahasa (Indonesia/English)
- Achievement badges

### 🔧 Known Issues

- Belum ada validasi ukuran file saat upload tugas
- Belum ada compress image untuk foto profil
- Belum ada offline mode/cache

---

## Version History

| Version | Release Date | Highlights                         |
| ------- | ------------ | ---------------------------------- |
| 1.2.0   | 2026-06-01   | Pull-to-refresh, Push notification |
| 1.1.0   | 2026-04-15   | Dark mode, Profile menu fixes      |
| 1.0.0   | 2026-03-01   | Initial release with core features |

---

**© 2026 Aplikasi Absensi Kampus. All rights reserved.**
