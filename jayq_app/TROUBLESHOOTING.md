# JAYQ - Troubleshooting Guide

## 🔴 Login Failed Error

### Masalah: "Login failed" muncul di bottom screen

#### Penyebab Umum:

1. **Backend tidak berjalan**
2. **IP Address salah**
3. **Database belum di-seed**
4. **Firewall memblokir koneksi**

---

## ✅ Solusi Step-by-Step

### 1. Pastikan Backend Berjalan

```bash
cd backendabsensi
php artisan serve
```

**Output yang benar:**

```
Starting Laravel development server: http://127.0.0.1:8000
```

### 2. Cek IP Address Configuration

#### Untuk Android Emulator:

```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

#### Untuk Physical Device:

```dart
// lib/core/constants/app_constants.dart
static const String baseUrl = 'http://192.168.1.XXX:8000/api';
```

**Cara mendapatkan IP komputer:**

Windows:

```bash
ipconfig
# Cari "IPv4 Address" di bagian WiFi/Ethernet
```

Mac/Linux:

```bash
ifconfig
# Cari "inet" address
```

### 3. Test Backend API

#### Test dengan Browser:

Buka: `http://localhost:8000/api/login`

Seharusnya muncul error 405 (Method Not Allowed) - ini normal karena butuh POST request.

#### Test dengan Postman:

```
POST http://localhost:8000/api/login
Headers:
  Content-Type: application/json
  Accept: application/json
Body (JSON):
{
  "email": "admin@jayq.com",
  "password": "password"
}
```

**Response yang benar:**

```json
{
  "success": true,
  "message": "Login berhasil",
  "data": {
    "token": "1|...",
    "user": {
      "id": 1,
      "nama": "Admin JAYQ",
      "email": "admin@jayq.com",
      "role": "admin"
    }
  }
}
```

### 4. Cek Database & Seeder

```bash
cd backendabsensi

# Reset database dan seed ulang
php artisan migrate:fresh --seed
```

**Output yang benar:**

```
Dropped all tables successfully.
Migration table created successfully.
Migrating: ...
Migrated: ...
Seeding: DatabaseSeeder
Seeded: DatabaseSeeder
```

### 5. Test dari Flutter App

Jalankan test script:

```bash
cd jayq_app
dart test_api.dart
```

**Output yang benar:**

```
Testing API Connection...
Testing URL: http://10.0.2.2:8000/api/login
Status Code: 200
✅ Login successful!
Token: 1|...
User: Admin JAYQ
Role: admin
```

### 6. Cek Flutter Console

Saat menjalankan app, perhatikan console output:

```
🌐 POST Request to: http://10.0.2.2:8000/api/login
📤 Request Body: {"email":"admin@jayq.com","password":"password"}
📥 Response Status: 200
📥 Response Body: {"success":true,...}
```

---

## 🔍 Debug Checklist

- [ ] Backend running di port 8000
- [ ] Database sudah di-migrate dan seed
- [ ] IP address benar (10.0.2.2 untuk emulator)
- [ ] Firewall tidak memblokir port 8000
- [ ] Email dan password benar
- [ ] Internet/network permission di AndroidManifest.xml

---

## 🌐 Network Permission

Pastikan file `android/app/src/main/AndroidManifest.xml` memiliki:

```xml
<manifest ...>
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

    <application ...>
        ...
    </application>
</manifest>
```

---

## 🔥 Firewall Settings

### Windows Firewall:

1. Buka "Windows Defender Firewall"
2. Klik "Allow an app through firewall"
3. Cari "PHP" atau "Laravel"
4. Centang "Private" dan "Public"

Atau disable firewall sementara untuk testing:

```powershell
# Run as Administrator
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False
```

### Alternatif: Bind ke semua interface

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

---

## 📱 Test Credentials

### Admin

```
Email: admin@jayq.com
Password: password
```

### Dosen

```
Email: budi@jayq.com
Password: password
```

### Mahasiswa

```
Email: ahmad@jayq.com
Password: password
```

---

## 🐛 Common Errors

### Error: "No internet connection"

- Cek permission di AndroidManifest.xml
- Cek network di emulator/device
- Pastikan backend berjalan

### Error: "Service unavailable"

- Backend mungkin crash
- Cek log Laravel: `tail -f storage/logs/laravel.log`

### Error: "Unauthorized - Please login again"

- Token expired atau invalid
- Clear app data dan login ulang

### Error: "Email atau password salah"

- Cek credentials
- Pastikan database sudah di-seed
- Test login di Postman

### Error: "Validation error"

- Email format salah
- Password kurang dari 6 karakter

---

## 🔧 Advanced Debugging

### 1. Enable Laravel Debug Mode

Edit `backendabsensi/.env`:

```
APP_DEBUG=true
APP_ENV=local
```

### 2. Check Laravel Logs

```bash
cd backendabsensi
tail -f storage/logs/laravel.log
```

### 3. Flutter Verbose Mode

```bash
flutter run -v
```

### 4. Network Monitoring

Gunakan tools seperti:

- Charles Proxy
- Fiddler
- Wireshark

---

## 💡 Quick Fixes

### Reset Everything:

```bash
# Backend
cd backendabsensi
php artisan migrate:fresh --seed
php artisan serve

# Flutter
cd jayq_app
flutter clean
flutter pub get
flutter run
```

### Clear App Data:

Di emulator/device:

1. Settings → Apps → JAYQ
2. Storage → Clear Data
3. Restart app

---

## 📞 Still Having Issues?

1. Check `storage/logs/laravel.log` di backend
2. Check Flutter console output
3. Test API dengan Postman
4. Verify network connectivity
5. Check firewall settings

---

## ✅ Success Indicators

Jika semua berjalan dengan baik, Anda akan melihat:

1. ✅ Backend running di http://127.0.0.1:8000
2. ✅ Test API berhasil (dart test_api.dart)
3. ✅ Login screen muncul di app
4. ✅ Setelah login, redirect ke dashboard sesuai role
5. ✅ Tidak ada error di console

---

**Happy Debugging! 🚀**
