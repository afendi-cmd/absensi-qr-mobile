# JAYQ - Features Documentation

Dokumentasi lengkap fitur aplikasi JAYQ.

## 🎯 Overview

JAYQ adalah aplikasi absensi mahasiswa modern dengan 3 role utama:

- **Admin**: Mengelola sistem secara keseluruhan
- **Dosen**: Mengelola perkuliahan dan absensi
- **Mahasiswa**: Melakukan absensi dan mengakses materi

## 👤 Role-Based Features

### 🔴 Admin Features

#### 1. Dashboard Admin

- **Overview Statistics**
  - Total mahasiswa
  - Total dosen
  - Total mata kuliah
  - Absensi hari ini
- **Quick Actions**
  - Kelola dosen
  - Kelola mahasiswa
  - Kelola mata kuliah
  - Rekap absensi
- **Recent Activity**
  - Log aktivitas terbaru
  - Notifikasi sistem

#### 2. Kelola Dosen

- **List Dosen**
  - View all dosen
  - Search dosen
  - Filter by status
- **Add Dosen**
  - Form input data dosen
  - Upload foto profil
  - Validasi NIP
- **Edit Dosen**
  - Update data dosen
  - Change password
  - Update foto
- **Delete Dosen**
  - Soft delete
  - Confirmation dialog

#### 3. Kelola Mahasiswa

- **List Mahasiswa**
  - View all mahasiswa
  - Search by name/NIM
  - Filter by angkatan
- **Add Mahasiswa**
  - Form input data
  - Upload foto
  - Validasi NIM
- **Edit Mahasiswa**
  - Update data
  - Change password
  - Update foto
- **Delete Mahasiswa**
  - Soft delete
  - Confirmation

#### 4. Kelola Mata Kuliah

- **List Mata Kuliah**
  - View all courses
  - Search by code/name
  - Filter by semester
- **Add Mata Kuliah**
  - Input kode MK
  - Input nama MK
  - Set SKS
  - Assign dosen
- **Edit Mata Kuliah**
  - Update info
  - Change dosen
- **Delete Mata Kuliah**
  - Confirmation required

#### 5. Peserta Mata Kuliah

- **Manage Participants**
  - Add mahasiswa to course
  - Remove mahasiswa
  - View participant list
  - Export to Excel

#### 6. Rekap Absensi

- **View Reports**
  - Filter by date range
  - Filter by mata kuliah
  - Filter by mahasiswa
- **Statistics**
  - Attendance percentage
  - Present/absent count
  - Charts and graphs
- **Export**
  - Export to PDF
  - Export to Excel
  - Print report

### 🔵 Dosen Features

#### 1. Dashboard Dosen

- **Statistics**
  - Jumlah mata kuliah
  - Total mahasiswa
  - Kehadiran hari ini
  - Tugas aktif
- **Quick Actions**
  - Generate QR code
  - Upload materi
  - Create tugas
- **Mata Kuliah List**
  - View assigned courses
  - Attendance percentage
  - Quick access

#### 2. Generate QR Code

- **Create QR Session**
  - Select mata kuliah
  - Set expiration time
  - Generate unique QR
- **Display QR**
  - Large QR display
  - Countdown timer
  - Refresh button
- **Active Sessions**
  - View active QR
  - Deactivate QR
  - Session history

#### 3. Rekap Absensi

- **View Attendance**
  - List mahasiswa hadir
  - Filter by date
  - Filter by status
- **Statistics**
  - Attendance rate
  - Present/absent count
  - Late arrivals
- **Actions**
  - Manual attendance
  - Edit status
  - Add notes

#### 4. Upload Materi

- **Upload Files**
  - PDF, DOC, DOCX
  - Images
  - Max 10MB
- **Materi Info**
  - Title
  - Description
  - Mata kuliah
- **Manage Materi**
  - View uploaded files
  - Edit info
  - Delete files

#### 5. Kelola Tugas

- **Create Tugas**
  - Title and description
  - Set deadline
  - Upload attachment
  - Select mata kuliah
- **View Submissions**
  - List submitted tugas
  - Download files
  - Give feedback
- **Grading**
  - Score assignment
  - Add comments
  - Update status

#### 6. Profile

- **View Profile**
  - Personal info
  - NIP
  - Contact info
- **Edit Profile**
  - Update data
  - Change photo
  - Change password

### 🟢 Mahasiswa Features

#### 1. Dashboard Mahasiswa

- **Statistics**
  - Jumlah mata kuliah
  - Attendance rate
  - Tugas completed
  - Pending tasks
- **Scan QR Button**
  - Large prominent button
  - Quick access to scanner
- **Mata Kuliah Cards**
  - Course info
  - Dosen name
  - Attendance percentage
- **Upcoming Tasks**
  - Task list
  - Deadline countdown
  - Urgent indicators

#### 2. Scan QR Code

