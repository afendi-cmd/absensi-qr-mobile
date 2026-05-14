# JAYQ - API Documentation

Backend REST API untuk aplikasi mobile absensi mahasiswa berbasis QR Code.

## Base URL

```
http://localhost:8000/api
```

## Authentication

API menggunakan Laravel Sanctum untuk authentication. Setelah login, gunakan token yang diterima pada header:

```
Authorization: Bearer {token}
```

---

## 📌 Authentication Endpoints

### 1. Login

**POST** `/login`

**Request Body:**

```json
{
    "email": "admin@jayq.com",
    "password": "password"
}
```

**Response Success (200):**

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

### 2. Logout

**POST** `/logout`

**Headers:** `Authorization: Bearer {token}`

**Response Success (200):**

```json
{
    "success": true,
    "message": "Logout berhasil"
}
```

### 3. Get Authenticated User

**GET** `/user`

**Headers:** `Authorization: Bearer {token}`

**Response Success (200):**

```json
{
    "success": true,
    "data": {
        "id": 1,
        "nama": "Admin JAYQ",
        "email": "admin@jayq.com",
        "role": "admin"
    }
}
```

---

## 👨‍💼 Admin Endpoints

### User Management

#### Get All Users

**GET** `/users?role={role}`

**Query Parameters:**

- `role` (optional): Filter by role (admin, dosen, mahasiswa)

**Response Success (200):**

```json
{
    "success": true,
    "message": "Data users berhasil diambil",
    "data": [
        {
            "id": 1,
            "nama": "Admin JAYQ",
            "email": "admin@jayq.com",
            "role": "admin",
            "created_at": "2026-05-14T07:15:59.000000Z"
        }
    ]
}
```

#### Create User

**POST** `/users`

**Request Body:**

```json
{
    "nama": "John Doe",
    "email": "john@jayq.com",
    "password": "password123",
    "role": "mahasiswa"
}
```

#### Update User

**PUT** `/users/{id}`

**Request Body:**

```json
{
    "nama": "John Doe Updated",
    "email": "john.updated@jayq.com",
    "password": "newpassword",
    "role": "dosen"
}
```

#### Delete User

**DELETE** `/users/{id}`

### Mata Kuliah Management

#### Get All Mata Kuliah

**GET** `/mata-kuliah`

#### Create Mata Kuliah

**POST** `/mata-kuliah`

**Request Body:**

```json
{
    "nama_mk": "Pemrograman Mobile",
    "kode_mk": "IF301",
    "dosen_id": 2
}
```

#### Update Mata Kuliah

**PUT** `/mata-kuliah/{id}`

#### Delete Mata Kuliah

**DELETE** `/mata-kuliah/{id}`

### Peserta Mata Kuliah Management

#### Add Mahasiswa to Mata Kuliah

**POST** `/peserta-mk`

**Request Body:**

```json
{
    "mahasiswa_id": 4,
    "mata_kuliah_id": 1
}
```

#### Remove Mahasiswa from Mata Kuliah

**DELETE** `/peserta-mk/{id}`

#### Get Peserta by Mata Kuliah

**GET** `/mata-kuliah/{id}/peserta`

#### Get All Absensi

**GET** `/absensi/all?mata_kuliah_id={id}&mahasiswa_id={id}&tanggal_mulai={date}&tanggal_selesai={date}`

---

## 👨‍🏫 Dosen Endpoints

### QR Code Management

#### Generate QR Code

**POST** `/generate-qr`

**Request Body:**

```json
{
    "mata_kuliah_id": 1,
    "duration": 15
}
```

**Response Success (201):**

```json
{
    "success": true,
    "message": "QR Code berhasil digenerate",
    "data": {
        "id": 1,
        "kode_qr": "abc123xyz456...",
        "mata_kuliah": {
            "id": 1,
            "nama_mk": "Pemrograman Mobile",
            "kode_mk": "IF301"
        },
        "expired_at": "2026-05-14 08:00:00",
        "duration_minutes": 15
    }
}
```

#### Get QR Sessions History

**GET** `/qr-sessions?mata_kuliah_id={id}&status={active|expired}`

### Absensi Management

#### Get Rekap Absensi

**GET** `/rekap-absensi?mata_kuliah_id={id}&tanggal_mulai={date}&tanggal_selesai={date}`

#### Get Absensi by Mata Kuliah

**GET** `/mata-kuliah/{id}/absensi`

### Tugas Management

#### Get All Tugas

**GET** `/tugas?mata_kuliah_id={id}`

#### Create Tugas

**POST** `/tugas`

**Request Body (multipart/form-data):**

```
mata_kuliah_id: 1
judul: "Tugas 1 - Membuat Aplikasi Mobile"
deskripsi: "Buat aplikasi mobile sederhana"
file_tugas: [file]
deadline: "2026-05-20 23:59:59"
```

#### Update Tugas

**PUT** `/tugas/{id}`

#### Delete Tugas

**DELETE** `/tugas/{id}`

