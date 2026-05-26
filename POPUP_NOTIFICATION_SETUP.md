# Popup Notification - Setup Complete

## ✅ Yang Sudah Dibuat

### 1. Local Notification Service

**File:** `jayq_app/lib/data/services/notification_service.dart`

**Fitur Baru:**

- ✅ `showTestNotification()` - Menampilkan popup notification langsung
- ✅ Sound & vibration enabled
- ✅ High priority notification
- ✅ Custom icon (app launcher icon)

### 2. Auto Popup After Broadcast

**File:** `jayq_app/lib/screens/admin/broadcast_pengumuman_screen.dart`

**Behavior:**

- ✅ Setelah kirim pengumuman → Popup muncul otomatis
- ✅ Menampilkan judul: "📢 Pengumuman Baru"
- ✅ Menampilkan isi pengumuman (max 100 karakter)
- ✅ Sound & vibration

### 3. Android Configuration

**File:** `android/app/src/main/AndroidManifest.xml`

**Sudah dikonfigurasi:**

- ✅ `POST_NOTIFICATIONS` permission
- ✅ Firebase Messaging Service
- ✅ Default notification channel
- ✅ Notification icon & color

## 🚀 Cara Test Popup Notification

### Step 1: Hot Restart App

```bash
# Di terminal Flutter, tekan:
R  (huruf R besar untuk restart)
```

### Step 2: Grant Notification Permission

Saat pertama kali buka app, akan muncul dialog:

```
"JAYQ wants to send you notifications"
[Don't Allow]  [Allow]
```

**Klik "Allow"** untuk mengizinkan notifikasi

### Step 3: Test Broadcast Pengumuman

1. Login sebagai admin
2. Dashboard → Icon broadcast (megaphone)
3. Isi form:
   - Target: Semua
   - Isi: "Test popup notification"
4. Klik "Kirim Pengumuman"

### Step 4: Lihat Popup Notification

Setelah kirim, akan muncul:

1. **Snackbar hijau** di bawah: "Pengumuman berhasil dikirim..."
2. **Popup notification** dari atas dengan:
   - 📢 Icon
   - Judul: "Pengumuman Baru"
   - Isi: "Test popup notification"
   - Sound & vibration

## 📱 Jenis Notification

### A. Foreground Notification (App Terbuka)

**Behavior:**

- Popup muncul dari atas layar
- Sound & vibration
- Bisa di-tap untuk buka detail
- Auto dismiss setelah beberapa detik

### B. Background Notification (App Tertutup/Minimize)

**Behavior:**

- Muncul di notification tray
- Sound & vibration
- Badge di app icon
- Tap untuk buka app

### C. Notification Tray

**Behavior:**

- Swipe down dari atas untuk lihat semua notifikasi
- Tap notification → Buka app
- Swipe notification → Dismiss

## 🎨 Notification Design

### Popup Appearance:

```
┌─────────────────────────────────────┐
│  📢  JAYQ                           │
│  Pengumuman Baru                    │
│  Test popup notification            │
│                                     │
│  Baru saja                          │
└─────────────────────────────────────┘
```

### Notification Tray:

```
┌─────────────────────────────────────┐
│  📢  JAYQ                      Baru │
│  Pengumuman Baru                    │
│  Test popup notification            │
└─────────────────────────────────────┘
```

## 🔧 Konfigurasi Notification

### Priority & Importance

```dart
Importance: HIGH
Priority: HIGH
Sound: Enabled
Vibration: Enabled
Show When: True
```

### Channel Configuration

```dart
Channel ID: pengumuman_channel
Channel Name: Pengumuman
Description: Channel untuk pengumuman kampus
```

## 📋 Troubleshooting

### Popup tidak muncul

#### 1. Permission Belum Diberikan

**Gejala:** Tidak ada popup sama sekali

**Solusi:**

1. Buka Settings → Apps → JAYQ
2. Notifications → Enable
3. Atau uninstall dan install ulang app

