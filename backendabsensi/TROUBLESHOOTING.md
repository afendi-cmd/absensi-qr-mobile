# 🔧 JAYQ Backend API - Troubleshooting Guide

Panduan untuk mengatasi masalah umum yang mungkin terjadi.

---

## ❌ Error: Table 'sessions' doesn't exist

### Problem

```
SQLSTATE[42S02]: Base table or view not found: 1146
Table 'absensi_qr_mobile.sessions' doesn't exist
```

### Cause

Migration untuk tabel `sessions` belum dijalankan.

### Solution

**Option 1: Create sessions migration (Recommended)**

```bash
# Generate sessions migration
php artisan session:table

# Run migration
php artisan migrate
```

**Option 2: Change session driver to cookie**
Edit `.env`:

```env
SESSION_DRIVER=cookie
```

Then clear config:

```bash
php artisan config:clear
```

**Option 3: Use array driver (for API only)**
Edit `.env`:

```env
SESSION_DRIVER=array
```

Then clear config:

```bash
php artisan config:clear
```

### Verification

```bash
# Check if sessions table exists
php artisan db:table sessions
```

---

## ❌ Error: SQLSTATE[HY000] [1045] Access denied

### Problem

```
SQLSTATE[HY000] [1045] Access denied for user 'root'@'localhost'
```

### Cause

Database credentials salah di file `.env`.

### Solution

1. Check MySQL credentials:

```bash
mysql -u root -p
```

2. Update `.env`:

```env
DB_USERNAME=your_username
DB_PASSWORD=your_password
```

3. Clear config:

```bash
php artisan config:clear
```

---

## ❌ Error: Database doesn't exist

### Problem

```
SQLSTATE[HY000] [1049] Unknown database 'absensi_qr_mobile'
```

### Cause

Database belum dibuat.

### Solution

```bash
# Create database
mysql -u root -p -e "CREATE DATABASE absensi_qr_mobile;"

# Or via MySQL console
mysql -u root -p
CREATE DATABASE absensi_qr_mobile;
exit;

# Then run migrations
php artisan migrate
```

---

## ❌ Error: 401 Unauthorized

### Problem

API returns 401 even with token.

### Cause

- Token expired
- Token invalid
- Token not sent correctly

### Solution

1. **Login again** to get new token
2. **Check header format**:

```
Authorization: Bearer YOUR_TOKEN_HERE
```

3. **Verify token** in database:

```sql
SELECT * FROM personal_access_tokens ORDER BY created_at DESC LIMIT 5;
```

---

## ❌ Error: 403 Forbidden

### Problem

```json
{
    "success": false,
    "message": "Forbidden - You do not have permission"
}
```

### Cause

User role tidak sesuai dengan endpoint yang diakses.

### Solution

1. **Check user role**:

```bash
curl -X GET http://localhost:8000/api/user \
  -H "Authorization: Bearer YOUR_TOKEN"
```

2. **Login with correct role**:

- Admin endpoints → login as admin
- Dosen endpoints → login as dosen
- Mahasiswa endpoints → login as mahasiswa

---

## ❌ Error: Storage link not found

### Problem

Uploaded files tidak bisa diakses via URL.

### Cause

Storage link belum dibuat.

### Solution

```bash
php artisan storage:link
```

### Verification

```bash
# Windows
dir public\storage

# Linux/Mac
ls -la public/storage
```

---

## ❌ Error: Class not found

### Problem

```
Class 'App\Models\User' not found
```

### Cause

Composer autoload belum di-refresh.

### Solution

```bash
composer dump-autoload
```

---

## ❌ Error: Migration failed

### Problem

Migration error atau stuck.

### Solution

**Option 1: Fresh migration**

```bash
php artisan migrate:fresh --seed
```

**Option 2: Rollback and migrate**

```bash
php artisan migrate:rollback
php artisan migrate
```

**Option 3: Reset database**

```bash
# Drop all tables
php artisan db:wipe

# Run migrations
php artisan migrate --seed
```

---

## ❌ Error: Port 8000 already in use

### Problem

```
Address already in use
```

### Cause

Port 8000 sudah digunakan.

### Solution

**Option 1: Use different port**

```bash
php artisan serve --port=8001
```

**Option 2: Kill existing process**

Windows:

