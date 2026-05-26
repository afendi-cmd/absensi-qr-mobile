# Notification Center - Complete Setup

## ✅ Yang Sudah Dibuat

### 1. Notification Center Screen

**File:** `jayq_app/lib/screens/admin/notification_center_screen.dart`

**Fitur:**

- ✅ List semua pengumuman dengan design modern
- ✅ Badge untuk tipe pengumuman (Info/Penting/Urgent)
- ✅ Waktu relatif ("2 jam yang lalu")
- ✅ Pull to refresh
- ✅ Detail pengumuman dalam bottom sheet
- ✅ Empty state yang informatif
- ✅ Full dark mode support

### 2. Notification Bell dengan Badge

**File:** `jayq_app/lib/screens/admin/admin_dashboard_screen.dart`

**Fitur:**

- ✅ Icon bell di kanan atas dashboard
- ✅ Badge merah dengan counter jumlah pengumuman
- ✅ Clickable - membuka Notification Center
- ✅ Auto reload count setelah kembali dari Notification Center

### 3. Dependencies

**File:** `jayq_app/pubspec.yaml`

**Ditambahkan:**

- ✅ `timeago: ^3.7.0` - untuk format waktu relatif

## 🚀 Cara Install & Test

### Step 1: Install Dependencies

```bash
cd jayq_app
flutter pub get
```

### Step 2: Hot Restart App

```bash
# Di terminal Flutter, tekan:
R  (huruf R besar)

# Atau stop dan run ulang:
flutter run
```

### Step 3: Test Notification Center

1. **Buka app** dan login sebagai admin
2. **Lihat icon bell** di kanan atas dashboard
3. **Badge merah** akan muncul jika ada pengumuman
4. **Klik icon bell** untuk membuka Notification Center
5. **Lihat list pengumuman** dengan design modern
6. **Klik pengumuman** untuk melihat detail lengkap

### Step 4: Test Broadcast Pengumuman

1. **Klik icon broadcast** (megaphone) di dashboard atau di halaman Pengumuman
2. **Isi form broadcast:**
   - Target: Semua/Dosen/Mahasiswa
   - Isi: "Test pengumuman baru"
3. **Kirim pengumuman**
4. **Kembali ke dashboard**
5. **Badge di bell icon** akan bertambah
6. **Klik bell** untuk melihat pengumuman baru

## 📱 Fitur Notification Center

### A. List Pengumuman

- **Card design** dengan border sesuai tipe
- **Icon** berbeda untuk setiap tipe:
  - 🔔 Info: Icon campaign (biru)
  - ⚠️ Penting: Icon priority (orange)
  - 🚨 Urgent: Icon warning (merah)
- **Badge tipe** di kanan atas card
- **Waktu relatif** (2 jam yang lalu, kemarin, dll)
- **Nama pembuat** pengumuman
- **Preview isi** (2 baris pertama)

### B. Detail Pengumuman

- **Bottom sheet** dengan design modern
- **Judul lengkap** dengan badge tipe
- **Waktu dan pembuat**
- **Isi lengkap** pengumuman
- **Swipe down** untuk tutup

### C. Empty State

- **Icon besar** notification kosong
- **Pesan informatif**
- **Design yang friendly**

### D. Pull to Refresh

- **Tarik ke bawah** untuk reload data
- **Loading indicator** saat refresh

## 🎨 Design Features

### Color Coding by Type

```dart
Info     → Blue   (#003D9B)
Penting  → Orange
Urgent   → Red
```

### Badge Counter

```dart
1-9      → Tampil angka (1, 2, 3, ...)
10+      → Tampil "9+"
0        → Badge tidak muncul
```

### Dark Mode

- ✅ Full support untuk light & dark theme
- ✅ Warna otomatis menyesuaikan
- ✅ Kontras yang baik di semua mode

## 🔔 Push Notification (Next Step)

Saat ini sistem sudah:

- ✅ Kirim pengumuman ke database
- ✅ Tampil di Notification Center
- ✅ Badge counter berfungsi

Yang masih perlu:

- ⏳ Firebase Cloud Messaging setup lengkap
- ⏳ Push notification muncul otomatis
- ⏳ Notification sound & vibration
- ⏳ Tap notification → buka detail

Untuk enable push notification, perlu:

1. Setup Firebase Admin SDK di Laravel backend
2. Konfigurasi Android notification channel
3. Handle notification tap action

## 📋 Troubleshooting

### Badge tidak muncul

**Penyebab:** Belum ada pengumuman di database

**Solusi:**

1. Kirim pengumuman dari broadcast screen
2. Cek database: `SELECT * FROM pengumuman`
3. Pastikan `is_active = 1`

### List pengumuman kosong

**Penyebab:** Filter target tidak sesuai atau pengumuman tidak aktif

**Solusi:**

1. Cek target pengumuman (all/dosen/mahasiswa)
2. Pastikan pengumuman `is_active = true`
3. Pull to refresh untuk reload data

### Error saat buka Notification Center

**Penyebab:** Token expired atau backend tidak jalan

**Solusi:**

1. Logout dan login ulang
2. Pastikan backend Laravel jalan
3. Cek log Flutter untuk error detail

### Waktu tidak muncul dengan benar

**Penyebab:** Package timeago belum terinstall

**Solusi:**

```bash
flutter pub get
flutter run
```

## 💡 Tips Penggunaan

### Untuk Admin:

1. **Broadcast pengumuman** → Badge bertambah otomatis
2. **Klik bell** → Lihat semua pengumuman
3. **Klik pengumuman** → Lihat detail lengkap
4. **Pull to refresh** → Update list terbaru

### Untuk Dosen/Mahasiswa:

1. **Bell icon** menampilkan pengumuman sesuai target
2. **Hanya melihat** pengumuman untuk role mereka
3. **Tidak bisa broadcast** (hanya admin)

## 🎯 Expected Behavior

### Setelah Broadcast Pengumuman:

1. **Snackbar hijau:** "Pengumuman berhasil dikirim ke semua pengguna"
2. **Kembali ke dashboard**
3. **Badge di bell:** Angka bertambah (misalnya dari 3 → 4)
4. **Klik bell:** Pengumuman baru muncul di paling atas
5. **Klik pengumuman:** Detail muncul dalam bottom sheet

### Notification Center:

```
┌─────────────────────────────────────┐
│  ← Notifikasi          Tandai Semua │
├─────────────────────────────────────┤
│                                     │
│  🔔  Pengumuman Baru         INFO  │
│      Isi pengumuman...              │
│      ⏰ 2 jam yang lalu  👤 Admin  │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  ⚠️  Perubahan Jadwal     PENTING  │
│      Jadwal kuliah...               │
│      ⏰ Kemarin  👤 Admin           │
│                                     │
└─────────────────────────────────────┘
```

## 📞 Jika Ada Masalah

Kirimkan informasi:

1. **Screenshot** Notification Center
2. **Badge counter** di bell icon
3. **Log Flutter** jika ada error
4. **Hasil query:** `SELECT * FROM pengumuman ORDER BY created_at DESC LIMIT 5`

---

**Status:** ✅ Ready to use
**Last Updated:** 26 Mei 2026
**Version:** 1.0.0