- **Camera Scanner**
  - Fullscreen camera
  - Auto-detect QR
  - Scan animation
- **Success Feedback**
  - Success animation
  - Attendance confirmed
  - Show details
- **Error Handling**
  - Invalid QR message
  - Expired QR alert
  - Already attended

#### 3. Mata Kuliah Saya

- **Course List**
  - Enrolled courses
  - Course details
  - Dosen info
- **Course Details**
  - Attendance history
  - Materi list
  - Tugas list
- **Statistics**
  - Attendance rate
  - Completed tasks
  - Grades

#### 4. Riwayat Absensi

- **Attendance History**
  - Timeline view
  - Filter by course
  - Filter by date
- **Status Badges**
  - Hadir (green)
  - Alfa (red)
  - Izin (yellow)
  - Sakit (orange)
- **Details**
  - Date and time
  - Mata kuliah
  - Status

#### 5. Tugas

- **Task List**
  - All assignments
  - Filter by course
  - Sort by deadline
- **Task Details**
  - Description
  - Deadline
  - Attachment
- **Submit Task**
  - Upload file
  - Add notes
  - Confirmation
- **Submission Status**
  - Submitted
  - Graded
  - Feedback

#### 6. Materi

- **Material List**
  - All materials
  - Filter by course
  - Search
- **View Material**
  - Download file
  - View online
  - Share

#### 7. Profile

- **View Profile**
  - Personal info
  - NIM
  - Photo
- **Edit Profile**
  - Update data
  - Change photo
  - Change password
- **Settings**
  - Notifications
  - Language
  - Theme

## 🎨 UI/UX Features

### Design Elements

#### 1. Modern Cards

- Rounded corners (12-16px)
- Soft shadows
- Hover effects
- Smooth transitions

#### 2. Color Coding

- **Admin**: Red theme
- **Dosen**: Blue theme
- **Mahasiswa**: Green theme
- **Status colors**: Success, warning, error

#### 3. Typography

- **Font**: Inter (Google Fonts)
- **Hierarchy**: Clear heading levels
- **Readability**: Optimal line height

#### 4. Icons

- Material Icons
- Consistent style
- Meaningful representations

#### 5. Animations

- Fade transitions
- Slide animations
- Loading states
- Success animations

### User Experience

#### 1. Navigation

- Bottom navigation bar
- Intuitive icons
- Active state indicators
- Smooth transitions

#### 2. Feedback

- Loading indicators
- Success messages
- Error alerts
- Confirmation dialogs

#### 3. Forms

- Clear labels
- Input validation
- Error messages
- Helper text

#### 4. Empty States

- Friendly messages
- Call-to-action
- Illustrations

#### 5. Loading States

- Skeleton screens
- Shimmer effects
- Progress indicators

## 🔔 Notifications

### Push Notifications

- New tugas assigned
- Deadline reminders
- QR code active
- Attendance confirmed

### In-App Notifications

- Real-time updates
- Badge counters
- Notification center

## 📊 Analytics & Reports

### For Admin

- User statistics
- Attendance trends
- Course popularity
- System usage

### For Dosen

- Class attendance
- Student performance
- Task completion rate
- Material downloads

### For Mahasiswa

- Personal attendance
- Grade tracking
- Task completion
- Study progress

## 🔒 Security Features

### Authentication

- Token-based auth
- Secure storage
- Auto logout
- Session management

### Authorization

- Role-based access
- Permission checks
- Protected routes
- API security

### Data Protection

- Encrypted storage
- Secure transmission
- Input validation
- XSS prevention

## 📱 Offline Features

### Offline Mode

- Cache data
- Queue actions
- Sync when online
- Offline indicator

### Local Storage

- User data
- Recent items
- Draft submissions
- Settings

## 🌐 Internationalization

### Language Support

- Indonesian (default)
- English
- Easy to add more

### Localization

- Date formats
- Number formats
- Currency
- Time zones

## ♿ Accessibility

### Features

- Screen reader support
- High contrast mode
- Font scaling
- Keyboard navigation

### WCAG Compliance

- Color contrast
- Focus indicators
- Alt text
- Semantic HTML

## 🚀 Performance

### Optimization

- Lazy loading
- Image caching
- Code splitting
- Minification

### Speed

- Fast startup
- Quick navigation
- Smooth animations
- Efficient API calls

## 🔄 Future Features

### Planned

- [ ] Video conferencing
- [ ] Live chat
- [ ] Forum discussion
- [ ] Quiz system
- [ ] Certificate generation
- [ ] Mobile app for iOS
- [ ] Web version
- [ ] Desktop app

### Under Consideration

- [ ] AI attendance prediction
- [ ] Face recognition
- [ ] Blockchain certificates
- [ ] Gamification
- [ ] Social features

---

**Note:** Fitur-fitur di atas akan terus dikembangkan dan ditingkatkan berdasarkan feedback pengguna.
