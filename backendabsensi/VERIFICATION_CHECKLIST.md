# ✅ JAYQ Backend API - Verification Checklist

Gunakan checklist ini untuk memverifikasi bahwa semua komponen backend telah berhasil diimplementasikan.

---

## 🔍 Installation Verification

### Environment Setup

- [ ] File `.env` sudah dibuat dari `.env.example`
- [ ] `APP_KEY` sudah di-generate
- [ ] Database credentials sudah dikonfigurasi
- [ ] Database `absensi_qr_mobile` sudah dibuat

### Dependencies

- [ ] Composer dependencies terinstall (`vendor/` folder exists)
- [ ] Laravel Sanctum terinstall
- [ ] PHP version 8.3+ terverifikasi

### Database

- [ ] Migrations berhasil dijalankan (11 migrations)
- [ ] Seeders berhasil dijalankan (6 users, 3 mata kuliah)
- [ ] Storage link sudah dibuat (`public/storage` → `storage/app/public`)

### Server

- [ ] Development server bisa dijalankan (`php artisan serve`)
- [ ] API accessible di `http://localhost:8000/api`

---

## 📁 File Structure Verification

### Models (8 files)

- [ ] `app/Models/User.php` - dengan HasApiTokens
- [ ] `app/Models/MataKuliah.php`
- [ ] `app/Models/PesertaMk.php`
- [ ] `app/Models/QrSession.php`
- [ ] `app/Models/Absensi.php`
- [ ] `app/Models/Tugas.php`
- [ ] `app/Models/PengumpulanTugas.php`
- [ ] `app/Models/Materi.php`

### Controllers (8 files)

- [ ] `app/Http/Controllers/Api/AuthController.php`
- [ ] `app/Http/Controllers/Api/UserController.php`
- [ ] `app/Http/Controllers/Api/MataKuliahController.php`
- [ ] `app/Http/Controllers/Api/PesertaMkController.php`
- [ ] `app/Http/Controllers/Api/QrController.php`
- [ ] `app/Http/Controllers/Api/AbsensiController.php`
- [ ] `app/Http/Controllers/Api/TugasController.php`
- [ ] `app/Http/Controllers/Api/MateriController.php`

### Middleware

- [ ] `app/Http/Middleware/RoleMiddleware.php`
- [ ] Middleware registered di `bootstrap/app.php`

### Routes

- [ ] `routes/api.php` dengan 40+ endpoints
- [ ] API routes registered di `bootstrap/app.php`

### Migrations (11 files)

- [ ] `create_users_table.php`
- [ ] `create_mata_kuliah_table.php`
- [ ] `create_peserta_mk_table.php`
- [ ] `create_qr_sessions_table.php`
- [ ] `create_absensi_table.php`
- [ ] `create_tugas_table.php`
- [ ] `create_pengumpulan_tugas_table.php`
- [ ] `create_materi_table.php`
- [ ] `create_personal_access_tokens_table.php`
- [ ] `create_cache_table.php`
- [ ] `create_jobs_table.php`

### Seeders

- [ ] `database/seeders/DatabaseSeeder.php`

### Documentation (8+ files)

- [ ] `README.md`
- [ ] `API_DOCUMENTATION.md`
- [ ] `QUICK_START.md`
- [ ] `DEPLOYMENT.md`
- [ ] `TESTING_GUIDE.md`
- [ ] `CHANGELOG.md`
- [ ] `PROJECT_SUMMARY.md`
- [ ] `COMPLETED_FEATURES.md`
- [ ] `FINAL_SUMMARY.md`
- [ ] `VERIFICATION_CHECKLIST.md` (this file)

### Additional Files

- [ ] `JAYQ_Postman_Collection.json`
- [ ] `install.sh`
- [ ] `install.ps1`
- [ ] `.env.example`

---

## 🧪 Functionality Verification

### Authentication Endpoints

#### Login

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@jayq.com","password":"password"}'
```

- [ ] Returns 200 status
- [ ] Returns token
- [ ] Returns user data with role

#### Logout

```bash
curl -X POST http://localhost:8000/api/logout \
  -H "Authorization: Bearer YOUR_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns success message

#### Get User

