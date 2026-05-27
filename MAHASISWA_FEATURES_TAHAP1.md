# Fitur Mahasiswa - TAHAP 1: Scan QR Absensi

## ✅ Yang Sudah Dibuat

### 1. QR Scanner Screen

**File:** `jayq_app/lib/screens/mahasiswa/qr_scanner_screen.dart`

**Fitur:**

- ✅ Full-screen camera view
- ✅ Auto-detect QR code
- ✅ Scanning frame dengan corner borders
- ✅ Toggle flashlight
- ✅ Switch camera (front/back)
- ✅ Loading indicator saat processing
- ✅ Success dialog dengan animasi
- ✅ Error dialog dengan pesan jelas
- ✅ Dark mode support
- ✅ Custom overlay dengan clear scanning area

### 2. Absensi Service

**File:** `jayq_app/lib/data/services/absensi_service.dart`

**Methods:**

- ✅ `scanQr(String qrCode)` - Kirim QR code ke backend
- ✅ `getRiwayatAbsensi()` - Get history absensi (untuk tahap selanjutnya)
- ✅ Error handling lengkap
- ✅ Dio exception handling

### 3. Updated Mahasiswa Dashboard

**File:** `jayq_app/lib/screens/mahasiswa/mahasiswa_dashboard_screen.dart`

**Perubahan:**

- ✅ FAB button sekarang fungsional
- ✅ Navigate ke QR Scanner
- ✅ Auto reload stats setelah absensi berhasil
- ✅ Success snackbar
- ✅ Extended FAB dengan label "Scan QR"

## 🚀 Cara Test

### Step 1: Hot Restart

```bash
# Di terminal Flutter, tekan:
R  (huruf R besar)
```

### Step 2: Login sebagai Mahasiswa

1. Buka app
2. Login dengan akun mahasiswa
3. Masuk ke dashboard mahasiswa

### Step 3: Test Scan QR

1. Klik FAB button "Scan QR" di kanan bawah
2. Allow camera permission jika diminta
3. Arahkan kamera ke QR code
4. QR akan auto-detect
5. Loading indicator muncul
6. Success/Error dialog muncul

### Step 4: Verify Absensi

1. Setelah success, kembali ke dashboard
2. Persentase kehadiran akan update otomatis
3. Snackbar hijau muncul: "Absensi berhasil! Data diperbarui."

## 📱 UI/UX Features

### Camera View

```
┌─────────────────────────────────────┐
│  ← Scan QR Absensi    🔦  📷       │
├─────────────────────────────────────┤
│                                     │
│         [Camera View]               │
│                                     │
│     ┌─────────────────┐            │
│     │                 │            │
│     │   Scan Area     │            │
│     │                 │            │
│     └─────────────────┘            │
│                                     │
│  ┌───────────────────────────┐    │
│  │  📷 Arahkan kamera ke QR  │    │
│  │  QR akan otomatis detect  │    │
│  └───────────────────────────┘    │
└─────────────────────────────────────┘
```

### Success Dialog

```
┌─────────────────────────────────────┐
│                                     │
│         ✅ (Green Circle)           │
│                                     │
│      Absensi Berhasil!              │
│   Kehadiran Anda telah tercatat    │
│                                     │
│     [Kembali Button]                │
│                                     │
└─────────────────────────────────────┘
```

### Error Dialog

```
┌─────────────────────────────────────┐
│                                     │
│         ❌ (Red Circle)             │
│                                     │
│        Absensi Gagal                │
│     QR code tidak valid atau        │
│     sesi sudah berakhir             │
│                                     │
│     [Coba Lagi Button]              │
│                                     │
└─────────────────────────────────────┘
```

## 🎨 Design Features

### Scanning Overlay