```bash
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

Linux/Mac:

```bash
lsof -ti:8000 | xargs kill -9
```

---

## ❌ Error: File upload failed

### Problem

File upload returns validation error.

### Cause

- File type tidak didukung
- File size terlalu besar
- Storage permission

### Solution

1. **Check file type**:

- Tugas: PDF, DOC, DOCX (max 10MB)
- Materi: PDF, DOC, DOCX, PPT, PPTX (max 20MB)

2. **Check PHP upload limits**:
   Edit `php.ini`:

```ini
upload_max_filesize = 20M
post_max_size = 20M
```

3. **Check storage permissions**:

```bash
chmod -R 775 storage
```

---

## ❌ Error: QR Code expired

### Problem

```json
{
    "success": false,
    "message": "QR Code sudah expired"
}
```

### Cause

QR code sudah melewati waktu expiration.

### Solution

Generate QR code baru:

```bash
curl -X POST http://localhost:8000/api/generate-qr \
  -H "Authorization: Bearer DOSEN_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"mata_kuliah_id":1,"duration":15}'
```

---

## ❌ Error: Already attended

### Problem

```json
{
    "success": false,
    "message": "Anda sudah melakukan absensi pada sesi ini"
}
```

### Cause

Mahasiswa sudah scan QR untuk session ini.

### Solution

Ini adalah validasi yang benar. Mahasiswa tidak bisa absen 2x untuk session yang sama.

Untuk testing, generate QR baru:

```bash
# Login as dosen
# Generate new QR
# Scan with mahasiswa
```

---

## ❌ Error: Composer install failed

### Problem

Composer dependencies gagal terinstall.

### Solution

1. **Update Composer**:

```bash
composer self-update
```

2. **Clear cache**:

```bash
composer clear-cache
```

3. **Install with verbose**:

```bash
composer install -vvv
```

4. **Check PHP extensions**:

```bash
php -m
```

Required extensions:

- BCMath
- Ctype
- Fileinfo
- JSON
- Mbstring
- OpenSSL
- PDO
- Tokenizer
- XML

---

## ❌ Error: CORS issues

### Problem

Browser blocks API requests (CORS error).

### Solution

1. **Install Laravel CORS package** (if needed):

```bash
composer require fruitcake/laravel-cors
```

2. **Configure CORS** in `config/cors.php`:

```php
'paths' => ['api/*'],
'allowed_origins' => ['*'],
'allowed_methods' => ['*'],
'allowed_headers' => ['*'],
```

3. **Clear config**:

```bash
php artisan config:clear
```

---

## 🔍 Debugging Tips

### Enable Debug Mode

Edit `.env`:

```env
APP_DEBUG=true
LOG_LEVEL=debug
```

### Check Logs

```bash
tail -f storage/logs/laravel.log
```

### Test Database Connection

```bash
php artisan db:show
```

### List All Routes

```bash
php artisan route:list
```

### Check Environment

```bash
php artisan about
```

### Clear All Cache

```bash
php artisan optimize:clear
```

This clears:

- Config cache
- Route cache
- View cache
- Application cache

---

## 📞 Getting Help

### Check Documentation

1. README.md
2. API_DOCUMENTATION.md
3. QUICK_START.md
4. DEPLOYMENT.md

### Verify Installation

Run verification checklist:

```bash
# Check all components
php artisan about
php artisan route:list
php artisan db:table users
```

### Test API

Use test script:

```bash
# Windows
powershell -ExecutionPolicy Bypass -File test-api.ps1

# Linux/Mac
bash test-api.sh
```

---

## ✅ Prevention Tips

### Before Starting

- [ ] Check PHP version (8.3+)
- [ ] Check MySQL is running
- [ ] Check Composer is installed
- [ ] Check database credentials

### After Installation

- [ ] Run migrations
- [ ] Run seeders
- [ ] Create storage link
- [ ] Test login endpoint
- [ ] Import Postman collection

### Regular Maintenance

- [ ] Check logs regularly
- [ ] Backup database
- [ ] Update dependencies
- [ ] Monitor disk space
- [ ] Check error rates

---

## 🚨 Emergency Recovery

### Complete Reset

```bash
# 1. Drop all tables
php artisan db:wipe

# 2. Clear all cache
php artisan optimize:clear

# 3. Reinstall dependencies
composer install

# 4. Regenerate key
php artisan key:generate

# 5. Run migrations & seeders
php artisan migrate:fresh --seed

# 6. Recreate storage link
php artisan storage:link

# 7. Test
php artisan serve
```

---

**Need more help? Check the documentation or contact support!**