```bash
curl -X GET http://localhost:8000/api/user \
  -H "Authorization: Bearer YOUR_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns authenticated user data

### Admin Endpoints

#### Get All Users

```bash
curl -X GET http://localhost:8000/api/users \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns array of users
- [ ] Includes all 6 seeded users

#### Create User

```bash
curl -X POST http://localhost:8000/api/users \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"nama":"Test","email":"test@test.com","password":"password","role":"mahasiswa"}'
```

- [ ] Returns 201 status
- [ ] Returns created user data

#### Get All Mata Kuliah

```bash
curl -X GET http://localhost:8000/api/mata-kuliah \
  -H "Authorization: Bearer ADMIN_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns array of mata kuliah
- [ ] Includes all 3 seeded mata kuliah

#### Create Mata Kuliah

```bash
curl -X POST http://localhost:8000/api/mata-kuliah \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"nama_mk":"Test MK","kode_mk":"TEST","dosen_id":2}'
```

- [ ] Returns 201 status
- [ ] Returns created mata kuliah

#### Add Peserta

```bash
curl -X POST http://localhost:8000/api/peserta-mk \
  -H "Authorization: Bearer ADMIN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"mahasiswa_id":4,"mata_kuliah_id":1}'
```

- [ ] Returns 201 status (or 422 if already exists)
- [ ] Returns peserta data

### Dosen Endpoints

#### Generate QR

```bash
curl -X POST http://localhost:8000/api/generate-qr \
  -H "Authorization: Bearer DOSEN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"mata_kuliah_id":1,"duration":15}'
```

- [ ] Returns 201 status
- [ ] Returns QR code
- [ ] Returns expiration time

#### Get QR Sessions

```bash
curl -X GET http://localhost:8000/api/qr-sessions \
  -H "Authorization: Bearer DOSEN_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns array of QR sessions

#### Get Rekap Absensi

```bash
curl -X GET http://localhost:8000/api/rekap-absensi \
  -H "Authorization: Bearer DOSEN_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns array of absensi

#### Get Mata Kuliah Dosen

```bash
curl -X GET http://localhost:8000/api/mata-kuliah/dosen/me \
  -H "Authorization: Bearer DOSEN_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns mata kuliah yang diajar

### Mahasiswa Endpoints

#### Scan QR

```bash
curl -X POST http://localhost:8000/api/scan-qr \
  -H "Authorization: Bearer MAHASISWA_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"kode_qr":"QR_CODE_HERE","latitude":-6.2,"longitude":106.8}'
```

- [ ] Returns 201 status (first scan)
- [ ] Returns 422 status (duplicate scan)
- [ ] Returns absensi data

#### Get Riwayat Absensi

```bash
curl -X GET http://localhost:8000/api/riwayat-absensi \
  -H "Authorization: Bearer MAHASISWA_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns array of absensi

#### Get Mata Kuliah Mahasiswa

```bash
curl -X GET http://localhost:8000/api/mata-kuliah/mahasiswa/me \
  -H "Authorization: Bearer MAHASISWA_TOKEN"
