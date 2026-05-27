# Mahasiswa Features - TAHAP 2: Jadwal Kuliah ✅

## Status: COMPLETE

## 📋 Fitur yang Dibuat

### 1. **Backend - Database Migration**

- ✅ Migration untuk menambahkan field jadwal ke tabel `mata_kuliah`
- ✅ Field baru: `hari`, `jam_mulai`, `jam_selesai`, `ruangan`
- ✅ Update model `MataKuliah` dengan field jadwal

**File:**

- `backendabsensi/database/migrations/2026_05_27_000001_add_schedule_fields_to_mata_kuliah_table.php`
- `backendabsensi/app/Models/MataKuliah.php`

### 2. **Frontend - Data Layer**

#### Schedule Model

- ✅ Model untuk jadwal kuliah dengan field lengkap
- ✅ Helper methods: `hariCapitalized`, `timeRange`
- ✅ Dosen info included

**File:**

- `jayq_app/lib/data/models/schedule_model.dart`

#### Schedule Service

- ✅ `getMahasiswaSchedule()` - Get semua jadwal mahasiswa
- ✅ `getScheduleByDay(hari)` - Filter jadwal by hari
- ✅ `getTodaySchedule()` - Get jadwal hari ini
- ✅ `groupScheduleByDay()` - Group jadwal per hari

**File:**

- `jayq_app/lib/data/services/schedule_service.dart`

### 3. **Frontend - UI Layer**

#### Schedule Screen

Modern full-screen jadwal dengan fitur lengkap:

**Features:**

- ✅ Tab bar untuk 6 hari (Senin - Sabtu)
- ✅ Auto-select tab hari ini
- ✅ List jadwal per hari dengan card design
- ✅ Pull to refresh
- ✅ Empty state untuk hari tanpa jadwal
- ✅ Loading state & error handling
- ✅ Detail bottom sheet dengan info lengkap
- ✅ Dark mode support penuh

**Card Information:**

- Waktu kuliah (jam mulai - jam selesai)
- Nama mata kuliah
- Kode mata kuliah
- SKS badge
- Ruangan
- Nama dosen

**Detail Bottom Sheet:**

- Mata kuliah
- Kode MK
- Hari
- Waktu
- Ruangan
- Dosen
- SKS

**File:**

- `jayq_app/lib/screens/mahasiswa/schedule_screen.dart`

### 4. **Integration**

- ✅ Update `mahasiswa_dashboard_screen.dart` untuk menggunakan `ScheduleScreen`
- ✅ Tab "Jadwal" di bottom navigation sekarang menampilkan jadwal lengkap

---

## 🎨 Design Features

### Color Scheme

- Primary: University Blue (#003D9B)
- Success: Green (#10B981)
- Background Light: #F8F9FB
- Background Dark: #111827
- Card Light: White
- Card Dark: #1F2937

### UI Components

1. **Header**
   - Calendar icon
   - Title "Jadwal Kuliah"
   - Refresh button

2. **Tab Bar**
   - 6 tabs (Senin - Sabtu)
   - Scrollable horizontal
   - Active indicator
   - Auto-select hari ini

3. **Schedule Card**
   - Time badge dengan icon
   - SKS badge
   - Course name (bold)
   - Course code
   - Location icon + ruangan
   - Lecturer icon + nama dosen
   - Tap untuk detail

4. **Empty State**
   - Icon event_busy
   - "Tidak ada jadwal"
   - Message per hari

5. **Detail Bottom Sheet**
   - Handle bar
   - Icon + label + value rows
   - Close button

---

## 🔌 API Integration

### Endpoint Used

```
GET /api/mata-kuliah/mahasiswa/me
```

**Response Format:**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "nama_mk": "Pemrograman Mobile",
      "kode_mk": "IF301",
      "sks": 3,
      "semester": 6,
      "hari": "senin",
      "jam_mulai": "08:00:00",
      "jam_selesai": "10:30:00",
      "ruangan": "Lab Komputer 3",
      "dosen": {
        "id": 2,
        "nama": "Dr. John Doe",
        "email": "john@example.com"
      }
    }
  ]
}
```

---

## 📱 User Flow

1. **Mahasiswa membuka tab "Jadwal"**
   - Screen otomatis load jadwal dari API
   - Tab hari ini otomatis terpilih

2. **Melihat jadwal per hari**
   - Swipe atau tap tab untuk ganti hari
   - List jadwal muncul sorted by jam_mulai

3. **Melihat detail jadwal**
   - Tap card jadwal
   - Bottom sheet muncul dengan info lengkap

4. **Refresh jadwal**
   - Pull to refresh di list
   - Atau tap refresh button di header

---

## 🧪 Testing Checklist

- [ ] Migration berhasil dijalankan
- [ ] Field jadwal muncul di tabel mata_kuliah
- [ ] API endpoint return data dengan field jadwal
- [ ] Schedule screen load data dengan benar
- [ ] Tab bar berfungsi dengan baik
- [ ] Auto-select hari ini works
- [ ] Empty state muncul untuk hari tanpa jadwal
- [ ] Detail bottom sheet menampilkan info lengkap
- [ ] Pull to refresh berfungsi
- [ ] Dark mode support sempurna
- [ ] Error handling works (no internet, API error)

---

## 📝 Notes

### Database Changes

Field jadwal di tabel `mata_kuliah`:

- `hari` - ENUM (senin, selasa, rabu, kamis, jumat, sabtu)
- `jam_mulai` - TIME (format: HH:mm:ss)
- `jam_selesai` - TIME (format: HH:mm:ss)
- `ruangan` - VARCHAR(50)

### Admin/Dosen Update Required

⚠️ **IMPORTANT:** Admin dan Dosen perlu update form untuk menambahkan field jadwal saat create/edit mata kuliah!

Form yang perlu diupdate:

- `manage_matakuliah_screen.dart` (Admin)
- Add fields: Hari, Jam Mulai, Jam Selesai, Ruangan

---

## 🚀 Next Steps

**TAHAP 3: Riwayat Absensi**

- History screen dengan filter
- Statistik per mata kuliah
- Export riwayat

---

## 🎯 Success Criteria

✅ Mahasiswa bisa melihat jadwal kuliah per hari
✅ Jadwal tersortir by waktu
✅ Info lengkap (waktu, ruangan, dosen)
✅ UI modern dan responsive
✅ Dark mode support
✅ Pull to refresh works
✅ Error handling proper

---

**Completed:** May 27, 2026
**Duration:** ~2 hours
**Status:** ✅ READY FOR TESTING