- **Semi-transparent black** background (50% opacity)
- **Clear scanning area** di tengah (70% screen width)
- **Blue corner borders** (#003D9B)
- **Rounded corners** (16px radius)

### FAB Button

- **Extended FAB** dengan icon + label
- **Blue background** (#003D9B)
- **White icon & text**
- **Position:** Bottom-right
- **Label:** "Scan QR"

### Dialogs

- **Rounded corners** (16px)
- **Icon dengan background circle**
- **Title bold** (20px, weight 700)
- **Subtitle** (14px, gray)
- **Full-width button**

## 🔧 Backend Integration

### API Endpoint

```http
POST /api/scan-qr
Authorization: Bearer {token}
Content-Type: application/json

{
  "qr_code": "encrypted_qr_string"
}

Response Success:
{
  "success": true,
  "message": "Absensi berhasil dicatat",
  "data": {
    "absensi_id": 123,
    "mata_kuliah": "Mobile Programming",
    "waktu": "2026-05-26 10:30:00"
  }
}

Response Error:
{
  "success": false,
  "message": "QR code tidak valid"
}
```

## ⚠️ Error Handling

### Possible Errors:

1. **QR code tidak valid** - QR tidak terdaftar di sistem
2. **Sesi sudah berakhir** - QR sudah expired (>5 menit)
3. **Sudah absen** - Mahasiswa sudah absen untuk sesi ini
4. **Koneksi bermasalah** - No internet connection
5. **Token expired** - User perlu login ulang

### Error Messages:

- Clear dan informatif
- Bahasa Indonesia
- Actionable (ada tombol "Coba Lagi")

## 📋 Testing Checklist

```
☐ Camera permission granted
☐ Camera view muncul dengan benar
☐ Scanning frame terlihat jelas
☐ QR code terdeteksi otomatis
☐ Loading indicator muncul saat processing
☐ Success dialog muncul jika berhasil
☐ Error dialog muncul jika gagal
☐ Flashlight toggle berfungsi
☐ Switch camera berfungsi
☐ Back button kembali ke dashboard
☐ Stats auto reload setelah success
☐ Snackbar muncul setelah success
```

## 🐛 Troubleshooting

### Camera tidak muncul

**Penyebab:** Permission belum diberikan

**Solusi:**

1. Settings → Apps → JAYQ → Permissions
2. Enable Camera permission
3. Restart app

### QR tidak terdeteksi

**Penyebab:** QR terlalu kecil atau blur

**Solusi:**

1. Dekatkan kamera ke QR
2. Pastikan QR dalam scanning frame
3. Pastikan pencahayaan cukup
4. Toggle flashlight jika gelap

### Error "QR code tidak valid"

**Penyebab:** QR bukan dari sistem atau sudah expired

**Solusi:**

1. Pastikan QR dari dosen yang benar
2. Cek waktu - QR hanya valid 5 menit
3. Minta dosen generate QR baru

### Error "Sudah absen"

**Penyebab:** Mahasiswa sudah absen untuk sesi ini

**Solusi:**

- Ini normal, tidak perlu scan ulang
- Cek riwayat absensi untuk konfirmasi

## 💡 Tips Penggunaan

### Untuk Mahasiswa:

1. **Scan segera** setelah dosen generate QR (max 5 menit)
2. **Pastikan internet** stabil saat scan
3. **Dekatkan kamera** untuk deteksi lebih cepat
4. **Gunakan flashlight** jika ruangan gelap
5. **Tunggu success dialog** sebelum keluar

### Untuk Dosen:

1. **Generate QR** di awal kelas
2. **Tampilkan QR** di proyektor atau layar besar
3. **Beri waktu** mahasiswa untuk scan (5-10 menit)
4. **Monitor** jumlah yang sudah absen di dashboard

## 🚀 Next Steps (Tahap 2)

Fitur selanjutnya yang akan dibuat:

1. **Riwayat Absensi** - Lihat history kehadiran
2. **Notification Center** - Baca pengumuman
3. **Jadwal Lengkap** - Lihat semua jadwal kuliah

---

**Status:** ✅ TAHAP 1 Complete
**Last Updated:** 26 Mei 2026
**Next:** TAHAP 2 - Riwayat Absensi
