# 📊 Perbandingan Fitur Mahasiswa vs Dosen

**Aplikasi Absensi Kampus**  
**Tanggal:** 1 Juni 2026

---

## 📱 Overview

| Aspek                | Mahasiswa       | Dosen               |
| -------------------- | --------------- | ------------------- |
| **Role**             | Consumer/User   | Creator/Manager     |
| **Status**           | ✅ 90% Complete | 🔄 20% Complete     |
| **Total Fitur**      | 12 screens      | 9 screens (planned) |
| **Estimasi Selesai** | Done            | 4-6 minggu          |

---

## 🎯 Fitur Utama

### 1. Dashboard

| Fitur               | Mahasiswa                       | Dosen                                                   |
| ------------------- | ------------------------------- | ------------------------------------------------------- |
| **Welcome Section** | ✅ Nama + Foto                  | ✅ Nama + NIP + Foto                                    |
| **Statistics**      | ✅ Persentase kehadiran pribadi | ✅ Total MK, Mahasiswa, Kehadiran hari ini, Tugas aktif |
| **Jadwal**          | ✅ Jadwal kuliah hari ini       | ✅ Jadwal mengajar hari ini                             |
| **Quick Actions**   | ✅ Kalender, Tugas & Ujian      | ✅ Generate QR, Upload Materi, Buat Tugas               |
| **Status**          | ✅ Done                         | 🔄 Need to build                                        |

---

### 2. Absensi

| Fitur           | Mahasiswa                | Dosen                       |
| --------------- | ------------------------ | --------------------------- |
| **Scan QR**     | ✅ Scan QR untuk absen   | ❌ N/A                      |
| **Generate QR** | ❌ N/A                   | 🔄 Generate QR session      |
| **Riwayat**     | ✅ Lihat riwayat pribadi | 🔄 Lihat rekap per kelas    |
| **Filter**      | ✅ By MK, By Bulan       | 🔄 By MK, By Periode        |
| **Export**      | ❌ N/A                   | 🔄 Export Excel/PDF         |
| **Analytics**   | ✅ Personal stats        | 🔄 Class analytics + charts |
| **Status**      | ✅ Done                  | 🔄 Need to build            |

---

### 3. Mata Kuliah

| Fitur              | Mahasiswa          | Dosen                         |
| ------------------ | ------------------ | ----------------------------- |
| **List MK**        | ✅ MK yang diambil | 🔄 MK yang diampu             |
| **Detail MK**      | ✅ Info + Jadwal   | 🔄 Info + Jadwal + Stats      |
| **Daftar Peserta** | ❌ N/A             | 🔄 List mahasiswa + kehadiran |
| **Filter Peserta** | ❌ N/A             | 🔄 By status kehadiran        |
| **Export**         | ❌ N/A             | 🔄 Export daftar mahasiswa    |
| **Status**         | ✅ Done            | 🔄 Need to build              |

---

### 4. Tugas

| Fitur                  | Mahasiswa                  | Dosen                         |
| ---------------------- | -------------------------- | ----------------------------- |
| **List Tugas**         | ✅ Tugas yang diterima     | 🔄 Tugas yang dibuat          |
| **Create**             | ❌ N/A                     | 🔄 Buat tugas baru            |
| **Edit/Delete**        | ❌ N/A                     | 🔄 Edit/Delete tugas          |
| **Upload Jawaban**     | ✅ Upload file             | ❌ N/A                        |
| **Download File**      | ✅ Download file tugas     | 🔄 Download jawaban mahasiswa |
| **Penilaian**          | ✅ Lihat nilai             | 🔄 Beri nilai + catatan       |
| **Status Pengumpulan** | ✅ Sudah/Belum dikumpulkan | 🔄 X/Y mahasiswa sudah submit |
| **Reminder**           | ❌ N/A                     | 🔄 Send reminder ke mahasiswa |
| **Status**             | ✅ Done                    | 🔄 Need to build              |

---

### 5. Materi

