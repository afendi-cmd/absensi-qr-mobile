# Dokumentasi Fitur Per Role - Sistem Absensi

## Daftar Isi

1. [Overview Sistem](#overview-sistem)
2. [Role ADMIN](#role-admin)
3. [Role DOSEN](#role-dosen)
4. [Role MAHASISWA](#role-mahasiswa)
5. [Fitur Bersama (Semua Role)](#fitur-bersama-semua-role)
6. [Checklist Fitur](#checklist-fitur)

---

## Overview Sistem

Sistem Absensi ini memiliki 3 role utama:

- **Admin**: Mengelola seluruh sistem (user, mata kuliah, data)
- **Dosen**: Mengelola perkuliahan, absensi, tugas, dan materi
- **Mahasiswa**: Melakukan absensi, mengumpulkan tugas, dan mengakses materi

### Teknologi

- **Backend**: Laravel 11 dengan Sanctum Authentication
- **Database**: MySQL/PostgreSQL
- **Push Notification**: Firebase Cloud Messaging (FCM)
- **Export**: Excel/CSV

---

## Role ADMIN

### ✅ Fitur yang Sudah Ada

#### 1. **Dashboard & Statistik**

- ✅ Melihat statistik total mata kuliah
- ✅ Melihat statistik total dosen
- ✅ Melihat statistik total mahasiswa
- ✅ Melihat total absensi hari ini
- ✅ Grafik absensi 7 hari terakhir
- ✅ Grafik absensi per mata kuliah (Top 5)
- ✅ Persentase kehadiran per mata kuliah
- ✅ Statistik user per role (pie chart)
- ✅ Log aktivitas terbaru (recent activities)

**Endpoints:**

```
GET /api/admin/dashboard/stats
GET /api/admin/dashboard/advanced-stats
```

#### 2. **Manajemen User**

- ✅ Melihat daftar semua user (dengan filter role)
- ✅ Menambah user baru (admin, dosen, mahasiswa)
- ✅ Melihat detail user
- ✅ Mengubah data user
- ✅ Menghapus user
- ✅ Reset password user

**Endpoints:**

```
GET    /api/users                      # List users (filter by role)
POST   /api/users                      # Create user
GET    /api/users/{id}                 # Show user detail
PUT    /api/users/{id}                 # Update user
DELETE /api/users/{id}                 # Delete user
POST   /api/users/{id}/reset-password  # Reset password
```

**Validasi:**

- Nama: required, max 100 karakter
- Email: required, unique, valid email
- Password: minimum 6 karakter
- Role: admin, dosen, atau mahasiswa

#### 3. **Manajemen Mata Kuliah**

- ✅ Melihat daftar semua mata kuliah
- ✅ Menambah mata kuliah baru
- ✅ Melihat detail mata kuliah
- ✅ Mengubah data mata kuliah
- ✅ Menghapus mata kuliah
- ✅ Melihat peserta mata kuliah

**Endpoints:**

```
GET    /api/mata-kuliah               # List mata kuliah
POST   /api/mata-kuliah               # Create mata kuliah
GET    /api/mata-kuliah/{id}          # Show detail
PUT    /api/mata-kuliah/{id}          # Update mata kuliah
DELETE /api/mata-kuliah/{id}          # Delete mata kuliah
GET    /api/mata-kuliah/{id}/peserta  # List peserta
```

#### 4. **Manajemen Peserta Mata Kuliah**

- ✅ Menambah mahasiswa ke mata kuliah
- ✅ Menghapus mahasiswa dari mata kuliah
- ✅ Melihat daftar peserta per mata kuliah
- ✅ Melihat absensi per mata kuliah

**Endpoints:**

```
POST   /api/peserta-mk                    # Add peserta
DELETE /api/peserta-mk/{id}               # Remove peserta
GET    /api/mata-kuliah/{id}/peserta      # List peserta
GET    /api/mata-kuliah/{id}/absensi      # Absensi per MK
```

#### 5. **Manajemen Absensi**

- ✅ Melihat semua data absensi (all users, all mata kuliah)
- ✅ Filter absensi by mata kuliah
- ✅ Filter absensi by mahasiswa
- ✅ Filter absensi by tanggal (range)

**Endpoints:**

```
GET /api/absensi/all?mata_kuliah_id=&mahasiswa_id=&tanggal_mulai=&tanggal_selesai=
```

#### 6. **Manajemen Pengumuman**

- ✅ Melihat semua pengumuman (termasuk draft)
- ✅ Membuat pengumuman baru
- ✅ Mengubah pengumuman
- ✅ Menghapus pengumuman
- ✅ Toggle status aktif/tidak aktif pengumuman
- ✅ Target pengumuman (all, dosen, mahasiswa)

**Endpoints:**

```
GET    /api/pengumuman/admin          # Admin view (all)
POST   /api/pengumuman                # Create
PUT    /api/pengumuman/{id}           # Update
DELETE /api/pengumuman/{id}           # Delete
POST   /api/pengumuman/{id}/toggle    # Toggle active status
```

#### 7. **Notifikasi Push**

- ✅ Kirim notifikasi ke user tertentu (FCM)
- ✅ Kirim notifikasi berdasarkan role
- ✅ Kirim notifikasi ke semua user
- ✅ Melihat history notifikasi yang dikirim

**Endpoints:**

```
POST /api/notifications/send          # Send notification
GET  /api/notifications/history       # View history
```

#### 8. **Export Data**

- ✅ Export data absensi (Excel/CSV)
- ✅ Export rekap mahasiswa per mata kuliah
- ✅ Export daftar mahasiswa
- ✅ Export daftar dosen
- ✅ Export daftar mata kuliah

**Endpoints:**

```
GET /api/export/absensi               # Export absensi
GET /api/export/rekap-mahasiswa       # Export rekap per MK
GET /api/export/mahasiswa             # Export list mahasiswa
GET /api/export/dosen                 # Export list dosen
GET /api/export/mata-kuliah           # Export list mata kuliah
```

### ❌ Fitur yang Harus Ditambahkan

#### 1. **Dashboard Enhancement**

- ❌ Filter dashboard by periode (bulan, semester, tahun)
- ❌ Grafik trend kehadiran semester
- ❌ Grafik perbandingan antar kelas
- ❌ Alert sistem untuk anomali (kehadiran rendah, dll)

#### 2. **Audit Log & System Monitoring**

- ❌ Log aktivitas admin (siapa melakukan apa dan kapan)
- ❌ Track perubahan data penting (edit user, edit nilai)
- ❌ Monitor login attempts (sukses/gagal)
- ❌ System health monitoring

#### 3. **Backup & Restore**

- ❌ Backup database manual/otomatis
- ❌ Restore data dari backup
- ❌ Export full system data

#### 4. **Laporan Lanjutan**

- ❌ Laporan kehadiran per semester
- ❌ Laporan kinerja dosen
- ❌ Laporan IPK vs kehadiran (korelasi)
- ❌ Scheduled report (email otomatis)

#### 5. **Manajemen Semester**

- ❌ Tambah/edit semester akademik
- ❌ Set semester aktif
- ❌ Arsip data per semester

#### 6. **Settings & Configuration**

- ❌ Set minimum kehadiran untuk lulus
- ❌ Set durasi default QR code
- ❌ Set radius geofencing untuk absensi
- ❌ Email/SMS notification settings

---

## Role DOSEN

### ✅ Fitur yang Sudah Ada

#### 1. **Dashboard & Statistik**

- ✅ Melihat total mata kuliah yang diajar
- ✅ Melihat total mahasiswa (dari semua MK yang diajar)
- ✅ Melihat total absensi hari ini
- ✅ Melihat total tugas yang dibuat

**Endpoints:**

```
GET /api/dosen/{id}/dashboard/stats
```

#### 2. **Mata Kuliah**

- ✅ Melihat daftar mata kuliah yang diajar
- ✅ Melihat detail mata kuliah
- ✅ Melihat daftar peserta mata kuliah
- ✅ Menambah peserta ke mata kuliah
- ✅ Menghapus peserta dari mata kuliah

**Endpoints:**

```
GET    /api/mata-kuliah/dosen/me          # MK yang diajar
POST   /api/peserta-mk                    # Add peserta
DELETE /api/peserta-mk/{id}               # Remove peserta
GET    /api/mata-kuliah/{id}/peserta      # List peserta
```

#### 3. **Generate QR Code Absensi**

- ✅ Generate QR code untuk absensi
- ✅ Set durasi validitas QR (1-60 menit)
- ✅ Melihat history QR sessions
- ✅ Filter QR sessions by mata kuliah
- ✅ Filter QR sessions by status (active/expired)
- ✅ Melihat detail QR session + daftar yang hadir
- ✅ Menutup QR session secara manual

**Endpoints:**

```
POST /api/generate-qr                 # Generate QR
GET  /api/qr-sessions                 # History
GET  /api/qr-sessions/{id}            # Detail + attendances
PUT  /api/qr-sessions/{id}/close      # Close manually
```

**Validasi Generate QR:**

- Mata kuliah ID: required, harus exist
- Duration: 1-60 menit
- QR code: unique, auto-generated

#### 4. **Rekap Absensi**

- ✅ Melihat rekap absensi dari MK yang diajar
- ✅ Filter absensi by mata kuliah
- ✅ Filter absensi by tanggal (range)
- ✅ Melihat detail absensi mahasiswa
- ✅ Melihat absensi per mata kuliah

**Endpoints:**

```
GET /api/rekap-absensi?mata_kuliah_id=&tanggal_mulai=&tanggal_selesai=
GET /api/mata-kuliah/{id}/absensi
```

#### 5. **Manajemen Tugas**

- ✅ Membuat tugas baru
- ✅ Melihat daftar tugas yang dibuat
- ✅ Melihat detail tugas
- ✅ Mengubah tugas
- ✅ Menghapus tugas
- ✅ Melihat daftar pengumpulan tugas
- ✅ Memberi nilai pada pengumpulan tugas

**Endpoints:**

```
POST   /api/tugas                        # Create tugas
GET    /api/tugas                        # List tugas
GET    /api/tugas/{id}                   # Detail tugas
PUT    /api/tugas/{id}                   # Update tugas
DELETE /api/tugas/{id}                   # Delete tugas
GET    /api/tugas/{id}/pengumpulan       # List submissions
PUT    /api/pengumpulan-tugas/{id}/nilai # Give score
```

**Field Tugas:**

- Judul tugas
- Deskripsi
- Mata kuliah ID
- Deadline
- File lampiran (optional)

#### 6. **Manajemen Materi**

- ✅ Upload materi perkuliahan
- ✅ Melihat daftar materi yang diupload
- ✅ Melihat detail materi
- ✅ Menghapus materi

**Endpoints:**

```
POST   /api/materi           # Upload materi
GET    /api/materi           # List materi
GET    /api/materi/{id}      # Detail materi
DELETE /api/materi/{id}      # Delete materi
```

**Field Materi:**

- Judul materi
- Deskripsi
- Mata kuliah ID
- File materi (PDF, PPT, DOC, dll)
- Pertemuan ke-

### ❌ Fitur yang Harus Ditambahkan

#### 1. **Dashboard Enhancement**

- ❌ Grafik kehadiran per mata kuliah
- ❌ Alert mahasiswa dengan kehadiran rendah
- ❌ Trend pengumpulan tugas
- ❌ Jadwal mengajar hari ini/minggu ini

#### 2. **Absensi Enhancement**

- ❌ Input absensi manual (untuk mahasiswa yang izin/sakit)
- ❌ Edit status absensi (hadir → izin/sakit)
- ❌ Fitur izin/sakit dengan upload surat
- ❌ Rekap kehadiran per mahasiswa (PDF)
- ❌ Set minimum kehadiran per mata kuliah

#### 3. **Tugas Enhancement**

- ❌ Kategori tugas (Individu/Kelompok)
- ❌ Rubrik penilaian
- ❌ Feedback/komentar untuk mahasiswa
- ❌ Download semua pengumpulan (ZIP)
- ❌ Remind mahasiswa yang belum mengumpulkan

#### 4. **Jadwal & Kalender**

- ❌ Input jadwal perkuliahan
- ❌ View kalender akademik
- ❌ Set jadwal konsultasi
- ❌ Booking sistem untuk konsultasi

#### 5. **Forum/Discussion**

- ❌ Forum diskusi per mata kuliah
- ❌ Q&A section
- ❌ Announcement khusus per MK

#### 6. **Nilai & Penilaian**

- ❌ Input nilai UTS/UAS
- ❌ Hitung nilai akhir (bobot: absensi, tugas, UTS, UAS)
- ❌ Export nilai per mata kuliah
- ❌ Grafik distribusi nilai

---

## Role MAHASISWA

### ✅ Fitur yang Sudah Ada

#### 1. **Dashboard & Statistik**

- ✅ Melihat total mata kuliah yang diambil
- ✅ Melihat persentase kehadiran
- ✅ Melihat total tugas selesai
- ✅ Melihat total tugas pending

**Endpoints:**

```
GET /api/mahasiswa/{id}/stats
```

#### 2. **Scan QR Absensi**

- ✅ Scan QR code untuk absensi
- ✅ Validasi QR code (valid/expired)
- ✅ Validasi terdaftar di mata kuliah
- ✅ Validasi belum absen (prevent double scan)
- ✅ Capture lokasi (latitude, longitude)
- ✅ Timestamp otomatis

**Endpoints:**

```
POST /api/scan-qr
```

**Request Body:**

```json
{
    "kode_qr": "string",
    "latitude": "float (optional)",
    "longitude": "float (optional)"
}
```

**Validasi:**

- QR code harus valid
- QR code belum expired
- Mahasiswa terdaftar di mata kuliah
- Belum absen pada sesi yang sama

#### 3. **Riwayat Absensi**

- ✅ Melihat riwayat absensi pribadi
- ✅ Filter absensi by mata kuliah
- ✅ Filter absensi by tanggal (range)
- ✅ Melihat status absensi (hadir/izin/sakit)

**Endpoints:**

```
GET /api/riwayat-absensi?mata_kuliah_id=&tanggal_mulai=&tanggal_selesai=
```

#### 4. **Mata Kuliah**

- ✅ Melihat daftar mata kuliah yang diambil
- ✅ Melihat detail mata kuliah
- ✅ Melihat informasi dosen pengampu

**Endpoints:**

```
GET /api/mata-kuliah/mahasiswa/me
```

#### 5. **Tugas**

- ✅ Melihat daftar tugas dari semua mata kuliah
- ✅ Melihat detail tugas
- ✅ Upload jawaban tugas
- ✅ Melihat status pengumpulan (sudah/belum)
- ✅ Melihat nilai tugas yang sudah dinilai
- ✅ Melihat history pengumpulan tugas pribadi

**Endpoints:**

```
GET  /api/tugas/mahasiswa/me              # List tugas
POST /api/upload-tugas                    # Submit tugas
GET  /api/pengumpulan-tugas/me            # My submissions
```

**Field Upload Tugas:**

- Tugas ID
- File jawaban (required)
- Keterangan (optional)

#### 6. **Materi Perkuliahan**

- ✅ Melihat daftar materi dari mata kuliah yang diambil
- ✅ Download materi
- ✅ Filter materi by mata kuliah

**Endpoints:**

```
GET /api/materi/mahasiswa/me
```

### ❌ Fitur yang Harus Ditambahkan

#### 1. **Dashboard Enhancement**

- ❌ Kalender absensi (visual calendar)
- ❌ Grafik kehadiran per mata kuliah
- ❌ Alert tugas yang akan deadline
- ❌ Progress nilai (jika sudah ada sistem nilai)

#### 2. **Absensi Enhancement**

- ❌ Ajukan izin/sakit (upload surat)
- ❌ View persentase kehadiran per mata kuliah
- ❌ Alert kehadiran rendah (dibawah minimum)
- ❌ Download rekap absensi pribadi (PDF)

#### 3. **Tugas Enhancement**

- ❌ Edit pengumpulan tugas (sebelum deadline)
- ❌ Hapus pengumpulan tugas
- ❌ View feedback dari dosen
- ❌ Sort tugas by deadline
- ❌ Filter tugas (sudah/belum dikumpulkan)
- ❌ Notification reminder deadline

#### 4. **Jadwal & Kalender**

- ❌ View jadwal perkuliahan
- ❌ View jadwal UTS/UAS
- ❌ Booking konsultasi dengan dosen
- ❌ Reminder jadwal hari ini

#### 5. **Nilai & Transkrip**

- ❌ View nilai per mata kuliah
- ❌ View transkrip nilai
- ❌ Download transkrip (PDF)
- ❌ View IPK dan IPS

#### 6. **Profil Enhancement**

- ❌ Upload foto profil
- ❌ Edit biodata lengkap
- ❌ View KRS (Kartu Rencana Studi)

---

## Fitur Bersama (Semua Role)

### ✅ Fitur yang Sudah Ada

#### 1. **Autentikasi**

- ✅ Login (email + password)
- ✅ Logout
- ✅ Get user info (profile)
- ✅ Token-based authentication (Sanctum)

**Endpoints:**

```
POST /api/login               # Login
POST /api/logout              # Logout
GET  /api/user                # Get authenticated user
```

#### 2. **Profile Management**

- ✅ Update profile (nama, email, no_hp, alamat)
- ✅ Change password
- ✅ Validasi password lama sebelum ganti password

**Endpoints:**

```
PUT /api/profile/update
```

**Field Update Profile:**

- nama (optional)
- email (optional, unique)
- no_hp (optional)
- alamat (optional)
- current_password (required if changing password)
- new_password (optional, min 6 char)
- new_password_confirmation (required if new_password)

#### 3. **Push Notification (FCM)**

- ✅ Save FCM token
- ✅ Update FCM token
- ✅ Device-specific notification

**Endpoints:**

```
POST /api/user/fcm-token
```

#### 4. **Pengumuman**

- ✅ Melihat daftar pengumuman aktif
- ✅ Melihat detail pengumuman
- ✅ Mark pengumuman sebagai sudah dibaca
- ✅ Mark all pengumuman sebagai sudah dibaca
- ✅ Melihat jumlah pengumuman yang belum dibaca
- ✅ Filter pengumuman by target (all/role-specific)

**Endpoints:**

```
GET  /api/pengumuman                     # List active announcements
GET  /api/pengumuman/{id}                # Detail
POST /api/pengumuman/{id}/mark-as-read   # Mark as read
POST /api/pengumuman/mark-all-as-read    # Mark all as read
GET  /api/pengumuman/unread/count        # Unread count
```

### ❌ Fitur yang Harus Ditambahkan

#### 1. **Autentikasi Enhancement**

- ❌ Register (self-registration untuk mahasiswa)
- ❌ Forgot password (reset via email)
- ❌ Email verification
- ❌ Two-factor authentication (2FA)
- ❌ Remember me (long-lived token)

#### 2. **Profile Enhancement**

- ❌ Upload foto profil
- ❌ Crop foto profil
- ❌ View login history
- ❌ Manage active sessions
- ❌ Logout from all devices

#### 3. **Notification Center**

- ❌ In-app notification center
- ❌ Notification history
- ❌ Mark notification as read
- ❌ Clear all notifications
- ❌ Notification preferences (mute/unmute)

#### 4. **Search & Filter Global**

- ❌ Global search (user, mata kuliah, tugas)
- ❌ Advanced filter

#### 5. **Help & Support**

- ❌ FAQ section
- ❌ Help documentation
- ❌ Contact support/admin
- ❌ Report bug/issue

---

## Checklist Fitur

### 🔥 Priority: HIGH (Critical Features)

#### Admin

- [x] User management (CRUD)
- [x] Mata kuliah management (CRUD)
- [x] Dashboard statistics
- [x] Export data
- [ ] Audit log
- [ ] System settings/configuration

#### Dosen

- [x] Generate QR code
- [x] Rekap absensi
- [x] Tugas management (CRUD)
- [x] Upload materi
- [ ] Input absensi manual
- [ ] Nilai & penilaian

#### Mahasiswa

- [x] Scan QR absensi
- [x] Riwayat absensi
- [x] Upload tugas
- [x] View materi
- [ ] Ajukan izin/sakit
- [ ] View nilai

#### Shared

- [x] Login/Logout
- [x] Profile update
- [x] Pengumuman
- [x] Push notification
- [ ] Forgot password
- [ ] Notification center

---

### 🎯 Priority: MEDIUM (Important but Not Urgent)

#### Admin

- [ ] Dashboard charts enhancement
- [ ] Laporan lanjutan
- [ ] Semester management
- [ ] Backup & restore

#### Dosen

- [ ] Dashboard charts
- [ ] Alert kehadiran rendah
- [ ] Download semua tugas
- [ ] Rubrik penilaian

#### Mahasiswa

- [ ] Kalender absensi
- [ ] Alert deadline tugas
- [ ] Edit pengumpulan tugas
- [ ] View feedback dosen

#### Shared

- [ ] Advanced search
- [ ] Upload foto profil
- [ ] Notification preferences

---

### 💡 Priority: LOW (Nice to Have)

#### Admin

- [ ] Scheduled reports
- [ ] System health monitoring
- [ ] IPK vs kehadiran analysis

#### Dosen

- [ ] Forum diskusi
- [ ] Booking konsultasi
- [ ] Kalender akademik

#### Mahasiswa

- [ ] Transkrip nilai
- [ ] View IPK/IPS
- [ ] KRS online

#### Shared

- [ ] 2FA authentication
- [ ] Dark mode
- [ ] Multi-language support
- [ ] FAQ section

---

## Summary

### Total Fitur Terealisasi

- **Admin**: 60% (Core features sudah ada, perlu enhancement)
- **Dosen**: 70% (Fitur utama lengkap, perlu tambahan minor)
- **Mahasiswa**: 65% (Fitur core sudah ada, perlu enhancement)
- **Shared**: 50% (Basic features ada, perlu security enhancement)

### Fitur Prioritas untuk Development Selanjutnya:

1. ⚠️ **Forgot Password** - Security critical
2. ⚠️ **Input Absensi Manual** - Dosen need this
3. ⚠️ **Izin/Sakit Management** - Mahasiswa need this
4. ⚠️ **Audit Log** - Admin monitoring
5. ⚠️ **Nilai & Penilaian** - Complete grading system
6. 📊 **Dashboard Enhancement** - Better data visualization
7. 🔔 **Notification Center** - Better UX for notifications
8. 📅 **Jadwal & Kalender** - Schedule management

---

**Dokumentasi dibuat pada:** 23 Juni 2026
**Versi Sistem:** 1.0
**Tech Stack:** Laravel 11 + Sanctum + FCM
