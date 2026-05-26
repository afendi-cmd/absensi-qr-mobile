# Unread Badge System - Complete Setup

## ✅ Yang Sudah Dibuat

### 1. Database Migration

**File:** `backendabsensi/database/migrations/2026_05_26_000001_create_pengumuman_reads_table.php`

**Tabel `pengumuman_reads`:**

- `id` - Primary key
- `pengumuman_id` - Foreign key ke tabel pengumuman
- `user_id` - Foreign key ke tabel users
- `read_at` - Timestamp kapan dibaca
- Unique constraint: Satu user hanya bisa mark satu pengumuman sekali

### 2. Model PengumumanRead

**File:** `backendabsensi/app/Models/PengumumanRead.php`

**Fitur:**

- Relasi ke Pengumuman
- Relasi ke User
- Timestamp read_at

### 3. Updated Pengumuman Model

**File:** `backendabsensi/app/Models/Pengumuman.php`

**Fitur Baru:**

- `reads()` relationship
- `isReadBy($userId)` method

### 4. New API Endpoints

**File:** `backendabsensi/app/Http/Controllers/Api/PengumumanController.php`

**Endpoints Baru:**

- `POST /api/pengumuman/{id}/mark-as-read` - Mark pengumuman as read
- `GET /api/pengumuman/unread/count` - Get jumlah unread

### 5. Updated Routes

**File:** `backendabsensi/routes/api.php`

**Routes Baru:**

- Mark as read route
- Unread count route

### 6. Updated Flutter Service

**File:** `jayq_app/lib/data/services/pengumuman_service.dart`

**Methods Baru:**

- `markAsRead(int id)` - Mark pengumuman as read
- `getUnreadCount()` - Get jumlah unread

### 7. Updated Dashboard

**File:** `jayq_app/lib/screens/admin/admin_dashboard_screen.dart`

**Perubahan:**

- Badge menampilkan unread count (bukan total)
- Auto reload unread count

### 8. Updated Notification Center

**File:** `jayq_app/lib/screens/admin/notification_center_screen.dart`

**Perubahan:**

- Auto mark as read saat pengumuman diklik

## 🚀 Cara Setup

### Step 1: Run Migration

```bash
cd backendabsensi
run_migration.bat
```

Atau manual:

```bash
cd backendabsensi
php artisan migrate
```

### Step 2: Hot Restart Flutter

```bash
# Di terminal Flutter, tekan:
R  (huruf R besar)
```

### Step 3: Test Fitur

**Test 1: Cek Badge Awal**

1. Login sebagai admin
2. Lihat icon bell di dashboard
3. Badge menampilkan jumlah pengumuman belum dibaca

**Test 2: Kirim Pengumuman Baru**

1. Klik icon broadcast
2. Kirim pengumuman baru
3. Badge bertambah +1

**Test 3: Baca Pengumuman**

1. Klik icon bell
2. Klik salah satu pengumuman
3. Kembali ke dashboard
4. Badge berkurang -1

**Test 4: Baca Semua**

1. Buka notification center
2. Klik semua pengumuman satu per satu
3. Badge menjadi 0 (hilang)

## 📱 Behavior

### Badge Counter Logic

```
Unread Count = Total Pengumuman - Pengumuman yang Sudah Dibaca

Contoh:
- Total pengumuman: 5
- Sudah dibaca: 2
- Badge: 3
```

### Badge Display

```dart
0 pengumuman belum dibaca  → Badge tidak muncul
1 pengumuman belum dibaca  → Badge: "1"
2 pengumuman belum dibaca  → Badge: "2"
...
9 pengumuman belum dibaca  → Badge: "9"
10+ pengumuman belum dibaca → Badge: "9+"
```

### Mark as Read Trigger

Pengumuman otomatis ditandai "sudah dibaca" saat:

1. **User klik pengumuman** di Notification Center
2. **Detail pengumuman dibuka** (bottom sheet muncul)

### Per-User Tracking

- Setiap user punya status read sendiri
- Admin kirim pengumuman → Badge semua user bertambah
- User A baca → Badge user A berkurang
- User B belum baca → Badge user B tetap

## 🎯 Expected Behavior

### Scenario 1: User Baru Login

```
1. Login pertama kali
2. Ada 5 pengumuman aktif
3. Badge menampilkan: "5"
4. Belum ada yang dibaca
```

### Scenario 2: Baca Beberapa Pengumuman

```
1. Badge awal: "5"
2. Klik bell → Buka notification center
3. Klik pengumuman #1 → Badge: "4"
4. Klik pengumuman #2 → Badge: "3"
5. Kembali ke dashboard
6. Badge menampilkan: "3"
```

### Scenario 3: Pengumuman Baru Masuk

```
1. Badge saat ini: "3"
2. Admin kirim pengumuman baru
3. Popup notification muncul
4. Badge berubah: "4"
5. Klik bell → Lihat pengumuman baru di atas
```

### Scenario 4: Semua Sudah Dibaca

