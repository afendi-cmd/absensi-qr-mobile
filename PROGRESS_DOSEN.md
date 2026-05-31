# ✅ Progress Pembangunan Modul Dosen

**Tanggal Mulai:** 1 Juni 2026  
**Last Updated:** 1 Juni 2026

---

## 📊 Overall Progress: 25%

```
Backend:  ████░░░░░░░░░░░░░░░░  20%
Frontend: ██████░░░░░░░░░░░░░░  30%
Testing:  ░░░░░░░░░░░░░░░░░░░░   0%
```

---

## ✅ Yang Sudah Selesai

### Backend

- [x] DashboardController::dosenStats() - sudah ada
- [x] Route `/dashboard/dosen/{id}/stats` - sudah ada
- [x] MataKuliahController - sudah ada (perlu tambah endpoint dosen)

### Frontend

- [x] DashboardDosenService - ✅ Created
- [x] DashboardDosenProvider - ✅ Created
- [x] MataKuliahService::getDosenMataKuliah() - ✅ Added
- [x] DosenDashboardScreen - ⚠️ Exists (perlu update)

---

## 🔄 Sedang Dikerjakan

### Backend

- [ ] MataKuliahController::getDosenMataKuliah()
- [ ] Route `/mata-kuliah/dosen/me`

### Frontend

- [ ] Update DosenDashboardScreen dengan real data
- [ ] Add dark mode support
- [ ] Add pull-to-refresh

---

## 📋 Yang Perlu Dibuat

### STEP 1: Dashboard (Lanjutan)

**Backend:**

- [ ] Add method `getDosenMataKuliah()` di MataKuliahController
- [ ] Add route `/mata-kuliah/dosen/me`

**Frontend:**

- [ ] Update DosenDashboardScreen:
  - [ ] Integrate with DashboardDosenProvider
  - [ ] Show real statistics
  - [ ] Add pull-to-refresh
  - [ ] Add dark mode
  - [ ] Add loading states
  - [ ] Add error handling
  - [ ] Show mata kuliah list
  - [ ] Add navigation to other screens

---

### STEP 2: Generate QR Code

**Backend:**

- [ ] Create migration `qr_sessions` table
- [ ] Create QrSession model
- [ ] Create QrSessionController:
  - [ ] generate()
  - [ ] show()
  - [ ] close()
  - [ ] getAttendances()
- [ ] Add routes for QR session

**Frontend:**

- [ ] Create QrSessionModel
- [ ] Create QrSessionService
- [ ] Create GenerateQrScreen:
  - [ ] Select mata kuliah dropdown
  - [ ] Set duration slider
  - [ ] Generate QR button
  - [ ] Display QR code fullscreen
  - [ ] Timer countdown
  - [ ] Real-time attendance list
  - [ ] Close session button
  - [ ] Dark mode support

---

### STEP 3: Manajemen Mata Kuliah

**Backend:**

- [ ] MataKuliahController::getMahasiswaList()
- [ ] Route `/mata-kuliah/{id}/mahasiswa`

**Frontend:**

- [ ] Create MataKuliahListScreen
- [ ] Create MataKuliahDetailScreen
- [ ] Create MahasiswaListScreen
- [ ] Add filter & search
- [ ] Add export functionality

---

### STEP 4: Rekap Kehadiran

**Backend:**

- [ ] Create RekapController:
  - [ ] getRekapKehadiran()
  - [ ] exportRekap()
  - [ ] sendReminder()
- [ ] Add routes

**Frontend:**

- [ ] Create RekapKehadiranScreen
- [ ] Add charts (fl_chart)
- [ ] Add export to PDF/Excel
- [ ] Add send reminder

---

### STEP 5: Manajemen Tugas

**Backend:**

- [ ] TugasController for dosen:
  - [ ] index() - list tugas dosen
  - [ ] getPengumpulan()
  - [ ] beriNilai()
  - [ ] sendReminder()

**Frontend:**

- [ ] Create TugasListScreen (dosen)
- [ ] Create TugasFormScreen (create/edit)
- [ ] Create TugasPenilaianScreen
- [ ] Add grading functionality

---

### STEP 6: Manajemen Materi

**Backend:**

- [ ] MateriController for dosen:
  - [ ] index() - list materi dosen
  - [ ] getStats()

**Frontend:**

- [ ] Create MateriListScreen (dosen)
- [ ] Create MateriFormScreen (upload)
- [ ] Add statistics view

---

### STEP 7: Profile & Settings

**Frontend:**

- [ ] Create/Update ProfileScreen for dosen
- [ ] Add edit profile
- [ ] Add change password
- [ ] Add settings (dark mode, notifications)

---

### STEP 8: Testing & Polish

- [ ] Unit tests
- [ ] Integration tests
- [ ] Bug fixes
- [ ] Performance optimization
- [ ] UI/UX polish

---

## 📝 Notes

### File Structure Created:

```
jayq_app/lib/
├── data/
│   ├── services/
│   │   ├── dashboard_dosen_service.dart ✅
│   │   └── matakuliah_service.dart (updated) ✅
│   └── providers/
│       └── dashboard_dosen_provider.dart ✅
└── screens/
    └── dosen/
        └── dosen_dashboard_screen.dart (exists, need update)
```

### Backend Endpoints Status:

```
✅ GET  /dashboard/dosen/{id}/stats
⚠️  GET  /mata-kuliah/dosen/me (need to create)
❌ POST /qr-session/generate
❌ GET  /qr-session/{id}
❌ PUT  /qr-session/{id}/close
❌ GET  /qr-session/{id}/attendances
```

### Next Immediate Actions:

1. ✅ Create backend endpoint `/mata-kuliah/dosen/me`
2. ✅ Update DosenDashboardScreen with real data
3. ✅ Add dark mode & pull-to-refresh
4. ✅ Test dashboard functionality
5. ➡️ Move to Step 2: Generate QR

---

## 🎯 Timeline Estimate

| Step | Task             | Days | Status     |
| ---- | ---------------- | ---- | ---------- |
| 1    | Dashboard Dosen  | 2-3  | 🔄 50%     |
| 2    | Generate QR      | 2-3  | ⏳ Pending |
| 3    | Mata Kuliah      | 2-3  | ⏳ Pending |
| 4    | Rekap Kehadiran  | 3-4  | ⏳ Pending |
| 5    | Manajemen Tugas  | 3-4  | ⏳ Pending |
| 6    | Manajemen Materi | 2-3  | ⏳ Pending |
| 7    | Profile          | 1-2  | ⏳ Pending |
| 8    | Testing          | 3-5  | ⏳ Pending |

**Total:** 18-27 hari (3.5-5.5 minggu)

---

**© 2026 Aplikasi Absensi Kampus**