#### 2. App Belum Di-Restart

**Gejala:** Popup tidak muncul setelah update kode

**Solusi:**

```bash
# Stop app
Ctrl+C

# Run ulang
flutter run
```

#### 3. Sound/Vibration Tidak Muncul

**Gejala:** Popup muncul tapi tidak ada suara

**Solusi:**

1. Cek volume HP tidak silent
2. Cek Do Not Disturb mode OFF
3. Cek notification settings di HP

#### 4. Notification Tertunda

**Gejala:** Popup muncul terlambat

**Solusi:**

1. Cek koneksi internet
2. Restart app
3. Clear app cache

### Error: "Notification permission denied"

**Penyebab:** User klik "Don't Allow" saat diminta permission

**Solusi:**

1. Uninstall app
2. Install ulang
3. Klik "Allow" saat diminta permission

Atau:

1. Settings → Apps → JAYQ
2. Permissions → Notifications → Allow

### Popup muncul 2x

**Penyebab:** Normal behavior - satu dari local notification, satu dari FCM

**Solusi:** Ini expected behavior untuk testing. Nanti setelah FCM fully setup, hanya akan muncul 1x.

## 🎯 Expected Behavior

### Scenario 1: Admin Kirim Pengumuman

**Step by step:**

1. Admin klik "Kirim Pengumuman"
2. Loading indicator muncul
3. Pengumuman tersimpan ke database
4. API notification dipanggil
5. **Popup muncul** dengan sound & vibration
6. Snackbar hijau muncul
7. Kembali ke halaman sebelumnya
8. Badge di bell icon bertambah

### Scenario 2: User Terima Notification

**Jika app terbuka:**

- Popup muncul dari atas
- Sound & vibration
- Auto dismiss atau tap untuk detail

**Jika app tertutup:**

- Notification muncul di tray
- Sound & vibration
- Badge di app icon
- Tap untuk buka app

### Scenario 3: Multiple Notifications

**Behavior:**

- Setiap pengumuman baru → Popup baru
- Notification stack di tray
- Badge counter bertambah
- Sound setiap notification baru

## 💡 Tips

### Untuk Testing:

1. **Test di emulator:** Popup akan muncul di emulator
2. **Test di HP fisik:** Lebih akurat untuk sound & vibration
3. **Test background:** Minimize app lalu kirim pengumuman
4. **Test foreground:** App terbuka saat kirim pengumuman

### Untuk Production:

1. **Jangan spam:** Batasi frekuensi pengumuman
2. **Timing:** Kirim di jam kerja/kuliah
3. **Content:** Isi yang jelas dan singkat
4. **Priority:** Gunakan "Urgent" hanya untuk hal penting

## 🔔 Notification Types by Priority

### Info (Default)

- Sound: Default
- Vibration: Short
- Priority: Normal
- Color: Blue

### Penting

- Sound: Default
- Vibration: Medium
- Priority: High
- Color: Orange

### Urgent

- Sound: Loud
- Vibration: Long
- Priority: Max
- Color: Red

## 📞 Jika Masalah Berlanjut

Kirimkan informasi:

1. **Screenshot** notification permission di Settings
2. **Log Flutter** saat kirim pengumuman
3. **Device info:** Android version, device model
4. **Behavior:** Popup muncul atau tidak? Sound? Vibration?

## 🚀 Next Steps

Saat ini notification sudah berfungsi dengan **local notification**. Untuk full push notification (notification muncul di device lain), perlu:

1. **Firebase Admin SDK** di Laravel backend
2. **FCM Token** disimpan untuk setiap user
3. **Server-side push** dari backend ke FCM
4. **Handle notification tap** untuk buka detail

Tapi untuk testing dan demo, **local notification sudah cukup** untuk menunjukkan fitur popup notification!

---

**Status:** ✅ Ready to test
**Last Updated:** 26 Mei 2026
**Version:** 1.0.0