| Fitur            | Mahasiswa               | Dosen                     |
| ---------------- | ----------------------- | ------------------------- |
| **List Materi**  | ✅ Materi yang tersedia | 🔄 Materi yang diupload   |
| **Upload**       | ❌ N/A                  | 🔄 Upload materi baru     |
| **Edit/Delete**  | ❌ N/A                  | 🔄 Edit/Delete materi     |
| **Download**     | ✅ Download file        | ❌ N/A                    |
| **Statistics**   | ❌ N/A                  | 🔄 Download stats         |
| **Notification** | ✅ Notif materi baru    | 🔄 Send notif saat upload |
| **Status**       | ✅ Done                 | 🔄 Need to build          |

---

### 6. Pengumuman

| Fitur                 | Mahasiswa              | Dosen                  |
| --------------------- | ---------------------- | ---------------------- |
| **List**              | ✅ Lihat pengumuman    | ✅ Lihat pengumuman    |
| **Filter**            | ✅ By tipe, By status  | ✅ By tipe, By status  |
| **Detail**            | ✅ Baca detail         | ✅ Baca detail         |
| **Mark as Read**      | ✅ Tandai sudah dibaca | ✅ Tandai sudah dibaca |
| **Push Notification** | ✅ Terima notifikasi   | ✅ Terima notifikasi   |
| **Create**            | ❌ N/A (Admin only)    | ❌ N/A (Admin only)    |
| **Status**            | ✅ Done                | ✅ Copy from mahasiswa |

---

### 7. Profile

| Fitur               | Mahasiswa               | Dosen                   |
| ------------------- | ----------------------- | ----------------------- |
| **View Profile**    | ✅ Nama, NIM, Email, HP | 🔄 Nama, NIP, Email, HP |
| **Edit Profile**    | ✅ Edit info            | 🔄 Edit info            |
| **Upload Photo**    | ❌ Not yet              | 🔄 Upload foto profil   |
| **Change Password** | ✅ Ubah password        | 🔄 Ubah password        |
| **Dark Mode**       | ✅ Toggle               | 🔄 Toggle               |
| **Settings**        | ✅ Notifikasi, Bahasa   | 🔄 Notifikasi, Bahasa   |
| **Logout**          | ✅ Logout               | 🔄 Logout               |
| **Status**          | ✅ Done                 | 🔄 Need to build        |

---

### 8. Jadwal

| Fitur                | Mahasiswa                    | Dosen                        |
| -------------------- | ---------------------------- | ---------------------------- |
| **View**             | ✅ Jadwal kuliah             | 🔄 Jadwal mengajar           |
| **Filter**           | ✅ Per hari                  | 🔄 Per hari                  |
| **Status Real-time** | ✅ Belum/Berlangsung/Selesai | 🔄 Belum/Berlangsung/Selesai |
| **Quick Action**     | ✅ Scan QR                   | 🔄 Generate QR               |
| **Calendar View**    | ❌ Not yet                   | 🔄 Calendar view             |
| **Status**           | ✅ Done                      | 🔄 Need to build             |

---

## 🎨 UI/UX Features

| Fitur               | Mahasiswa      | Dosen                |
| ------------------- | -------------- | -------------------- |
| **Dark Mode**       | ✅ All screens | 🔄 Need to implement |
| **Pull-to-Refresh** | ✅ All screens | 🔄 Need to implement |
| **Loading States**  | ✅ Implemented | 🔄 Need to implement |
| **Empty States**    | ✅ Implemented | 🔄 Need to implement |
| **Error Handling**  | ✅ Implemented | 🔄 Need to implement |
| **Animations**      | ⚠️ Basic       | 🔄 Need to implement |

---

## 📊 Analytics & Reports

| Fitur              | Mahasiswa               | Dosen                        |
| ------------------ | ----------------------- | ---------------------------- |
| **Personal Stats** | ✅ Persentase kehadiran | ❌ N/A                       |
| **Class Stats**    | ❌ N/A                  | 🔄 Rata-rata kehadiran kelas |
| **Charts**         | ❌ Not yet              | 🔄 Bar, Line, Pie charts     |
| **Export Data**    | ❌ Not yet              | 🔄 Excel, PDF export         |
| **Trend Analysis** | ❌ Not yet              | 🔄 Trend kehadiran           |

---

## 🔔 Notifications

