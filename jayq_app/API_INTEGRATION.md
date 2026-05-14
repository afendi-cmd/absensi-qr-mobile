# API Integration Guide

Dokumentasi integrasi aplikasi JAYQ Flutter dengan Laravel Backend.

## 🔗 Base URL

```
Development: http://localhost:8000/api
Production: https://your-domain.com/api
```

## 🔐 Authentication

Aplikasi menggunakan **Bearer Token Authentication**.

### Headers

```
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
```

## 📡 API Endpoints

### Authentication

#### 1. Login

```
POST /login
```

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
  "message": "Login successful",
  "token": "eyJ0eXAiOiJKV1QiLCJhbGc...",
  "user": {
    "id": 1,
    "name": "Admin User",
    "email": "admin@jayq.com",
    "role": "admin",
    "nip": null,
    "nim": null,
    "photo_url": null,
    "phone": null,
    "created_at": "2026-05-14T10:00:00.000000Z"
  }
}
```

**Response Error (401):**

```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

#### 2. Logout

```
POST /logout
Headers: Authorization: Bearer {token}
```

**Response:**

```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

#### 3. Get Current User

```
GET /user
Headers: Authorization: Bearer {token}
```

**Response:**

```json
{
  "id": 1,
  "name": "Admin User",
  "email": "admin@jayq.com",
  "role": "admin"
}
```

### Mata Kuliah

#### 1. Get All Mata Kuliah

```
GET /mata-kuliah
Headers: Authorization: Bearer {token}
```

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "kode_mk": "IF101",
      "nama_mk": "Pemrograman Mobile",
      "sks": 3,
      "semester": "Genap 2025/2026",
      "dosen_id": 2,
      "dosen_name": "Dr. Ahmad",
      "jumlah_peserta": 30,
      "created_at": "2026-05-14T10:00:00.000000Z"
    }
  ]
}
```

#### 2. Get Mata Kuliah by ID

```
GET /mata-kuliah/{id}
Headers: Authorization: Bearer {token}
```

#### 3. Create Mata Kuliah (Admin only)

```
POST /mata-kuliah
Headers: Authorization: Bearer {token}
```

**Request Body:**

```json
{
  "kode_mk": "IF101",
  "nama_mk": "Pemrograman Mobile",
  "sks": 3,
  "semester": "Genap 2025/2026",
  "dosen_id": 2
}
```

#### 4. Update Mata Kuliah (Admin only)

```
PUT /mata-kuliah/{id}
Headers: Authorization: Bearer {token}
```

#### 5. Delete Mata Kuliah (Admin only)

```
DELETE /mata-kuliah/{id}
Headers: Authorization: Bearer {token}
```

### QR Code

#### 1. Generate QR Code (Dosen only)

```
POST /qr/generate
Headers: Authorization: Bearer {token}
```

**Request Body:**

```json
{
  "mata_kuliah_id": 1,
  "expired_at": "2026-05-14T11:00:00"
}
```

**Response:**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "qr_code": "QR_SESSION_123456",
    "mata_kuliah_id": 1,
    "expired_at": "2026-05-14T11:00:00",
    "is_active": true
  }
}
```

#### 2. Validate QR Code (Mahasiswa only)

```
POST /qr/validate
Headers: Authorization: Bearer {token}
```

**Request Body:**

```json
{
  "qr_code": "QR_SESSION_123456"
}
```

**Response Success:**

```json
{
  "success": true,
  "message": "Absensi berhasil",
  "data": {
    "id": 1,
    "mahasiswa_id": 3,
    "mata_kuliah_id": 1,
    "status": "hadir",
    "waktu_absen": "2026-05-14T10:30:00"
  }
}
```

**Response Error:**

```json
{
  "success": false,
  "message": "QR Code expired atau tidak valid"
}
```

### Absensi

#### 1. Get Absensi by Mata Kuliah

```
GET /absensi/mata-kuliah/{id}
Headers: Authorization: Bearer {token}
Query: ?date=2026-05-14
```

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "mahasiswa_id": 3,
      "mahasiswa_name": "John Doe",
      "mahasiswa_nim": "123456",
      "mata_kuliah_id": 1,
      "status": "hadir",
      "waktu_absen": "2026-05-14T10:30:00"
    }
  ]
}
```

#### 2. Get Riwayat Absensi Mahasiswa

```
GET /absensi/mahasiswa
Headers: Authorization: Bearer {token}
Query: ?mata_kuliah_id=1
```

#### 3. Get Rekap Absensi

```
GET /absensi/rekap
Headers: Authorization: Bearer {token}
Query: ?mata_kuliah_id=1&start_date=2026-05-01&end_date=2026-05-31
```

### Tugas

#### 1. Get All Tugas