#### Get Pengumpulan Tugas

**GET** `/tugas/{id}/pengumpulan`

#### Beri Nilai

**PUT** `/pengumpulan-tugas/{id}/nilai`

**Request Body:**

```json
{
    "nilai": 85,
    "catatan": "Bagus, tapi perlu perbaikan di bagian UI"
}
```

### Materi Management

#### Get All Materi

**GET** `/materi?mata_kuliah_id={id}`

#### Upload Materi

**POST** `/materi`

**Request Body (multipart/form-data):**

```
mata_kuliah_id: 1
judul: "Pengenalan Flutter"
deskripsi: "Materi dasar Flutter"
file_materi: [file]
```

#### Delete Materi

**DELETE** `/materi/{id}`

### Mata Kuliah Dosen

#### Get Mata Kuliah yang Diajar

**GET** `/mata-kuliah/dosen/me`

---

## 👨‍🎓 Mahasiswa Endpoints

### Absensi

#### Scan QR Code

**POST** `/scan-qr`

**Request Body:**

```json
{
    "kode_qr": "abc123xyz456...",
    "latitude": -6.2,
    "longitude": 106.816666
}
```

**Response Success (201):**

```json
{
    "success": true,
    "message": "Absensi berhasil",
    "data": {
        "id": 1,
        "mahasiswa_id": 4,
        "mata_kuliah_id": 1,
        "tanggal": "2026-05-14",
        "jam": "07:45:00",
        "status": "hadir",
        "mata_kuliah": {
            "id": 1,
            "nama_mk": "Pemrograman Mobile",
            "kode_mk": "IF301"
        }
    }
}
```

#### Get Riwayat Absensi

**GET** `/riwayat-absensi?mata_kuliah_id={id}&tanggal_mulai={date}&tanggal_selesai={date}`

### Tugas

#### Get Tugas Mahasiswa

**GET** `/tugas/mahasiswa/me?mata_kuliah_id={id}`

**Response includes `sudah_dikumpulkan` status**

#### Upload Tugas

**POST** `/upload-tugas`

**Request Body (multipart/form-data):**

```
tugas_id: 1
file_jawaban: [file]
```

#### Get Pengumpulan Tugas Mahasiswa

**GET** `/pengumpulan-tugas/me`

### Mata Kuliah

#### Get Mata Kuliah yang Diambil

**GET** `/mata-kuliah/mahasiswa/me`

### Materi

#### Get Materi Mahasiswa

**GET** `/materi/mahasiswa/me?mata_kuliah_id={id}`

---

## 📝 Response Format

### Success Response

```json
{
    "success": true,
    "message": "Operation successful",
    "data": {}
}
```

### Error Response

```json
{
    "success": false,
    "message": "Error message"
}
```

### Validation Error Response

```json
{
    "success": false,
    "message": "Validation error",
    "errors": {
        "field_name": ["Error message"]
    }
}
```

---

## 🔐 Default Login Credentials

### Admin

- Email: `admin@jayq.com`
- Password: `password`

### Dosen

- Email: `budi@jayq.com` / `siti@jayq.com`
- Password: `password`

### Mahasiswa

- Email: `ahmad@jayq.com` / `dewi@jayq.com` / `eko@jayq.com`
- Password: `password`

---

## 📁 File Upload

### Supported File Types

- **Tugas**: PDF, DOC, DOCX (max 10MB)
- **Materi**: PDF, DOC, DOCX, PPT, PPTX (max 20MB)

### File Storage

Files are stored in `storage/app/public/` directory:

- Tugas: `storage/app/public/tugas/`
- Pengumpulan Tugas: `storage/app/public/pengumpulan_tugas/`
- Materi: `storage/app/public/materi/`

### Access Files

Files can be accessed via:

```
http://localhost:8000/storage/{path}
```

Example:

```
http://localhost:8000/storage/tugas/1715673959_assignment.pdf
```

---

## 🚀 Running the Application

1. **Install Dependencies**

```bash
composer install
```

2. **Setup Environment**

```bash
cp .env.example .env
php artisan key:generate
```

3. **Configure Database** (in `.env`)

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=absensi_qr_mobile
DB_USERNAME=root
DB_PASSWORD=
```

4. **Run Migrations & Seeders**

```bash
php artisan migrate:fresh --seed
```

5. **Create Storage Link**

```bash
php artisan storage:link
```

6. **Start Server**

```bash
php artisan serve
```

API will be available at: `http://localhost:8000/api`

---

## 📱 Testing with Postman

1. Import the API endpoints to Postman
2. Login first to get the token
3. Set the token in Authorization header for protected routes
4. Test all endpoints according to your role

---

## 🛠️ Tech Stack

- **Framework**: Laravel 13
- **Authentication**: Laravel Sanctum
- **Database**: MySQL
- **File Storage**: Local Storage (public disk)
- **API Format**: JSON REST API

---

## 📞 Support

For any issues or questions, please contact the development team.