```

- [ ] Returns 200 status
- [ ] Returns mata kuliah yang diambil

---

## 🔒 Security Verification

### Authentication

- [ ] Login requires email and password
- [ ] Invalid credentials return 401
- [ ] Token is generated on successful login
- [ ] Token is required for protected routes
- [ ] Invalid token returns 401

### Authorization

- [ ] Admin can access admin endpoints
- [ ] Dosen can access dosen endpoints
- [ ] Mahasiswa can access mahasiswa endpoints
- [ ] Wrong role returns 403 Forbidden
- [ ] Middleware blocks unauthorized access

### Validation

- [ ] Empty fields return validation errors
- [ ] Invalid email format rejected
- [ ] Duplicate email rejected
- [ ] Invalid file types rejected
- [ ] File size limits enforced

### Data Protection

- [ ] Passwords are hashed (not plain text)
- [ ] Tokens are secure
- [ ] SQL injection protected (Eloquent)
- [ ] XSS protected

---

## 📊 Database Verification

### Tables Exist

```sql
SHOW TABLES;
```

- [ ] users
- [ ] mata_kuliah
- [ ] peserta_mk
- [ ] qr_sessions
- [ ] absensi
- [ ] tugas
- [ ] pengumpulan_tugas
- [ ] materi
- [ ] personal_access_tokens
- [ ] cache
- [ ] jobs
- [ ] sessions

### Sample Data

```sql
SELECT COUNT(*) FROM users;
```

- [ ] 6 users (1 admin, 2 dosen, 3 mahasiswa)

```sql
SELECT COUNT(*) FROM mata_kuliah;
```

- [ ] 3 mata kuliah

```sql
SELECT COUNT(*) FROM peserta_mk;
```

- [ ] 6 enrollments

### Relationships

```sql
SELECT u.nama, mk.nama_mk
FROM users u
JOIN mata_kuliah mk ON u.id = mk.dosen_id;
```

- [ ] Dosen-MataKuliah relationship works

```sql
SELECT u.nama, mk.nama_mk
FROM users u
JOIN peserta_mk pm ON u.id = pm.mahasiswa_id
JOIN mata_kuliah mk ON pm.mata_kuliah_id = mk.id;
```

- [ ] Mahasiswa-MataKuliah relationship works

---

## 📁 Storage Verification

### Storage Structure

- [ ] `storage/app/public/` exists
- [ ] `storage/app/public/tugas/` exists
- [ ] `storage/app/public/pengumpulan_tugas/` exists
- [ ] `storage/app/public/materi/` exists
- [ ] `public/storage` symlink exists

### File Upload Test

- [ ] Can upload tugas file
- [ ] Can upload pengumpulan tugas file
- [ ] Can upload materi file
- [ ] Files are accessible via URL
- [ ] Invalid file types rejected
- [ ] Large files rejected

---

## 🧪 Postman Verification

### Collection Import

- [ ] `JAYQ_Postman_Collection.json` can be imported
- [ ] Collection has all folders
- [ ] Variables are set (base_url, token)

### Test Requests

- [ ] Authentication folder works
- [ ] Admin folder works
- [ ] Dosen folder works
- [ ] Mahasiswa folder works
- [ ] Token auto-saves after login

---

## 📖 Documentation Verification

### README.md

- [ ] Installation instructions clear
- [ ] Requirements listed
- [ ] Quick start guide included
- [ ] Default credentials listed

### API_DOCUMENTATION.md

- [ ] All endpoints documented
- [ ] Request examples included
- [ ] Response examples included
- [ ] Error responses documented

### QUICK_START.md

- [ ] Step-by-step setup guide
- [ ] Commands are correct
- [ ] Testing examples included

### DEPLOYMENT.md

- [ ] Production setup guide
- [ ] Server requirements listed
- [ ] Security best practices included

---

## ✅ Final Verification

### Code Quality

- [ ] No syntax errors
- [ ] Controllers follow naming conventions
- [ ] Models have relationships defined
- [ ] Routes are organized
- [ ] Code is commented where needed

### Functionality

- [ ] All CRUD operations work
- [ ] File uploads work
- [ ] QR generation works
- [ ] QR scanning works
- [ ] Validations work
- [ ] Error handling works

### Security

- [ ] Authentication works
- [ ] Authorization works
- [ ] Passwords hashed
- [ ] Tokens secure
- [ ] Validation in place

### Documentation

- [ ] All docs are complete
- [ ] Examples are accurate
- [ ] Instructions are clear
- [ ] Credentials are documented

### Production Ready

- [ ] Environment configured
- [ ] Migrations work
- [ ] Seeders work
- [ ] Storage configured
- [ ] Error logging works

---

## 🎉 Completion Status

**Total Checks**: 150+

**Completed**: **\_** / 150+

**Status**:

- [ ] ✅ All checks passed - PRODUCTION READY
- [ ] ⚠️ Some checks failed - NEEDS ATTENTION
- [ ] ❌ Many checks failed - NEEDS WORK

---

## 📝 Notes

Use this space to note any issues found during verification:

```
Issue 1:
Solution:

Issue 2:
Solution:

Issue 3:
Solution:
```

---

## ✅ Sign-off

**Verified by**: ********\_********

**Date**: ********\_********

**Status**: ********\_********

**Notes**: ********\_********

---

**JAYQ Backend API - Verification Complete! 🎉**
