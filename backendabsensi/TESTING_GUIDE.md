# 🧪 Testing Guide - JAYQ Backend API

Panduan lengkap untuk testing backend JAYQ API.

## 📋 Table of Contents

1. [Prerequisites](#prerequisites)
2. [Setup Testing Environment](#setup-testing-environment)
3. [Testing with Postman](#testing-with-postman)
4. [Testing with cURL](#testing-with-curl)
5. [Testing Scenarios](#testing-scenarios)
6. [Common Issues](#common-issues)

## Prerequisites

- ✅ Backend server running (`php artisan serve`)
- ✅ Database migrated and seeded
- ✅ Postman installed (optional)
- ✅ cURL available (for command line testing)

## Setup Testing Environment

### 1. Start the Server

```bash
php artisan serve
```

Server akan berjalan di: `http://localhost:8000`

### 2. Verify Server is Running

```bash
curl http://localhost:8000/api/user
```

Expected response: `401 Unauthorized` (karena belum login)

## Testing with Postman

### Import Collection

1. Open Postman
2. Click **Import**
3. Select file `JAYQ_Postman_Collection.json`
4. Collection akan muncul di sidebar

### Set Base URL

Collection sudah include variable:

- `base_url`: `http://localhost:8000/api`
- `token`: (akan diisi otomatis setelah login)

### Testing Flow

#### 1. Authentication Test

**Login as Admin:**

1. Open folder "Authentication"
2. Select "Login" request
3. Body sudah terisi:

```json
{
    "email": "admin@jayq.com",
    "password": "password"
}
```

4. Click **Send**
5. Token akan otomatis tersimpan di collection variable

**Expected Response (200):**

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

#### 2. Admin Tests

**Get All Users:**

1. Open "Admin - User Management" folder
2. Select "Get All Users"
3. Click **Send**

**Create User:**

1. Select "Create User"
2. Modify body if needed
3. Click **Send**

**Get All Mata Kuliah:**

1. Open "Admin - Mata Kuliah" folder
2. Select "Get All Mata Kuliah"
3. Click **Send**

#### 3. Dosen Tests

**Login as Dosen:**

1. Go back to "Authentication" > "Login"
2. Change email to `budi@jayq.com`
3. Click **Send**

**Generate QR Code:**

1. Open "Dosen - QR Code" folder
2. Select "Generate QR"
3. Body:

```json
{
    "mata_kuliah_id": 1,
    "duration": 15
}
```

4. Click **Send**
5. **Copy the `kode_qr` from response** (needed for mahasiswa test)

**Get Rekap Absensi:**

1. Open "Dosen - Absensi" folder
2. Select "Get Rekap Absensi"
3. Click **Send**

#### 4. Mahasiswa Tests

**Login as Mahasiswa:**

1. Go back to "Authentication" > "Login"
2. Change email to `ahmad@jayq.com`
3. Click **Send**

**Scan QR Code:**

1. Open "Mahasiswa - Absensi" folder
2. Select "Scan QR"
3. Body (paste kode_qr from dosen's generate QR):

```json
{
    "kode_qr": "PASTE_QR_CODE_HERE",
    "latitude": -6.2,
    "longitude": 106.816666
}
```

4. Click **Send**

**Get Riwayat Absensi:**

1. Select "Get Riwayat Absensi"
2. Click **Send**

## Testing with cURL

### 1. Authentication

**Login:**

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@jayq.com","password":"password"}'
```

**Save the token from response:**

```bash
TOKEN="paste_your_token_here"
```

### 2. Admin Endpoints

**Get All Users:**

```bash
curl -X GET http://localhost:8000/api/users \
  -H "Authorization: Bearer $TOKEN"
```

**Create User:**

```bash
curl -X POST http://localhost:8000/api/users \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "nama": "Test User",
    "email": "test@jayq.com",
    "password": "password",
    "role": "mahasiswa"
  }'
```

**Get All Mata Kuliah:**

```bash
curl -X GET http://localhost:8000/api/mata-kuliah \
  -H "Authorization: Bearer $TOKEN"
```

**Create Mata Kuliah:**

```bash
curl -X POST http://localhost:8000/api/mata-kuliah \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "nama_mk": "Test Mata Kuliah",
    "kode_mk": "TEST01",
    "dosen_id": 2
  }'
```

**Add Mahasiswa to Mata Kuliah:**

```bash
curl -X POST http://localhost:8000/api/peserta-mk \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "mahasiswa_id": 4,
    "mata_kuliah_id": 1
  }'
```

### 3. Dosen Endpoints

**Login as Dosen:**

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"budi@jayq.com","password":"password"}'
```

**Generate QR:**

```bash
curl -X POST http://localhost:8000/api/generate-qr \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "mata_kuliah_id": 1,
    "duration": 15
  }'
```

**Get QR Sessions:**

```bash
curl -X GET http://localhost:8000/api/qr-sessions \
  -H "Authorization: Bearer $TOKEN"
```

**Get Rekap Absensi:**

```bash
curl -X GET http://localhost:8000/api/rekap-absensi \
  -H "Authorization: Bearer $TOKEN"
```

**Create Tugas (with file):**

```bash
curl -X POST http://localhost:8000/api/tugas \
  -H "Authorization: Bearer $TOKEN" \
  -F "mata_kuliah_id=1" \
  -F "judul=Tugas 1" \
  -F "deskripsi=Deskripsi tugas" \
  -F "deadline=2026-05-20 23:59:59" \
  -F "file_tugas=@/path/to/file.pdf"
```

### 4. Mahasiswa Endpoints

**Login as Mahasiswa:**

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ahmad@jayq.com","password":"password"}'
```

**Scan QR:**

```bash
curl -X POST http://localhost:8000/api/scan-qr \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "kode_qr": "YOUR_QR_CODE_HERE",
    "latitude": -6.200000,
    "longitude": 106.816666
  }'
```

**Get Riwayat Absensi:**

```bash
curl -X GET http://localhost:8000/api/riwayat-absensi \
  -H "Authorization: Bearer $TOKEN"
```

**Get Mata Kuliah Mahasiswa:**

```bash
curl -X GET http://localhost:8000/api/mata-kuliah/mahasiswa/me \
  -H "Authorization: Bearer $TOKEN"
```

**Upload Tugas:**

```bash
curl -X POST http://localhost:8000/api/upload-tugas \
  -H "Authorization: Bearer $TOKEN" \
  -F "tugas_id=1" \
  -F "file_jawaban=@/path/to/answer.pdf"
```

## Testing Scenarios

### Scenario 1: Complete Attendance Flow

**Objective:** Test complete attendance process from QR generation to scanning

**Steps:**

1. **Admin creates mata kuliah and assigns students**

```bash
# Login as admin
TOKEN_ADMIN=$(curl -s -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@jayq.com","password":"password"}' \
  | jq -r '.data.token')

# Verify mata kuliah exists
curl -X GET http://localhost:8000/api/mata-kuliah \
  -H "Authorization: Bearer $TOKEN_ADMIN"
```

2. **Dosen generates QR code**

```bash
# Login as dosen
TOKEN_DOSEN=$(curl -s -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"budi@jayq.com","password":"password"}' \
  | jq -r '.data.token')

# Generate QR
QR_CODE=$(curl -s -X POST http://localhost:8000/api/generate-qr \
  -H "Authorization: Bearer $TOKEN_DOSEN" \
  -H "Content-Type: application/json" \
  -d '{"mata_kuliah_id":1,"duration":15}' \
  | jq -r '.data.kode_qr')

echo "QR Code: $QR_CODE"
```

3. **Mahasiswa scans QR code**

```bash
# Login as mahasiswa
TOKEN_MHS=$(curl -s -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"ahmad@jayq.com","password":"password"}' \
  | jq -r '.data.token')

# Scan QR
curl -X POST http://localhost:8000/api/scan-qr \
  -H "Authorization: Bearer $TOKEN_MHS" \
  -H "Content-Type: application/json" \
  -d "{\"kode_qr\":\"$QR_CODE\",\"latitude\":-6.200000,\"longitude\":106.816666}"
```

4. **Verify attendance recorded**

```bash
# Mahasiswa checks history
curl -X GET http://localhost:8000/api/riwayat-absensi \
  -H "Authorization: Bearer $TOKEN_MHS"

# Dosen checks recap
curl -X GET http://localhost:8000/api/rekap-absensi \
  -H "Authorization: Bearer $TOKEN_DOSEN"
```

### Scenario 2: Assignment Submission Flow

**Objective:** Test assignment creation and submission

**Steps:**

1. **Dosen creates assignment**
2. **Mahasiswa views assignments**
3. **Mahasiswa submits assignment**
4. **Dosen views submissions**
5. **Dosen gives grade**

### Scenario 3: Error Handling Tests

**Test Invalid Login:**

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"wrong@email.com","password":"wrong"}'
```

**Expected:** 401 Unauthorized

**Test Expired QR:**

```bash
# Use old QR code (expired)
curl -X POST http://localhost:8000/api/scan-qr \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"kode_qr":"expired_qr_code","latitude":-6.200000,"longitude":106.816666}'
```

**Expected:** 422 Validation Error

**Test Duplicate Attendance:**

```bash
# Scan same QR twice
curl -X POST http://localhost:8000/api/scan-qr \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"kode_qr\":\"$QR_CODE\",\"latitude\":-6.200000,\"longitude\":106.816666}"
```

**Expected:** 422 - Already attended

**Test Unauthorized Access:**

```bash
# Mahasiswa tries to access admin endpoint
curl -X GET http://localhost:8000/api/users \
  -H "Authorization: Bearer $TOKEN_MAHASISWA"
```

**Expected:** 403 Forbidden

## Common Issues

### Issue 1: Token Not Working

**Problem:** Getting 401 Unauthorized even with token

**Solution:**

- Check token is correctly copied
- Verify token hasn't expired
- Login again to get new token

### Issue 2: QR Code Expired

**Problem:** "QR Code sudah expired"

**Solution:**

- Generate new QR code
- Increase duration when generating

### Issue 3: File Upload Failed

**Problem:** File upload returns validation error

**Solution:**

- Check file type (must be PDF, DOC, DOCX)
- Check file size (max 10MB for tugas, 20MB for materi)
- Use correct form field name

### Issue 4: Database Connection Error

**Problem:** "SQLSTATE[HY000] [2002] Connection refused"

**Solution:**

- Check MySQL is running
- Verify database credentials in `.env`
- Test connection: `mysql -u root -p`

## Automated Testing Script

Create `test.sh`:

```bash
#!/bin/bash

BASE_URL="http://localhost:8000/api"

echo "Testing JAYQ API..."

# Test 1: Login
echo "Test 1: Login as Admin"
RESPONSE=$(curl -s -X POST $BASE_URL/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@jayq.com","password":"password"}')

TOKEN=$(echo $RESPONSE | jq -r '.data.token')

if [ "$TOKEN" != "null" ]; then
  echo "✓ Login successful"
else
  echo "✗ Login failed"
  exit 1
fi

# Test 2: Get Users
echo "Test 2: Get All Users"
RESPONSE=$(curl -s -X GET $BASE_URL/users \
  -H "Authorization: Bearer $TOKEN")

SUCCESS=$(echo $RESPONSE | jq -r '.success')

if [ "$SUCCESS" == "true" ]; then
  echo "✓ Get users successful"
else
  echo "✗ Get users failed"
fi

# Add more tests...

echo "All tests completed!"
```

## Performance Testing

### Load Testing with Apache Bench

```bash
# Test login endpoint
ab -n 100 -c 10 -p login.json -T application/json \
  http://localhost:8000/api/login

# Test authenticated endpoint
ab -n 100 -c 10 -H "Authorization: Bearer $TOKEN" \
  http://localhost:8000/api/users
```

## Conclusion

Testing adalah bagian penting dari development. Pastikan semua endpoint berfungsi dengan baik sebelum deployment ke production.

**Happy Testing! 🧪**
