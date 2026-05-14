# JAYQ - Backend REST API

Backend REST API untuk aplikasi mobile absensi mahasiswa berbasis QR Code menggunakan Laravel 13 dan MySQL.

## 🎯 Fitur Utama

### 👨‍💼 Admin

- ✅ CRUD User (Admin, Dosen, Mahasiswa)
- ✅ CRUD Mata Kuliah
- ✅ Menentukan dosen pengajar
- ✅ Mengelola peserta mata kuliah
- ✅ Melihat seluruh absensi

### 👨‍🏫 Dosen

- ✅ Generate QR Code untuk absensi
- ✅ Melihat rekap absensi mahasiswa
- ✅ Membuat dan mengelola tugas
- ✅ Upload materi pembelajaran
- ✅ Memberikan nilai tugas
- ✅ Melihat peserta mata kuliah

### 👨‍🎓 Mahasiswa

- ✅ Scan QR Code untuk absensi
- ✅ Melihat riwayat absensi
- ✅ Upload tugas
- ✅ Melihat mata kuliah yang diambil
- ✅ Download materi pembelajaran

## 🛠️ Tech Stack

- **Framework**: Laravel 13
- **Authentication**: Laravel Sanctum (Token-based)
- **Database**: MySQL
- **API Format**: JSON REST API
- **File Storage**: Local Storage (public disk)

## 📋 Requirements

- PHP >= 8.3
- Composer
- MySQL
- Laravel 13

## 🚀 Installation

### 1. Clone Repository

```bash
git clone <repository-url>
cd backendabsensi
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
DB_PASSWORD=
```

### 5. Run Migrations & Seeders

```bash
php artisan migrate:fresh --seed
```

### 6. Create Storage Link

```bash
php artisan storage:link
```

### 8. Start Development Server

```bash
php artisan serve
```

API akan berjalan di: `http://localhost:8000/api`

## 🔐 Default Login Credentials

Setelah menjalankan seeder, gunakan credentials berikut:

### Admin

- Email: `admin@jayq.com`
- Password: `password`

### Dosen

- Email: `budi@jayq.com`
- Password: `password`

- Email: `siti@jayq.com`
- Password: `password`

### Mahasiswa

- Email: `ahmad@jayq.com`
- Password: `password`

- Email: `dewi@jayq.com`
- Password: `password`

- Email: `eko@jayq.com`
- Password: `password`

## 📚 Database Structure

### Tables

1. **users** - Menyimpan data user (admin, dosen, mahasiswa)
2. **mata_kuliah** - Menyimpan data mata kuliah
3. **peserta_mk** - Relasi many-to-many mahasiswa dan mata kuliah
4. **qr_sessions** - Menyimpan QR code aktif untuk absensi
5. **absensi** - Menyimpan data kehadiran mahasiswa
6. **tugas** - Menyimpan data tugas
7. **pengumpulan_tugas** - Menyimpan pengumpulan tugas mahasiswa
8. **materi** - Menyimpan materi pembelajaran

### Relasi

- User (Dosen) → hasMany → Mata Kuliah
- Mata Kuliah → belongsToMany → User (Mahasiswa) through peserta_mk
- Mata Kuliah → hasMany → QR Sessions
- Mata Kuliah → hasMany → Absensi
- Mata Kuliah → hasMany → Tugas
- Mata Kuliah → hasMany → Materi
- Tugas → hasMany → Pengumpulan Tugas

## 📖 API Documentation

Lihat dokumentasi lengkap API di [API_DOCUMENTATION.md](API_DOCUMENTATION.md)

### Base URL

```
http://localhost:8000/api
```

### Authentication

Gunakan Bearer Token pada header:

```
Authorization: Bearer {token}
```

### Contoh Request Login

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "admin@jayq.com",
    "password": "password"
  }'
