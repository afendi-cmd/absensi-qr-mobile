# 🚀 Quick Start Guide - JAYQ Backend API

Panduan cepat untuk menjalankan backend JAYQ dalam 5 menit!

## ⚡ Prerequisites

Pastikan sudah terinstall:

- ✅ PHP 8.3 atau lebih tinggi
- ✅ Composer
- ✅ MySQL
- ✅ Git (optional)

## 📦 Installation Steps

### 1. Setup Database

Buat database MySQL baru:

```sql
CREATE DATABASE absensi_qr_mobile;
```

### 2. Install Dependencies

```bash
composer install
```

### 3. Setup Environment

```bash
cp .env.example .env
php artisan key:generate
```

### 4. Configure Database

Edit file `.env`:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=absensi_qr_mobile
DB_USERNAME=root
DB_PASSWORD=your_password
```

### 5. Run Migrations & Seeders

```bash
php artisan migrate:fresh --seed
```

### 6. Create Storage Link

```bash
php artisan storage:link
```

### 7. Start Server

```bash
php artisan serve
```

Server akan berjalan di: **http://localhost:8000**

## 🎯 Test API

### Test dengan cURL

#### 1. Login sebagai Admin

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"admin@jayq.com\",\"password\":\"password\"}"
```

**Response:**

```json
{
    "success": true,
    "message": "Login berhasil",
    "data": {
        "token": "1|abc123...",
        "user": {
            "id": 1,
            "nama": "Admin JAYQ",
            "email": "admin@jayq.com",
            "role": "admin"
        }
    }
}
```

#### 2. Get All Users (gunakan token dari login)

```bash
curl -X GET http://localhost:8000/api/users \
  -H "Authorization: Bearer YOUR_TOKEN_HERE"
```

#### 3. Login sebagai Dosen

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"budi@jayq.com\",\"password\":\"password\"}"
```

#### 4. Generate QR Code (sebagai Dosen)

```bash
curl -X POST http://localhost:8000/api/generate-qr \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d "{\"mata_kuliah_id\":1,\"duration\":15}"
```

#### 5. Login sebagai Mahasiswa

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"ahmad@jayq.com\",\"password\":\"password\"}"
```

#### 6. Scan QR Code (sebagai Mahasiswa)

```bash
curl -X POST http://localhost:8000/api/scan-qr \
  -H "Authorization: Bearer YOUR_TOKEN_HERE" \
  -H "Content-Type: application/json" \
  -d "{\"kode_qr\":\"QR_CODE_FROM_STEP_4\",\"latitude\":-6.200000,\"longitude\":106.816666}"
```

## 📱 Test dengan Postman

1. Import file `JAYQ_Postman_Collection.json` ke Postman
2. Jalankan request "Login" di folder "Authentication"
3. Token akan otomatis tersimpan di collection variable
4. Test endpoint lainnya sesuai role

## 🔐 Default Credentials

### Admin

- **Email**: admin@jayq.com
- **Password**: password

### Dosen

- **Email**: budi@jayq.com
- **Password**: password
- **Email**: siti@jayq.com
- **Password**: password

### Mahasiswa

- **Email**: ahmad@jayq.com
- **Password**: password
- **Email**: dewi@jayq.com
- **Password**: password
- **Email**: eko@jayq.com
- **Password**: password

## 📊 Sample Data

Setelah seeder berjalan, database akan berisi:

- ✅ 1 Admin
- ✅ 2 Dosen
- ✅ 3 Mahasiswa
- ✅ 3 Mata Kuliah
- ✅ Peserta mata kuliah sudah di-assign

## 🔍 Verify Installation

### Check Routes

```bash
php artisan route:list --path=api
```

### Check Database

```bash
php artisan db:show
php artisan db:table users
```

### Check Storage Link

```bash
ls -la public/storage
```

## 🎬 Complete Testing Flow

### 1. Admin Flow

```bash
# Login as admin
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"admin@jayq.com\",\"password\":\"password\"}"

# Get all users
curl -X GET http://localhost:8000/api/users \
  -H "Authorization: Bearer YOUR_TOKEN"

# Get all mata kuliah
curl -X GET http://localhost:8000/api/mata-kuliah \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 2. Dosen Flow

```bash
# Login as dosen
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"budi@jayq.com\",\"password\":\"password\"}"

# Get mata kuliah yang diajar
curl -X GET http://localhost:8000/api/mata-kuliah/dosen/me \
  -H "Authorization: Bearer YOUR_TOKEN"

# Generate QR
curl -X POST http://localhost:8000/api/generate-qr \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"mata_kuliah_id\":1,\"duration\":15}"

# Get rekap absensi
curl -X GET http://localhost:8000/api/rekap-absensi \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 3. Mahasiswa Flow

```bash
# Login as mahasiswa
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"ahmad@jayq.com\",\"password\":\"password\"}"

# Get mata kuliah yang diambil
curl -X GET http://localhost:8000/api/mata-kuliah/mahasiswa/me \
  -H "Authorization: Bearer YOUR_TOKEN"

# Scan QR (gunakan kode_qr dari generate QR)
curl -X POST http://localhost:8000/api/scan-qr \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"kode_qr\":\"YOUR_QR_CODE\",\"latitude\":-6.200000,\"longitude\":106.816666}"

# Get riwayat absensi
curl -X GET http://localhost:8000/api/riwayat-absensi \
  -H "Authorization: Bearer YOUR_TOKEN"
```

## 🐛 Troubleshooting

### Error: "SQLSTATE[HY000] [1045] Access denied"

**Solution**: Periksa username dan password MySQL di file `.env`

### Error: "Storage link not found"

**Solution**:

```bash
php artisan storage:link
```

### Error: "Class not found"

**Solution**:

```bash
composer dump-autoload
```

### Error: "Migration failed"

**Solution**:

```bash
php artisan migrate:fresh --seed
```

### Port 8000 already in use

**Solution**:

```bash
php artisan serve --port=8001
```

## 📚 Next Steps

1. ✅ Baca dokumentasi lengkap di `API_DOCUMENTATION.md`
2. ✅ Import Postman collection untuk testing
3. ✅ Integrasikan dengan Flutter mobile app
4. ✅ Customize sesuai kebutuhan

## 🎉 Success!

Jika semua langkah berhasil, backend API JAYQ sudah siap digunakan!

**API Base URL**: http://localhost:8000/api

Selamat mengembangkan aplikasi! 🚀