```
1. Badge: "1" (satu pengumuman belum dibaca)
2. Klik bell → Klik pengumuman terakhir
3. Kembali ke dashboard
4. Badge hilang (tidak ada angka)
```

## 📋 Database Structure

### Tabel `pengumuman_reads`

```sql
CREATE TABLE pengumuman_reads (
    id BIGINT PRIMARY KEY AUTO_INCREMENT,
    pengumuman_id BIGINT NOT NULL,
    user_id BIGINT NOT NULL,
    read_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY unique_read (pengumuman_id, user_id),
    FOREIGN KEY (pengumuman_id) REFERENCES pengumuman(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

### Example Data

```sql
-- User 1 sudah baca pengumuman 1 dan 2
INSERT INTO pengumuman_reads (pengumuman_id, user_id, read_at) VALUES
(1, 1, '2026-05-26 10:00:00'),
(2, 1, '2026-05-26 10:05:00');

-- User 2 baru baca pengumuman 1
INSERT INTO pengumuman_reads (pengumuman_id, user_id, read_at) VALUES
(1, 2, '2026-05-26 11:00:00');
```

### Query Unread Count

```sql
-- Get unread count for user_id = 1
SELECT COUNT(*) as unread_count
FROM pengumuman p
WHERE p.is_active = 1
  AND (p.target = 'all' OR p.target = 'admin')
  AND p.id NOT IN (
    SELECT pengumuman_id
    FROM pengumuman_reads
    WHERE user_id = 1
  );
```

## 🔧 API Endpoints

### 1. Mark as Read

```http
POST /api/pengumuman/{id}/mark-as-read
Authorization: Bearer {token}

Response:
{
  "success": true,
  "message": "Pengumuman ditandai sudah dibaca"
}
```

### 2. Get Unread Count

```http
GET /api/pengumuman/unread/count
Authorization: Bearer {token}

Response:
{
  "success": true,
  "data": {
    "unread_count": 3,
    "total_count": 5
  }
}
```

## 📊 Testing Queries

### Check User's Read Status

```sql
-- Lihat pengumuman yang sudah dibaca user_id = 1
SELECT p.id, p.judul, pr.read_at
FROM pengumuman p
JOIN pengumuman_reads pr ON p.id = pr.pengumuman_id
WHERE pr.user_id = 1
ORDER BY pr.read_at DESC;
```

### Check Unread Pengumuman

```sql
-- Lihat pengumuman yang belum dibaca user_id = 1
SELECT p.id, p.judul, p.created_at
FROM pengumuman p
WHERE p.is_active = 1
  AND p.id NOT IN (
    SELECT pengumuman_id
    FROM pengumuman_reads
    WHERE user_id = 1
  )
ORDER BY p.created_at DESC;
```

### Reset Read Status (for testing)

```sql
-- Hapus semua read status user_id = 1
DELETE FROM pengumuman_reads WHERE user_id = 1;

-- Sekarang badge akan menampilkan total pengumuman lagi
```

## 🐛 Troubleshooting

### Badge tidak berubah setelah baca pengumuman

**Penyebab:** Mark as read gagal atau badge tidak reload

**Solusi:**

1. Cek log Flutter untuk error
2. Test API endpoint dengan Postman
3. Cek database: `SELECT * FROM pengumuman_reads WHERE user_id = 1`
4. Reload dashboard (pull to refresh)

### Badge menampilkan angka salah

**Penyebab:** Data tidak sinkron

**Solusi:**

1. Logout dan login ulang
2. Clear app data
3. Cek query unread count di backend
4. Verify data di database

### Migration error

**Penyebab:** Tabel sudah ada atau foreign key error

**Solusi:**

```bash
# Rollback migration
php artisan migrate:rollback

# Run ulang
php artisan migrate
```

### Badge tidak muncul sama sekali

**Penyebab:** Semua pengumuman sudah dibaca atau tidak ada pengumuman

**Solusi:**

1. Kirim pengumuman baru
2. Reset read status: `DELETE FROM pengumuman_reads WHERE user_id = 1`
3. Restart app

## 💡 Tips

### Untuk Development:

1. **Reset read status** untuk testing: `DELETE FROM pengumuman_reads`
2. **Check unread count** di database sebelum test
3. **Use multiple users** untuk test per-user tracking
4. **Monitor API calls** di log Flutter

### Untuk Production:

1. **Index optimization:** Tabel `pengumuman_reads` sudah punya index
2. **Cleanup old reads:** Bisa hapus read status pengumuman yang sudah dihapus
3. **Performance:** Query unread count sudah optimal
4. **Caching:** Bisa cache unread count di Redis untuk performa lebih baik

## 🚀 Next Features

Fitur yang bisa ditambahkan:

1. **Mark all as read** button
2. **Read status indicator** di list (bold untuk unread)
3. **Push notification badge** di app icon
4. **Read receipt** untuk admin (siapa saja yang sudah baca)
5. **Notification history** dengan filter read/unread

---

**Status:** ✅ Ready to use
**Last Updated:** 26 Mei 2026
**Version:** 1.0.0
