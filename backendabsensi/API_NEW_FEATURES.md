# 🆕 API Documentation - New Features

Dokumentasi API untuk fitur-fitur baru yang ditambahkan ke sistem JAYQ.

---

## 📢 Pengumuman API

### 1. Get All Pengumuman (Filtered by Role)

**Endpoint:** `GET /api/pengumuman`

**Auth:** Required (Bearer Token)

**Description:** Mengambil semua pengumuman aktif yang sesuai dengan role user

**Response:**

```json
{
    "success": true,
    "message": "Data pengumuman berhasil diambil",
    "data": [
        {
            "id": 1,
            "judul": "Libur Nasional",
            "isi": "Kampus libur pada tanggal 17 Agustus 2026",
            "tipe": "penting",
            "target": "all",
            "is_active": true,
            "created_by": 1,
            "creator": {
                "id": 1,
                "name": "Admin",
                "email": "admin@jayq.com"
            },
            "created_at": "2026-05-22T10:00:00.000000Z",
            "updated_at": "2026-05-22T10:00:00.000000Z"
        }
    ]
}
```

---

### 2. Get All Pengumuman (Admin)

**Endpoint:** `GET /api/pengumuman/admin`

**Auth:** Required (Admin only)

**Description:** Mengambil semua pengumuman termasuk yang nonaktif

---

### 3. Create Pengumuman

**Endpoint:** `POST /api/pengumuman`

**Auth:** Required (Admin only)

**Request Body:**

```json
{
    "judul": "Judul Pengumuman",
    "isi": "Isi pengumuman lengkap",
    "tipe": "info",
    "target": "all"
}
```

**Validation:**

- `judul`: required, string, max 255
- `isi`: required, string
- `tipe`: required, enum (info, penting, urgent)
- `target`: required, enum (all, dosen, mahasiswa)

---

### 4. Update Pengumuman

**Endpoint:** `PUT /api/pengumuman/{id}`

**Auth:** Required (Admin only)

**Request Body:**

```json
{
    "judul": "Judul Baru",
    "isi": "Isi baru",
    "tipe": "urgent",
    "target": "mahasiswa",
    "is_active": false
}
```

---

### 5. Delete Pengumuman

**Endpoint:** `DELETE /api/pengumuman/{id}`

**Auth:** Required (Admin only)

---

### 6. Toggle Active Status

**Endpoint:** `POST /api/pengumuman/{id}/toggle-active`

**Auth:** Required (Admin only)

**Description:** Mengubah status aktif/nonaktif pengumuman

---

## 📥 Export Data API

### 1. Export Absensi

**Endpoint:** `GET /api/export/absensi`

**Auth:** Required (Admin only)

**Query Parameters:**

- `mata_kuliah_id` (optional): Filter by mata kuliah
- `start_date` (optional): Filter start date (YYYY-MM-DD)
- `end_date` (optional): Filter end date (YYYY-MM-DD)

**Response:**

```json
{
    "success": true,
    "message": "Data absensi berhasil diekspor",
    "data": {
        "csv": "base64_encoded_csv_data",
        "filename": "absensi_2026-05-22_143000.csv",
        "total_records": 150
    }
}
```

---

### 2. Export Rekap Mahasiswa

**Endpoint:** `GET /api/export/rekap-mahasiswa`

**Auth:** Required (Admin only)

**Query Parameters:**

- `mata_kuliah_id` (required): ID mata kuliah

**Description:** Export rekap kehadiran mahasiswa per mata kuliah

---

### 3. Export Data Mahasiswa

**Endpoint:** `GET /api/export/mahasiswa`

**Auth:** Required (Admin only)

**Description:** Export semua data mahasiswa

---

### 4. Export Data Dosen

**Endpoint:** `GET /api/export/dosen`

**Auth:** Required (Admin only)

**Description:** Export semua data dosen

---

### 5. Export Data Mata Kuliah

**Endpoint:** `GET /api/export/mata-kuliah`

**Auth:** Required (Admin only)

**Description:** Export semua data mata kuliah

---

## 🔑 User Management API (Updated)

### Reset Password User

**Endpoint:** `POST /api/users/{id}/reset-password`

**Auth:** Required (Admin only)

**Request Body:**

```json
{
    "new_password": "newpassword123"
}
```

**Validation:**

- `new_password`: required, string, min 6

**Response:**

```json
{
    "success": true,
    "message": "Password berhasil direset",
    "data": {
        "user_id": 5,
        "name": "John Doe",
        "email": "john@jayq.com"
    }
}
```

---

## 📈 Dashboard API (Updated)

### Get Advanced Statistics

**Endpoint:** `GET /api/admin/dashboard/advanced-stats`

**Auth:** Required (Admin only)

**Description:** Mengambil statistik lanjutan untuk dashboard admin

**Response:**

```json
{
    "success": true,
    "data": {
        "absensi_per_hari": [
            {
                "date": "2026-05-16",
                "day": "Fri",
                "count": 45
            },
            {
                "date": "2026-05-17",
                "day": "Sat",
                "count": 38
            }
        ],
        "absensi_per_mata_kuliah": [
            {
                "nama_mk": "Pemrograman Web",
                "total": 120
            },
            {
                "nama_mk": "Basis Data",
                "total": 98
            }
        ],
        "persentase_per_mata_kuliah": [
            {
                "mata_kuliah": "Pemrograman Web",
                "kode_mk": "TI101",
                "dosen": "Dr. Budi",
                "total_peserta": 40,
                "total_pertemuan": 8,
                "persentase_kehadiran": 85.5
            }
        ],
        "user_stats": {
            "admin": 2,
            "dosen": 15,
            "mahasiswa": 250
        },
        "recent_activities": [
            {
                "user": "Ahmad Fauzi",
                "mata_kuliah": "Pemrograman Web",
                "timestamp": "2026-05-22 14:30:00",
                "time_ago": "5 minutes ago"
            }
        ]
    }
}
```

---

## 📝 Notes

### CSV Format

File CSV yang di-export menggunakan encoding UTF-8 dan format standar:

- Delimiter: koma (,)
- Text qualifier: double quote (")
- Line ending: LF (\n)

### Base64 Encoding

Data CSV di-encode menggunakan base64 untuk transfer melalui API. Client harus decode base64 sebelum menyimpan file.

### File Storage

File export disimpan di folder `JAYQ_Exports` pada storage device:

- Android: `/storage/emulated/0/Android/data/com.jayq.app/files/JAYQ_Exports/`
- iOS: Application Documents Directory

---

## 🔐 Security

Semua endpoint baru menggunakan:

- Laravel Sanctum authentication
- Role-based middleware
- Input validation
- SQL injection prevention
- XSS protection

---

## 📊 Status Codes

- `200`: Success
- `201`: Created
- `400`: Bad Request
- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `422`: Validation Error
- `500`: Server Error

---

## 🧪 Testing

Untuk testing API, gunakan:

- Postman
- Insomnia
- Thunder Client (VS Code)

Import collection dari file `API_DOCUMENTATION.md` untuk endpoint lengkap.

---

**Last Updated:** May 22, 2026
**Version:** 1.1.0