```
GET /tugas
Headers: Authorization: Bearer {token}
Query: ?mata_kuliah_id=1
```

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "mata_kuliah_id": 1,
      "judul": "Tugas UTS",
      "deskripsi": "Buat aplikasi mobile sederhana",
      "deadline": "2026-05-20T23:59:59",
      "file_url": "http://localhost:8000/storage/tugas/file.pdf",
      "is_submitted": false,
      "created_at": "2026-05-14T10:00:00"
    }
  ]
}
```

#### 2. Create Tugas (Dosen only)

```
POST /tugas
Headers: Authorization: Bearer {token}
Content-Type: multipart/form-data
```

**Request Body (Form Data):**

```
mata_kuliah_id: 1
judul: Tugas UTS
deskripsi: Buat aplikasi mobile sederhana
deadline: 2026-05-20T23:59:59
file: [file upload]
```

#### 3. Submit Tugas (Mahasiswa only)

```
POST /tugas/{id}/submit
Headers: Authorization: Bearer {token}
Content-Type: multipart/form-data
```

**Request Body:**

```
file: [file upload]
keterangan: Tugas sudah selesai
```

### Materi

#### 1. Get All Materi

```
GET /materi
Headers: Authorization: Bearer {token}
Query: ?mata_kuliah_id=1
```

**Response:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "mata_kuliah_id": 1,
      "judul": "Pengenalan Flutter",
      "deskripsi": "Materi dasar Flutter",
      "file_url": "http://localhost:8000/storage/materi/flutter.pdf",
      "created_at": "2026-05-14T10:00:00"
    }
  ]
}
```

#### 2. Upload Materi (Dosen only)

```
POST /materi
Headers: Authorization: Bearer {token}
Content-Type: multipart/form-data
```

**Request Body:**

```
mata_kuliah_id: 1
judul: Pengenalan Flutter
deskripsi: Materi dasar Flutter
file: [file upload]
```

### Users (Admin only)

#### 1. Get All Users

```
GET /users
Headers: Authorization: Bearer {token}
Query: ?role=mahasiswa&search=john
```

#### 2. Create User

```
POST /users
Headers: Authorization: Bearer {token}
```

**Request Body:**

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "password",
  "role": "mahasiswa",
  "nim": "123456"
}
```

#### 3. Update User

```
PUT /users/{id}
Headers: Authorization: Bearer {token}
```

#### 4. Delete User

```
DELETE /users/{id}
Headers: Authorization: Bearer {token}
```

## 📝 Implementation in Flutter

### 1. Setup API Service

File: `lib/data/services/api_service.dart`

```dart
final response = await apiService.get('/mata-kuliah');
```

### 2. Handle Response

```dart
try {
  final response = await apiService.post('/login', {
    'email': email,
    'password': password,
  });

  if (response['success']) {
    // Handle success
    final token = response['token'];
    final user = UserModel.fromJson(response['user']);
  }
} catch (e) {
  // Handle error
  print('Error: $e');
}
```

### 3. Upload File

```dart
final file = File(filePath);
final response = await apiService.uploadFile(
  '/tugas',
  file,
  fields: {
    'mata_kuliah_id': '1',
    'judul': 'Tugas UTS',
  },
);
```

## 🔄 Error Handling

### HTTP Status Codes

- **200**: Success
- **201**: Created
- **400**: Bad Request
- **401**: Unauthorized (token invalid/expired)
- **403**: Forbidden (no permission)
- **404**: Not Found
- **422**: Validation Error
- **500**: Server Error

### Error Response Format

```json
{
  "success": false,
  "message": "Error message here",
  "errors": {
    "email": ["Email is required"],
    "password": ["Password must be at least 6 characters"]
  }
}
```

## 🔒 Security Best Practices

1. **Always use HTTPS in production**
2. **Store token securely** (FlutterSecureStorage)
3. **Validate input** before sending to API
4. **Handle token expiration** gracefully
5. **Don't log sensitive data**
6. **Implement request timeout**
7. **Use proper error handling**

## 🧪 Testing API

### Using Postman

1. Import Postman collection: `JAYQ_Postman_Collection.json`
2. Set environment variables:
   - `base_url`: http://localhost:8000/api
   - `token`: (will be set after login)
3. Test all endpoints

### Using Flutter

```dart
// Test in main.dart or test file
void testApi() async {
  final apiService = ApiService();

  try {
    final response = await apiService.post('/login', {
      'email': 'admin@jayq.com',
      'password': 'password',
    });
    print('Success: $response');
  } catch (e) {
    print('Error: $e');
  }
}
```

## 📊 Response Examples

### Success Response

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

### Error Response

```json
{
  "success": false,
  "message": "Operation failed",
  "errors": { ... }
}
```

### Pagination Response

```json
{
  "success": true,
  "data": [ ... ],
  "meta": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 20,
    "total": 100
  }
}
```

## 🚀 Performance Tips

1. **Cache responses** when appropriate
2. **Use pagination** for large datasets
3. **Implement retry logic** for failed requests
4. **Show loading states** during API calls
5. **Handle offline scenarios**
6. **Optimize image uploads** (compress before upload)

## 📱 Platform-Specific Notes

### Android

- Use `10.0.2.2` instead of `localhost` for emulator
- Enable cleartext traffic for HTTP (development only)

### iOS

- Add App Transport Security exception for HTTP
- Request permissions for camera and storage

---

**Note:** Pastikan backend Laravel sudah running sebelum testing API dari Flutter.
