# Dokumentasi Fitur Flutter - JAYQ App

## Daftar Isi

1. [Overview Aplikasi](#overview-aplikasi)
2. [Arsitektur & Tech Stack](#arsitektur--tech-stack)
3. [Fitur Admin](#fitur-admin)
4. [Fitur Dosen](#fitur-dosen)
5. [Fitur Mahasiswa](#fitur-mahasiswa)
6. [Fitur Shared](#fitur-shared)
7. [Checklist Implementasi](#checklist-implementasi)

---

## Overview Aplikasi

**Nama Aplikasi:** JAYQ - Modern Attendance App with QR Code  
**Versi:** 1.0.0+1  
**Platform:** Android & iOS  
**Backend API:** Laravel 11 REST API

### Role User

- 🔴 **Admin**: Full access untuk manajemen sistem
- 🔵 **Dosen**: Manajemen perkuliahan, QR absensi, tugas, materi
- 🟢 **Mahasiswa**: Scan QR, tugas, materi, riwayat absensi

---

## Arsitektur & Tech Stack

### State Management

- **Provider**: State management utama
- Pattern: MVVM (Model-View-ViewModel)

### Network Layer

- **HTTP Client**: Dio (with interceptors)
- **API Service**: RESTful API dengan token authentication
- **Base URL**: Configurable via AppConstants

### Storage

- **Shared Preferences**: User preferences, simple data
- **Flutter Secure Storage**: Token, sensitive data
- **Local Storage**: Cache & offline data

### UI/UX Libraries

```yaml
google_fonts: ^6.1.0 # Typography
flutter_spinkit: ^5.2.0 # Loading indicators
shimmer: ^3.0.0 # Skeleton loading
cached_network_image: ^3.3.1 # Image caching
fl_chart: ^0.66.0 # Charts & graphs
timeago: ^3.7.0 # Relative time formatting
```

### Functional Libraries

```yaml
mobile_scanner: ^3.5.5        # QR Code scanner
qr_flutter: ^4.1.0            # QR Code generator
image_picker: ^1.0.7          # Pick images
file_picker: ^8.0.0+1         # Pick files
firebase_messaging: ^15.1.5   # Push notifications
flutter_local_notifications   # Local notifications
url_launcher: ^6.2.5          # Open URLs/files
```

### Project Structure

```
lib/
├── core/
│   ├── constants/        # App constants, colors
│   ├── theme/            # Theme configuration
│   └── utils/            # Helper utilities
├── data/
│   ├── models/           # Data models
│   └── services/         # API services
├── providers/            # State management
├── routes/               # App routing
├── screens/              # UI screens
│   ├── admin/            # Admin screens
│   ├── dosen/            # Dosen screens
│   ├── mahasiswa/        # Mahasiswa screens
│   ├── auth/             # Authentication screens
│   └── shared/           # Shared screens
└── widgets/              # Reusable widgets

```

---

## Fitur Admin

### ✅ Screens yang Sudah Ada

#### 1. **Dashboard**

📁 `admin_dashboard_screen.dart`

**Fitur:**

- ✅ Overview cards (total MK, dosen, mahasiswa, absensi hari ini)
- ✅ Quick access menu (grid layout)
- ✅ Navigation ke semua fitur admin
- ✅ Real-time statistics

**Service:** `dashboard_service.dart`  
**Endpoint:** `GET /api/admin/dashboard/stats`

#### 2. **Advanced Statistics**

📁 `advanced_statistics_screen.dart`

**Fitur:**

- ✅ Grafik absensi 7 hari terakhir (Line chart)
- ✅ Grafik absensi per mata kuliah (Bar chart)
- ✅ Distribusi user per role (Pie chart)
- ✅ Persentase kehadiran per mata kuliah (Table)
- ✅ Log aktivitas terbaru
- ✅ Export data to Excel

**Service:** `dashboard_service.dart`  
**Chart Library:** `fl_chart`  
**Endpoint:** `GET /api/admin/dashboard/advanced-stats`

#### 3. **Manajemen Dosen**

📁 `manage_dosen_screen.dart`, `add_dosen_screen.dart`

**Fitur:**

- ✅ List semua dosen (with search)
- ✅ Tambah dosen baru
- ✅ Edit data dosen
- ✅ Hapus dosen (with confirmation)
- ✅ Reset password dosen
- ✅ View detail dosen

**Service:** `user_service.dart`  
**Endpoints:**

- `GET /api/users?role=dosen`
- `POST /api/users`
- `PUT /api/users/{id}`
- `DELETE /api/users/{id}`
- `POST /api/users/{id}/reset-password`

**Form Fields:**

- Nama lengkap
- Email (unique)
- Password (min 6 char)
- Role: dosen (auto-set)

#### 4. **Manajemen Mahasiswa**

📁 `manage_mahasiswa_screen.dart`, `add_mahasiswa_screen.dart`

**Fitur:**

- ✅ List semua mahasiswa (with search & filter)
- ✅ Tambah mahasiswa baru
- ✅ Edit data mahasiswa
- ✅ Hapus mahasiswa (with confirmation)
- ✅ Reset password mahasiswa
- ✅ View detail mahasiswa
- ✅ View riwayat absensi mahasiswa

**Service:** `user_service.dart`  
**Endpoints:** Same as Dosen with `?role=mahasiswa`

#### 5. **Manajemen Mata Kuliah**

📁 `manage_matakuliah_screen.dart`

**Fitur:**

- ✅ List semua mata kuliah
- ✅ Tambah mata kuliah baru
- ✅ Edit mata kuliah
- ✅ Hapus mata kuliah
- ✅ Assign dosen ke mata kuliah
- ✅ View detail mata kuliah
- ✅ View peserta mata kuliah

**Service:** `matakuliah_service.dart`  
**Endpoints:**

- `GET /api/mata-kuliah`
- `POST /api/mata-kuliah`
- `PUT /api/mata-kuliah/{id}`
- `DELETE /api/mata-kuliah/{id}`

**Form Fields:**

- Kode Mata Kuliah (unique)
- Nama Mata Kuliah
- SKS
- Semester
- Dosen Pengampu (dropdown)
- Keterangan

#### 6. **Manajemen Peserta Mata Kuliah**

📁 `manage_peserta_screen.dart`

**Fitur:**

- ✅ View peserta per mata kuliah
- ✅ Tambah mahasiswa ke mata kuliah (bulk/single)
- ✅ Hapus mahasiswa dari mata kuliah
- ✅ Search mahasiswa
- ✅ Filter by status (aktif/tidak aktif)

**Service:** `peserta_mk_service.dart`  
**Endpoints:**

- `GET /api/mata-kuliah/{id}/peserta`
- `POST /api/peserta-mk`
- `DELETE /api/peserta-mk/{id}`

#### 7. **History Absensi**

📁 `admin_history_screen.dart`, `attendance_detail_screen.dart`

**Fitur:**

- ✅ View semua absensi (all users, all MK)
- ✅ Filter by mata kuliah
- ✅ Filter by mahasiswa
- ✅ Filter by tanggal (date range picker)
- ✅ Search mahasiswa/mata kuliah
- ✅ View detail absensi (lokasi, waktu)
- ✅ Export to Excel

**Service:** `absensi_service.dart`  
**Endpoint:** `GET /api/absensi/all`

#### 8. **Manajemen Pengumuman**

📁 `manage_pengumuman_screen.dart`, `broadcast_pengumuman_screen.dart`

**Fitur:**

- ✅ List semua pengumuman (draft & published)
- ✅ Buat pengumuman baru
- ✅ Edit pengumuman
- ✅ Hapus pengumuman
- ✅ Toggle status (aktif/tidak aktif)
- ✅ Set target audience (all, dosen, mahasiswa)
- ✅ Upload gambar pengumuman
- ✅ Preview pengumuman

**Service:** `pengumuman_service.dart`  
**Endpoints:**

- `GET /api/pengumuman/admin`
- `POST /api/pengumuman`
- `PUT /api/pengumuman/{id}`
- `DELETE /api/pengumuman/{id}`
- `POST /api/pengumuman/{id}/toggle`

**Form Fields:**

- Judul pengumuman
- Konten (rich text)
- Target (all/dosen/mahasiswa)
- Gambar (optional)
- Status (aktif/tidak aktif)

#### 9. **Notification Center**

📁 `notification_center_screen.dart`

**Fitur:**

- ✅ Kirim notifikasi push ke user tertentu
- ✅ Kirim notifikasi by role
- ✅ Kirim notifikasi broadcast (all)
- ✅ View history notifikasi
- ✅ Template notifikasi
- ✅ Schedule notifikasi (future)

**Service:** `notification_service.dart`  
**Firebase:** FCM (Firebase Cloud Messaging)  
**Endpoints:**

- `POST /api/notifications/send`
- `GET /api/notifications/history`

#### 10. **Export Data**

📁 `export_data_screen.dart`

**Fitur:**

- ✅ Export absensi (Excel/CSV)
- ✅ Export rekap mahasiswa per MK
- ✅ Export list mahasiswa
- ✅ Export list dosen
- ✅ Export list mata kuliah
- ✅ Filter by date range
- ✅ Auto download file
- ✅ Open file after download

**Service:** `export_service.dart`  
**Package:** `open_file`, `path_provider`  
**Endpoints:**

- `GET /api/export/absensi`
- `GET /api/export/rekap-mahasiswa`
- `GET /api/export/mahasiswa`
- `GET /api/export/dosen`
- `GET /api/export/mata-kuliah`

#### 11. **Profile Admin**

📁 `admin_profile_screen.dart`, `edit_profile_screen.dart`

**Fitur:**

- ✅ View profile info
- ✅ Edit profile (nama, email, no_hp, alamat)
- ✅ Change password
- ✅ Logout

**Service:** `profile_service.dart`, `auth_service.dart`

#### 12. **Schedule**

📁 `admin_schedule_screen.dart`

**Fitur:**

- ✅ View jadwal perkuliahan
- ✅ Calendar view
- ✅ Filter by hari/minggu/bulan
- ✅ View detail jadwal

**Service:** `schedule_service.dart`

### ❌ Fitur yang Harus Ditambahkan

1. **Audit Log Screen**
   - ❌ Log aktivitas admin (who did what)
   - ❌ Filter by user, action, date
   - ❌ Export audit log

2. **System Settings Screen**
   - ❌ Set minimum kehadiran
   - ❌ Set default QR duration
   - ❌ Set geofencing radius
   - ❌ Email/SMS notification settings
   - ❌ Backup & restore database

3. **Semester Management**
   - ❌ CRUD semester akademik
   - ❌ Set active semester
   - ❌ Archive old data

4. **Advanced Analytics**
   - ❌ Trend analysis (semester comparison)
   - ❌ Prediction (kehadiran trend)
   - ❌ Correlation (IPK vs kehadiran)

---

## Fitur Dosen

### ✅ Screens yang Sudah Ada

#### 1. **Dashboard Dosen**

📁 `dosen_dashboard_screen.dart`

**Fitur:**

- ✅ Statistics cards (MK diajar, total mahasiswa, absensi hari ini, tugas)
- ✅ Quick actions (Generate QR, Create Tugas, Upload Materi)
- ✅ Jadwal hari ini
- ✅ Recent activities

**Provider:** `dashboard_dosen_provider.dart`  
**Service:** `dashboard_dosen_service.dart`  
**Endpoint:** `GET /api/dosen/{id}/dashboard/stats`

#### 2. **Mata Kuliah List & Detail**

📁 `mata_kuliah_list_screen.dart`, `mata_kuliah_detail_screen.dart`

**Fitur:**

- ✅ List mata kuliah yang diajar
- ✅ View detail mata kuliah
- ✅ View peserta mata kuliah
- ✅ Tambah/hapus peserta
- ✅ View statistik per MK (kehadiran, tugas)

**Service:** `matakuliah_service.dart`, `peserta_mk_service.dart`  
**Provider:** `peserta_mk_provider.dart`

**Endpoint:** `GET /api/mata-kuliah/dosen/me`

#### 3. **Generate QR Code**

📁 `generate_qr_screen.dart`

**Fitur:**

- ✅ Pilih mata kuliah
- ✅ Set durasi QR (1-60 menit)
- ✅ Generate QR code
- ✅ Display QR code (visual)
- ✅ Show countdown timer
- ✅ Show real-time attendance count
- ✅ Manual close QR session
- ✅ History QR sessions

**Provider:** `qr_provider.dart`  
**Service:** `qr_service.dart`  
**Package:** `qr_flutter`, `mobile_scanner`  
**Endpoints:**

- `POST /api/generate-qr`
- `GET /api/qr-sessions`
- `GET /api/qr-sessions/{id}`
- `PUT /api/qr-sessions/{id}/close`

**UI Components:**

- QR Code widget (enlarged, clear)
- Countdown timer (animated)
- Live attendance list
- Close button

#### 4. **Rekap Kehadiran**

📁 `rekap_kehadiran_screen.dart`

**Fitur:**

- ✅ View rekap absensi per mata kuliah
- ✅ Filter by mata kuliah
- ✅ Filter by date range
- ✅ View detail per mahasiswa
- ✅ Statistik kehadiran (grafik)
- ✅ Export to Excel

**Service:** `absensi_service.dart`  
**Endpoint:** `GET /api/rekap-absensi`

**Display:**

- Table view (mahasiswa x pertemuan)
- Persentase kehadiran per mahasiswa
- Status: Hadir (H), Izin (I), Sakit (S), Alpa (A)

#### 5. **Manajemen Tugas**

📁 `tugas_list_screen.dart`, `create_tugas_screen.dart`, `tugas_detail_dosen_screen.dart`

**Fitur:**

- ✅ List tugas yang dibuat
- ✅ Buat tugas baru
- ✅ Edit tugas
- ✅ Hapus tugas
- ✅ View pengumpulan tugas
- ✅ Beri nilai tugas
- ✅ Filter by mata kuliah
- ✅ Upload file lampiran tugas
- ✅ View statistik pengumpulan (sudah/belum)

**Provider:** `tugas_provider.dart`  
**Service:** `tugas_service.dart`  
**Package:** `file_picker`  
**Endpoints:**

- `POST /api/tugas`
- `GET /api/tugas`
- `GET /api/tugas/{id}`
- `PUT /api/tugas/{id}`
- `DELETE /api/tugas/{id}`
- `GET /api/tugas/{id}/pengumpulan`
- `PUT /api/pengumpulan-tugas/{id}/nilai`

**Form Fields:**

- Judul tugas
- Deskripsi (rich text)
- Mata kuliah
- Deadline (date + time picker)
- File lampiran (PDF, DOC, etc)

**Penilaian:**

- View file jawaban mahasiswa
- Input nilai (0-100)
- Keterangan/feedback

#### 6. **Manajemen Materi**

📁 `materi_list_screen.dart`, `create_materi_screen.dart`

**Fitur:**

- ✅ List materi yang diupload
- ✅ Upload materi baru
- ✅ Edit materi
- ✅ Hapus materi
- ✅ Filter by mata kuliah
- ✅ Upload file (PDF, PPT, DOC, etc)
- ✅ View preview (if supported)

**Provider:** `materi_provider.dart`  
**Service:** `materi_service.dart`  
**Package:** `file_picker`, `open_file`  
**Endpoints:**

- `POST /api/materi`
- `GET /api/materi`
- `GET /api/materi/{id}`
- `DELETE /api/materi/{id}`

**Form Fields:**

- Judul materi
- Deskripsi
- Mata kuliah
- Pertemuan ke-
- File materi (required)

#### 7. **Pengumuman Dosen**

📁 `pengumuman_dosen_screen.dart`

**Fitur:**

- ✅ View pengumuman (all + untuk dosen)
- ✅ Mark as read
- ✅ Filter by status (read/unread)
- ✅ View detail pengumuman

**Service:** `pengumuman_service.dart`

#### 8. **Profile Dosen**

📁 `profile_screen.dart` (dosen)

**Fitur:**

- ✅ View profile
- ✅ Edit profile
- ✅ Change password
- ✅ Logout
- ✅ View mata kuliah yang diajar

**Service:** `profile_service.dart`

### ❌ Fitur yang Harus Ditambahkan

1. **Input Absensi Manual**
   - ❌ Input absensi untuk mahasiswa yang izin/sakit
   - ❌ Upload surat izin/sakit
   - ❌ Edit status absensi

2. **Dashboard Enhancement**
   - ❌ Grafik trend kehadiran per MK
   - ❌ Alert mahasiswa kehadiran rendah
   - ❌ Calendar view jadwal

3. **Tugas Enhancement**
   - ❌ Rubrik penilaian
   - ❌ Feedback detail per tugas
   - ❌ Download semua pengumpulan (ZIP)
   - ❌ Remind mahasiswa belum mengumpulkan

4. **Nilai & Penilaian Akhir**
   - ❌ Input nilai UTS/UAS
   - ❌ Hitung nilai akhir (bobot)
   - ❌ Export nilai per MK

5. **Konsultasi & Jadwal**
   - ❌ Set jadwal konsultasi
   - ❌ Booking system
   - ❌ View calendar

---

## Fitur Mahasiswa

### ✅ Screens yang Sudah Ada

#### 1. **Dashboard Mahasiswa**

📁 `mahasiswa_dashboard_screen.dart`

**Fitur:**

- ✅ Statistics cards (MK diambil, persentase kehadiran, tugas selesai, tugas pending)
- ✅ Quick access: Scan QR, View Tugas, View Materi
- ✅ Jadwal hari ini
- ✅ Pengumuman terbaru

**Service:** `dashboard_service.dart`  
**Endpoint:** `GET /api/mahasiswa/{id}/stats`

#### 2. **Scan QR Code**

📁 `qr_scanner_screen.dart`

**Fitur:**

- ✅ Camera QR scanner
- ✅ Auto-detect QR code
- ✅ Validasi QR (expired/valid)
- ✅ Capture lokasi (GPS)
- ✅ Konfirmasi absensi
- ✅ Success/error feedback
- ✅ Flashlight toggle

**Package:** `mobile_scanner`, `geolocator`  
**Service:** `absensi_service.dart`  
**Endpoint:** `POST /api/scan-qr`

**Request Body:**

```dart
{
  "kode_qr": "string",
  "latitude": "double",
  "longitude": "double"
}
```

**UI/UX:**

- Full screen camera view
- QR frame overlay
- Flash toggle button
- Instructions text
- Haptic feedback on scan

#### 3. **History Absensi**

📁 `history_screen.dart`

**Fitur:**

- ✅ List riwayat absensi pribadi
- ✅ Filter by mata kuliah
- ✅ Filter by date range
- ✅ View detail absensi (lokasi, waktu)
- ✅ Status badge (Hadir/Izin/Sakit)
- ✅ Persentase kehadiran per MK

**Service:** `absensi_service.dart`  
**Endpoint:** `GET /api/riwayat-absensi`

**Display:**

- Timeline view
- Group by mata kuliah
- Visual progress bar (kehadiran)
- Date filter (bottom sheet)

#### 4. **Tugas & Materi**

📁 `tugas_materi_screen.dart`, `tugas_detail_screen.dart`, `materi_detail_screen.dart`

**Fitur:**

- ✅ Tab view: Tugas & Materi
- ✅ List tugas (all MK)
- ✅ View detail tugas
- ✅ Upload jawaban tugas
- ✅ View status (sudah/belum submit)
- ✅ View nilai (jika sudah dinilai)
- ✅ Download materi
- ✅ View/preview materi

**Service:** `tugas_service.dart`, `materi_service.dart`  
**Package:** `file_picker`, `open_file`  
**Endpoints:**

- `GET /api/tugas/mahasiswa/me`
- `POST /api/upload-tugas`
- `GET /api/pengumpulan-tugas/me`
- `GET /api/materi/mahasiswa/me`

**Tugas Form:**

- File jawaban (required)
- Keterangan (optional)

**UI Features:**

- Deadline countdown
- Sort by deadline
- Status badge (submitted/pending/graded)

#### 5. **Pengumuman**

📁 `pengumuman_screen.dart`, `pengumuman_detail_screen.dart`

**Fitur:**

- ✅ List pengumuman aktif
- ✅ Badge unread count
- ✅ View detail pengumuman
- ✅ Mark as read
- ✅ Mark all as read
- ✅ Filter by status (read/unread)

**Service:** `pengumuman_service.dart`  
**Endpoints:**

- `GET /api/pengumuman`
- `GET /api/pengumuman/{id}`
- `POST /api/pengumuman/{id}/mark-as-read`
- `POST /api/pengumuman/mark-all-as-read`
- `GET /api/pengumuman/unread/count`

#### 6. **Schedule (Jadwal Kuliah)**

📁 `schedule_screen.dart`

**Fitur:**

- ✅ View jadwal kuliah
- ✅ Calendar view / List view
- ✅ Filter by hari
- ✅ View detail jadwal (ruangan, dosen, waktu)

**Service:** `schedule_service.dart`

#### 7. **Profile Mahasiswa**

📁 `profile_screen.dart`, `edit_profile_screen.dart`, `change_password_screen.dart`

**Fitur:**

- ✅ View profile info
- ✅ Edit profile (nama, email, no_hp, alamat)
- ✅ Change password
- ✅ Logout
- ✅ View mata kuliah yang diambil

**Service:** `profile_service.dart`, `auth_service.dart`  
**Endpoints:**

- `PUT /api/profile/update`
- `POST /api/logout`

### ❌ Fitur yang Harus Ditambahkan

1. **Ajukan Izin/Sakit**
   - ❌ Form pengajuan izin/sakit
   - ❌ Upload surat (scan/foto)
   - ❌ View status persetujuan
   - ❌ History izin/sakit

2. **Dashboard Enhancement**
   - ❌ Kalender visual kehadiran
   - ❌ Grafik kehadiran per MK
   - ❌ Alert kehadiran rendah
   - ❌ Progress nilai (jika ada)

3. **Tugas Enhancement**
   - ❌ Edit pengumpulan (sebelum deadline)
   - ❌ Hapus pengumpulan
   - ❌ View feedback dari dosen
   - ❌ Notification reminder deadline

4. **Nilai & Transkrip**
   - ❌ View nilai per MK
   - ❌ View transkrip
   - ❌ Download transkrip PDF
   - ❌ View IPK & IPS

5. **Profile Enhancement**
   - ❌ Upload foto profil
   - ❌ Crop foto
   - ❌ View KRS

---

## Fitur Shared

### ✅ Fitur yang Sudah Ada

#### 1. **Authentication**

📁 `login_screen.dart`, `auth_check_screen.dart`

**Fitur:**

- ✅ Login (email + password)
- ✅ Remember me (persistent login)
- ✅ Auto redirect by role
- ✅ Token management
- ✅ Logout

**Provider:** `auth_provider.dart`  
**Service:** `auth_service.dart`, `storage_service.dart`  
**Storage:** `flutter_secure_storage` (token)

**Endpoints:**

- `POST /api/login`
- `POST /api/logout`
- `GET /api/user`

#### 2. **Splash Screen**

📁 `splash_screen.dart`

**Fitur:**

- ✅ App logo
- ✅ Loading indicator
- ✅ Auto navigate (check auth)
- ✅ Version info

**Package:** `flutter_native_splash`

#### 3. **Theme Management**

📁 `app_theme.dart`, `theme_provider.dart`

**Fitur:**

- ✅ Light theme
- ✅ Custom color palette
- ✅ Google Fonts integration
- ✅ Consistent styling

**Package:** `google_fonts`  
**Colors:** Defined in `app_colors.dart`

#### 4. **Push Notifications**

📁 Firebase integration

**Fitur:**

- ✅ Receive push notifications
- ✅ Local notifications
- ✅ Save FCM token
- ✅ Handle notification tap
- ✅ Background notifications

**Package:** `firebase_messaging`, `flutter_local_notifications`  
**Service:** `notification_service.dart`  
**Endpoint:** `POST /api/user/fcm-token`

**Notification Types:**

- Pengumuman baru
- Tugas baru
- QR code expired
- Tugas deadline reminder
- Nilai sudah keluar

#### 5. **Utilities & Helpers**

**Date Utils** (`date_utils.dart`)

- Format date/time
- Relative time (timeago)
- Date range picker

**Dialog Utils** (`dialog_utils.dart`)

- Loading dialog
- Success/error dialog
- Confirmation dialog
- Custom dialogs

**Navigation Utils** (`navigation_utils.dart`)

- Named routes
- Route guards
- Deep linking support

**Validator Utils** (`validator_utils.dart`)

- Email validator
- Password validator
- Phone number validator
- Required field validator

**String Utils** (`string_utils.dart`)

- Text formatting
- String truncate
- Capitalize

#### 6. **Reusable Widgets**

**Custom Button** (`custom_button.dart`)

- Primary button
- Secondary button
- Outline button
- Loading state
- Disabled state

**Custom TextField** (`custom_text_field.dart`)

- Email field
- Password field (with toggle)
- Search field
- Text area
- Validation support

**Stat Card** (`stat_card.dart`)

- Dashboard statistics card
- Icon + title + value
- Customizable colors

### ❌ Fitur yang Harus Ditambahkan

1. **Forgot Password**
   - ❌ Request reset password (email)
   - ❌ Verify OTP/token
   - ❌ Set new password

2. **Registration** (Optional untuk mahasiswa)
   - ❌ Self-registration form
   - ❌ Email verification

3. **Theme Enhancement**
   - ❌ Dark mode
   - ❌ Theme toggle
   - ❌ Custom theme color picker

4. **Offline Support**
   - ❌ Cache API responses
   - ❌ Offline mode indicator
   - ❌ Queue actions when offline
   - ❌ Sync when online

5. **In-App Notifications**
   - ❌ Notification center screen
   - ❌ Badge count on icon
   - ❌ Mark as read/unread
   - ❌ Clear all

6. **Search & Filter**
   - ❌ Global search
   - ❌ Advanced filter UI
   - ❌ Recent searches

7. **Profile Enhancement**
   - ❌ Upload foto profil
   - ❌ Image crop
   - ❌ View login history
   - ❌ Manage sessions

8. **Help & Support**
   - ❌ FAQ screen
   - ❌ Help documentation
   - ❌ Contact support
   - ❌ Report bug

9. **Onboarding**
   - ❌ First-time user tutorial
   - ❌ Feature walkthrough
   - ❌ Skip option

---

## Checklist Implementasi

### 🟢 Fully Implemented (90-100%)

#### Admin

- [x] Dashboard with statistics
- [x] Advanced statistics with charts
- [x] User management (Dosen & Mahasiswa)
- [x] Mata kuliah management
- [x] Peserta management
- [x] History absensi
- [x] Pengumuman management
- [x] Notification center
- [x] Export data
- [x] Profile management

**Completion:** ~95%

#### Dosen

- [x] Dashboard with stats
- [x] Mata kuliah list & detail
- [x] Generate QR code
- [x] Rekap kehadiran
- [x] Tugas management (CRUD + nilai)
- [x] Materi management (CRUD)
- [x] Pengumuman view
- [x] Profile management

**Completion:** ~90%

#### Mahasiswa

- [x] Dashboard with stats
- [x] QR Scanner
- [x] History absensi
- [x] Tugas view & submit
- [x] Materi view & download
- [x] Pengumuman view
- [x] Schedule view
- [x] Profile management

**Completion:** ~85%

#### Shared

- [x] Login/Logout
- [x] Splash screen
- [x] Theme management
- [x] Push notifications (FCM)
- [x] Reusable widgets
- [x] Utilities & helpers

**Completion:** ~80%

### 🟡 Partially Implemented (50-89%)

#### Admin

- [ ] Audit log (0%)
- [ ] System settings (0%)
- [ ] Semester management (0%)

#### Dosen

- [ ] Input absensi manual (0%)
- [ ] Dashboard charts (30% - basic only)
- [ ] Tugas rubrik & feedback (20%)

#### Mahasiswa

- [ ] Izin/sakit management (0%)
- [ ] Dashboard calendar view (0%)
- [ ] Nilai & transkrip (0%)

#### Shared

- [ ] Offline support (10% - basic caching)
- [ ] In-app notification center (0%)
- [ ] Search & filter global (30%)

### 🔴 Not Implemented (0-49%)

#### All Roles

- [ ] Forgot password (0%)
- [ ] Registration (0%)
- [ ] Dark mode (0%)
- [ ] 2FA Authentication (0%)
- [ ] Onboarding tutorial (0%)
- [ ] Help & FAQ (0%)

---

## Priority Development Roadmap

### 🔥 Phase 1: Critical Features (HIGH Priority)

**Timeline:** 2-3 weeks

1. **Forgot Password Flow**
   - Backend: Reset password API
   - Flutter: Forgot password screens
   - Email integration

2. **Input Absensi Manual (Dosen)**
   - Screen untuk input manual
   - Upload surat izin/sakit
   - Edit status absensi

3. **Izin/Sakit Management (Mahasiswa)**
   - Form pengajuan
   - Upload dokumen
   - Status tracking

4. **Dark Mode**
   - Theme switcher
   - Dark color palette
   - Persistent theme preference

5. **Offline Support Enhancement**
   - Better caching strategy
   - Queue sync actions
   - Offline indicator

### 🎯 Phase 2: Important Features (MEDIUM Priority)

**Timeline:** 3-4 weeks

1. **Nilai & Penilaian**
   - Input nilai UTS/UAS (Dosen)
   - Hitung nilai akhir
   - View nilai (Mahasiswa)
   - Transkrip screen

2. **Dashboard Enhancement**
   - Charts untuk semua role
   - Calendar view
   - Trend analysis

3. **Tugas Enhancement**
   - Rubrik penilaian
   - Feedback detail
   - Download bulk
   - Edit submission

4. **Notification Center**
   - In-app notification list
   - Badge counter
   - Mark as read/unread

5. **Profile Enhancement**
   - Upload foto profil
   - Image crop
   - View login history

### 💡 Phase 3: Nice-to-Have Features (LOW Priority)

**Timeline:** 2-3 weeks

1. **Audit Log (Admin)**
   - Track all actions
   - Filter & search
   - Export log

2. **System Settings (Admin)**
   - Configurable parameters
   - Email/SMS settings
   - Backup & restore

3. **Semester Management**
   - CRUD semester
   - Archive data
   - Set active semester

4. **Advanced Analytics**
   - Prediction models
   - Correlation analysis
   - Custom reports

5. **Help & Support**
   - FAQ
   - Documentation
   - Contact support

6. **Onboarding**
   - First-time tutorial
   - Feature walkthrough

---

## Technical Recommendations

### Performance Optimization

1. **Image Optimization**
   - Use `cached_network_image` for all network images
   - Compress images before upload
   - Use proper image sizes

2. **List Performance**
   - Implement pagination
   - Use `ListView.builder` for long lists
   - Add pull-to-refresh

3. **State Management**
   - Optimize provider listeners
   - Use `Consumer` wisely
   - Avoid unnecessary rebuilds

4. **Network Optimization**
   - Implement request caching
   - Use HTTP compression
   - Retry failed requests

### Security Best Practices

1. **Token Management**
   - Store tokens securely (flutter_secure_storage)
   - Implement token refresh
   - Clear tokens on logout

2. **Input Validation**
   - Validate all user inputs
   - Sanitize data before sending
   - Use proper validators

3. **API Security**
   - Use HTTPS only
   - Implement certificate pinning
   - Handle API errors properly

4. **Data Protection**
   - Don't log sensitive data
   - Encrypt local storage
   - Handle permissions properly

### Code Quality

1. **Code Organization**
   - Follow feature-first structure
   - Separate business logic from UI
   - Use proper naming conventions

2. **Error Handling**
   - Use try-catch blocks
   - Show user-friendly messages
   - Log errors for debugging

3. **Testing**
   - Write unit tests for services
   - Write widget tests for UI
   - Integration tests for critical flows

4. **Documentation**
   - Comment complex logic
   - Document API endpoints
   - Maintain changelog

### UI/UX Improvements

1. **Loading States**
   - Show skeleton loaders
   - Use shimmer effects
   - Provide feedback on actions

2. **Error States**
   - Show error messages
   - Provide retry options
   - Graceful degradation

3. **Empty States**
   - Show helpful messages
   - Provide actions (e.g., "Create first task")
   - Use illustrations

4. **Accessibility**
   - Use semantic labels
   - Proper contrast ratios
   - Support screen readers

---

## Integration Checklist

### Backend Integration

- [x] API base URL configuration
- [x] Authentication (Sanctum tokens)
- [x] Request interceptors (token, headers)
- [x] Response interceptors (error handling)
- [x] All CRUD endpoints connected
- [x] File upload/download
- [x] Push notification token registration
- [ ] Forgot password API
- [ ] Email verification API

### Firebase Integration

- [x] Firebase Core setup
- [x] Firebase Messaging (FCM)
- [x] Notification handling (foreground/background)
- [x] Token management
- [ ] Firebase Analytics
- [ ] Firebase Crashlytics
- [ ] Remote Config

### Third-Party Services

- [x] QR Code scanner (mobile_scanner)
- [x] QR Code generator (qr_flutter)
- [x] Image picker
- [x] File picker
- [x] Charts (fl_chart)
- [ ] Maps integration (Google Maps)
- [ ] Payment gateway (if needed)
- [ ] Analytics (Google Analytics)

---

## Testing Strategy

### Unit Tests

```dart
test/
├── services/
│   ├── auth_service_test.dart
│   ├── api_service_test.dart
│   └── storage_service_test.dart
├── providers/
│   ├── auth_provider_test.dart
│   └── dashboard_provider_test.dart
└── utils/
    ├── validator_utils_test.dart
    └── date_utils_test.dart
```

### Widget Tests

```dart
test/
└── widgets/
    ├── custom_button_test.dart
    ├── custom_text_field_test.dart
    └── stat_card_test.dart
```

### Integration Tests

```dart
integration_test/
├── login_flow_test.dart
├── scan_qr_flow_test.dart
├── submit_tugas_flow_test.dart
└── admin_user_management_test.dart
```

---

## Build & Deployment

### Android Build

1. **Debug Build**

```bash
flutter build apk --debug
```

2. **Release Build**

```bash
flutter build apk --release
flutter build appbundle --release  # For Play Store
```

3. **App Signing**

- Configure `android/app/build.gradle`
- Create keystore
- Sign APK/AAB

### iOS Build

1. **Debug Build**

```bash
flutter build ios --debug
```

2. **Release Build**

```bash
flutter build ios --release
```

3. **App Store Submission**

- Configure Xcode project
- Set up provisioning profiles
- Build & archive

### Environment Configuration

**Development**

```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'http://localhost:8000/api';
static const bool isDevelopment = true;
```

**Production**

```dart
static const String baseUrl = 'https://api.jayq.app/api';
static const bool isDevelopment = false;
```

---

## Summary

### Overall Implementation Status

| Feature Category  | Admin  | Dosen  | Mahasiswa | Shared |
| ----------------- | ------ | ------ | --------- | ------ |
| **Core Features** | 95% ✅ | 90% ✅ | 85% ✅    | 80% ✅ |
| **Enhancement**   | 20% 🟡 | 30% 🟡 | 25% 🟡    | 35% 🟡 |
| **Advanced**      | 10% 🔴 | 15% 🔴 | 10% 🔴    | 20% 🔴 |

### Key Achievements ✨

1. ✅ **Solid Foundation**
   - Clean architecture (MVVM)
   - Provider state management
   - Reusable components
   - Consistent UI/UX

2. ✅ **Core Functionality**
   - Complete CRUD operations
   - QR code system working
   - File upload/download
   - Push notifications

3. ✅ **Role-Based Access**
   - Proper authentication
   - Role-specific dashboards
   - Permission handling

4. ✅ **Good UX**
   - Loading states
   - Error handling
   - Form validation
   - Responsive design

### Critical Next Steps 🚀

1. **Security** ⚠️
   - Implement forgot password
   - Add 2FA (optional)
   - Certificate pinning

2. **User Experience** 📱
   - Dark mode
   - Offline support
   - Better error messages

3. **Features** 🎯
   - Nilai & penilaian
   - Izin/sakit management
   - Input absensi manual

4. **Polish** ✨
   - Onboarding tutorial
   - Help documentation
   - Performance optimization

---

**Dokumentasi dibuat:** 23 Juni 2026  
**Versi App:** 1.0.0+1  
**Flutter SDK:** ^3.11.4  
**Minimum SDK:** Android 21 (5.0), iOS 12.0

---

## Kontak & Support

**Developer Team:** JAYQ Development  
**Repository:** [Git repository URL]  
**Issues:** [Issue tracker URL]  
**Documentation:** [Docs URL]