| Fitur                 | Mahasiswa            | Dosen                    |
| --------------------- | -------------------- | ------------------------ |
| **Pengumuman Baru**   | ✅ Push notification | ✅ Push notification     |
| **Materi Baru**       | ⚠️ Planned           | 🔄 Send to mahasiswa     |
| **Tugas Baru**        | ⚠️ Planned           | 🔄 Send to mahasiswa     |
| **Deadline Reminder** | ⚠️ Planned           | 🔄 Auto reminder         |
| **Kehadiran Alert**   | ❌ N/A               | 🔄 Alert mahasiswa < 75% |

---

## 🔐 Permissions & Access

| Aksi                          | Mahasiswa | Dosen                          |
| ----------------------------- | --------- | ------------------------------ |
| **Lihat Data Pribadi**        | ✅ Yes    | ✅ Yes                         |
| **Lihat Data Kelas**          | ❌ No     | ✅ Yes (kelas yang diampu)     |
| **Lihat Data Mahasiswa Lain** | ❌ No     | ✅ Yes (mahasiswa di kelasnya) |
| **Create Tugas/Materi**       | ❌ No     | ✅ Yes                         |
| **Edit Tugas/Materi**         | ❌ No     | ✅ Yes (yang dibuat sendiri)   |
| **Delete Tugas/Materi**       | ❌ No     | ✅ Yes (yang dibuat sendiri)   |
| **Beri Nilai**                | ❌ No     | ✅ Yes                         |
| **Generate QR**               | ❌ No     | ✅ Yes                         |
| **Export Data**               | ❌ No     | ✅ Yes                         |
| **Send Notifications**        | ❌ No     | ✅ Yes                         |

---

## 📱 Screen Count

### Mahasiswa (12 screens)

1. ✅ Dashboard
2. ✅ Jadwal Kuliah
3. ✅ Riwayat Absensi
4. ✅ QR Scanner
5. ✅ Tugas & Materi (Tab)
6. ✅ Detail Tugas
7. ✅ Detail Materi
8. ✅ Pengumuman
9. ✅ Detail Pengumuman
10. ✅ Profile
11. ✅ Edit Profile
12. ✅ Change Password

### Dosen (9 screens planned)

1. 🔄 Dashboard
2. 🔄 Generate QR
3. 🔄 Mata Kuliah
4. 🔄 Detail Mata Kuliah (+ Daftar Mahasiswa)
5. 🔄 Rekap Kehadiran
6. 🔄 Manajemen Tugas (+ Penilaian)
7. 🔄 Manajemen Materi
8. ✅ Pengumuman (copy from mahasiswa)
9. 🔄 Profile

---

## 🎯 Development Priority

### Mahasiswa

- ✅ Phase 1: Core Features (Done)
- ✅ Phase 2: Enhancements (Done)
- ⚠️ Phase 3: Advanced Features (Planned)

### Dosen

- 🔄 Sprint 1: Dashboard + QR + Mata Kuliah (Week 1-2)
- 🔄 Sprint 2: Rekap + Tugas (Week 3-4)
- 🔄 Sprint 3: Materi + Pengumuman + Profile (Week 5-6)
- 🔄 Sprint 4: Jadwal + Testing (Week 7)

---

## 💡 Key Insights

### Similarities (Fitur yang Mirip):

- Dashboard structure
- Profile management
- Pengumuman (read-only)
- Dark mode & Pull-to-refresh
- Push notifications

### Differences (Fitur yang Berbeda):

**Mahasiswa = Consumer:**

- Scan QR (input)
- Submit tugas (input)
- Download materi (output)
- View personal stats (output)

**Dosen = Manager:**

- Generate QR (create)
- Create tugas/materi (create)
- Grade assignments (process)
- View class analytics (analytics)
- Export reports (output)

---

**Kesimpulan:**

- Modul Mahasiswa sudah 90% selesai
- Modul Dosen perlu 4-6 minggu development
- Banyak komponen yang bisa di-reuse dari mahasiswa
- Backend API untuk dosen perlu dibangun dari awal

---

**© 2026 Aplikasi Absensi Kampus. All rights reserved.**