```

### Response Format

```json
{
    "success": true,
    "message": "Operation successful",
    "data": {}
}
```

## 📁 Project Structure

```
backendabsensi/
├── app/
│   ├── Http/
│   │   ├── Controllers/
│   │   │   └── Api/
│   │   │       ├── AuthController.php
│   │   │       ├── UserController.php
│   │   │       ├── MataKuliahController.php
│   │   │       ├── PesertaMkController.php
│   │   │       ├── QrController.php
│   │   │       ├── AbsensiController.php
│   │   │       ├── TugasController.php
│   │   │       └── MateriController.php
│   │   └── Middleware/
│   │       └── RoleMiddleware.php
│   └── Models/
│       ├── User.php
│       ├── MataKuliah.php
│       ├── PesertaMk.php
│       ├── QrSession.php
│       ├── Absensi.php
│       ├── Tugas.php
│       ├── PengumpulanTugas.php
│       └── Materi.php
├── database/
│   ├── migrations/
│   └── seeders/
│       └── DatabaseSeeder.php
├── routes/
│   └── api.php
└── storage/
    └── app/
        └── public/
            ├── tugas/
            ├── pengumpulan_tugas/
            └── materi/
```

## 🔒 Security Features

- ✅ Password hashing dengan bcrypt
- ✅ Token-based authentication (Sanctum)
- ✅ Role-based access control (Middleware)
- ✅ Request validation
- ✅ CSRF protection
- ✅ SQL injection protection (Eloquent ORM)

## 📝 API Endpoints Summary

### Authentication

- `POST /api/login` - Login
- `POST /api/logout` - Logout
- `GET /api/user` - Get authenticated user

### Admin (Role: admin)

- User Management: `/api/users`
- Mata Kuliah: `/api/mata-kuliah`
- Peserta MK: `/api/peserta-mk`
- All Absensi: `/api/absensi/all`

### Dosen (Role: dosen)

- Generate QR: `/api/generate-qr`
- QR Sessions: `/api/qr-sessions`
- Rekap Absensi: `/api/rekap-absensi`
- Tugas: `/api/tugas`
- Materi: `/api/materi`
- Mata Kuliah Dosen: `/api/mata-kuliah/dosen/me`

### Mahasiswa (Role: mahasiswa)

- Scan QR: `/api/scan-qr`
- Riwayat Absensi: `/api/riwayat-absensi`
- Upload Tugas: `/api/upload-tugas`
- Tugas Mahasiswa: `/api/tugas/mahasiswa/me`
- Mata Kuliah Mahasiswa: `/api/mata-kuliah/mahasiswa/me`
- Materi Mahasiswa: `/api/materi/mahasiswa/me`

## 🧪 Testing

### Manual Testing dengan Postman

1. Import API endpoints ke Postman
2. Login untuk mendapatkan token
3. Set token di Authorization header
4. Test semua endpoints sesuai role

### Testing Flow

1. **Login** sebagai admin/dosen/mahasiswa
2. **Admin**: Buat user, mata kuliah, assign peserta
3. **Dosen**: Generate QR, buat tugas, upload materi
4. **Mahasiswa**: Scan QR, upload tugas, lihat materi

## 📱 Integration dengan Flutter

Backend ini siap diintegrasikan dengan aplikasi Flutter mobile. Pastikan:

1. Base URL sesuai dengan server
2. Implementasi HTTP client (Dio/http)
3. Token management untuk authentication
4. File upload untuk tugas dan materi
5. QR Code scanner untuk absensi

## 🐛 Troubleshooting

### Error: Storage link not found

```bash
php artisan storage:link
```

### Error: Migration failed

```bash
php artisan migrate:fresh --seed
```

### Error: Permission denied (storage)

```bash
chmod -R 775 storage
chmod -R 775 bootstrap/cache
```

## 📞 Support

Untuk pertanyaan atau issue, silakan hubungi tim development.

## 📄 License

This project is open-sourced software licensed under the MIT license.

---

**Developed with ❤️ for JAYQ Mobile App**
