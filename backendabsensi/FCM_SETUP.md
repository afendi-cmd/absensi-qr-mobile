# Setup Firebase Cloud Messaging (FCM) untuk Push Notifications

## 📋 Langkah-langkah Setup

### 1. Dapatkan FCM Server Key dari Firebase Console

1. **Buka Firebase Console:**
    - Kunjungi: https://console.firebase.google.com/
    - Pilih project Anda

2. **Buka Project Settings:**
    - Klik icon ⚙️ (Settings) di sidebar
    - Pilih "Project settings"

3. **Buka Tab Cloud Messaging:**
    - Klik tab "Cloud Messaging"
    - Scroll ke bawah ke bagian "Cloud Messaging API (Legacy)"

4. **Copy Server Key:**
    - Copy "Server key" yang ditampilkan
    - Format: `AAAA...` (panjang sekitar 152 karakter)

### 2. Tambahkan FCM Server Key ke .env

1. **Buka file `.env` di backend:**

    ```bash
    cd backendabsensi
    nano .env
    ```

2. **Tambahkan baris berikut di akhir file:**

    ```env
    # Firebase Cloud Messaging
    FCM_SERVER_KEY=AAAA...your_actual_server_key_here
    ```

3. **Save file** (Ctrl+O, Enter, Ctrl+X di nano)

### 3. Restart Laravel Server

```bash
# Stop server (Ctrl+C)
# Start server again
php artisan serve
```

## 🧪 Testing Push Notifications

### Test 1: Cek FCM Token Tersimpan

```sql
-- Jalankan di MySQL/phpMyAdmin
SELECT id, nama, role, fcm_token
FROM users
WHERE role = 'mahasiswa'
LIMIT 5;
```

**Expected:** FCM token harus terisi (bukan NULL)

### Test 2: Kirim Pengumuman dari Admin

1. Login sebagai Admin
2. Buka menu "Pengumuman"
3. Klik "Tambah Pengumuman"
4. Isi form:
    - Judul: "Test Notifikasi"
    - Isi: "Ini adalah test push notification"
    - Tipe: Info
    - Target: Mahasiswa
5. Klik "Simpan"

### Test 3: Cek di Mahasiswa

**Expected:**

- ✅ Mahasiswa menerima pop-up notification
- ✅ Badge di dashboard bertambah
- ✅ Pengumuman muncul di list

### Test 4: Cek Log Backend

```bash
tail -f storage/logs/laravel.log
```

**Expected log:**

```
[timestamp] local.INFO: Sent pengumuman notification to X devices
```

## 🔧 Troubleshooting

### Problem 1: Notifikasi Tidak Muncul

**Solusi:**

1. Cek FCM_SERVER_KEY di .env sudah benar
2. Restart Laravel server
3. Cek FCM token di database tidak NULL
4. Cek permission notifikasi di Flutter sudah granted

### Problem 2: Error "FCM Service not configured"

**Solusi:**

1. Pastikan FCM_SERVER_KEY ada di .env
2. Restart Laravel server
3. Clear config cache:
    ```bash
    php artisan config:clear
    ```

### Problem 3: FCM Token NULL di Database

**Solusi:**

1. Logout dari aplikasi Flutter
2. Login kembali
3. FCM token akan otomatis tersimpan

### Problem 4: Error 401 Unauthorized dari FCM

**Solusi:**

1. Server Key salah atau expired
2. Dapatkan Server Key baru dari Firebase Console
3. Update di .env

## 📱 Format Notifikasi

### Title Format:

```
📢 Info: [Judul Pengumuman]
📢 Penting: [Judul Pengumuman]
📢 Urgent: [Judul Pengumuman]
```

### Body Format:

```
[Isi pengumuman max 100 karakter]...
```

### Data Payload:

```json
{
    "type": "pengumuman",
    "pengumuman_id": "123",
    "tipe": "info",
    "click_action": "FLUTTER_NOTIFICATION_CLICK"
}
```

## 🔐 Security Notes

1. **Jangan commit FCM_SERVER_KEY ke Git:**
    - File `.env` sudah ada di `.gitignore`
    - Jangan share Server Key di public

2. **Gunakan Environment Variables:**
    - Development: `.env`
    - Production: Set di server environment

3. **Rotate Server Key secara berkala:**
    - Generate new key di Firebase Console
    - Update di semua environments

## 📊 Monitoring

### Check Notification Success Rate:

```bash
# Check logs
grep "Sent pengumuman notification" storage/logs/laravel.log | tail -20
```

### Check Failed Notifications:

```bash
# Check errors
grep "FCM send failed" storage/logs/laravel.log | tail -20
```

## 🎯 Target Users

| Target      | Users Notified    |
| ----------- | ----------------- |
| `mahasiswa` | Hanya mahasiswa   |
| `dosen`     | Hanya dosen       |
| `all`       | Mahasiswa + Dosen |

## ✅ Checklist Setup

- [ ] FCM Server Key didapat dari Firebase Console
- [ ] FCM_SERVER_KEY ditambahkan ke .env
- [ ] Laravel server di-restart
- [ ] Test kirim pengumuman dari admin
- [ ] Mahasiswa menerima notifikasi
- [ ] Log backend menunjukkan success

---

**Status:** Ready to use! 🚀
