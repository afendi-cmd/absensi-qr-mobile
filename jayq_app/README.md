# JAYQ - Modern Attendance App

**Tagline:** Scan • Attend • Done

JAYQ adalah aplikasi absensi mahasiswa modern berbasis QR Code dengan desain minimalis dan clean. Aplikasi ini dibangun menggunakan Flutter dan terintegrasi dengan backend Laravel REST API.

## 🎨 Design Concept

- **Modern & Minimalis**: UI/UX yang clean dan mudah digunakan
- **Gen Z Style**: Desain yang fresh dan menarik
- **Mobile Friendly**: Responsive untuk semua ukuran layar Android
- **Professional**: Tampilan seperti aplikasi production-ready

## ✨ Features

### Multi-Role System

- **Admin**: Kelola user, mata kuliah, dan rekap absensi
- **Dosen**: Generate QR, upload materi, kelola tugas
- **Mahasiswa**: Scan QR, lihat mata kuliah, upload tugas

### Key Features

- ✅ QR Code Scanner untuk absensi
- ✅ Real-time attendance tracking
- ✅ File upload (materi & tugas)
- ✅ Dashboard statistik
- ✅ Riwayat absensi
- ✅ Notifikasi tugas
- ✅ Profile management

## 🛠 Tech Stack

### Frontend

- **Flutter** - Latest version
- **Dart** - Programming language
- **Provider** - State management
- **HTTP/Dio** - API integration
- **Mobile Scanner** - QR code scanning
- **Google Fonts** - Typography

### Backend Integration

- **Laravel REST API** - Backend service
- **JSON API** - Data format
- **Token Authentication** - Security
- **File Storage** - Upload handling

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── app_colors.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── utils/
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── mata_kuliah_model.dart
│   │   ├── absensi_model.dart
│   │   ├── tugas_model.dart
│   │   └── materi_model.dart
│   └── services/
│       ├── api_service.dart
│       ├── storage_service.dart
│       └── auth_service.dart
├── providers/
│   └── auth_provider.dart
├── screens/
│   ├── splash/
│   ├── auth/
│   ├── admin/
│   ├── dosen/
│   ├── mahasiswa/
│   └── shared/
├── widgets/
│   └── common/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── stat_card.dart
├── routes/
│   └── app_routes.dart
└── main.dart
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Android Studio / VS Code
- Android device or emulator
- Laravel backend running

### Installation

1. **Clone the repository**

```bash
git clone <repository-url>
cd jayq_app
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure API endpoint**
   Edit `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'http://your-api-url/api';
```

4. **Run the app**

```bash
flutter run
```

## 🎯 Usage

### Demo Accounts

**Admin:**

- Email: admin@jayq.com
- Password: password

**Dosen:**

- Email: dosen@jayq.com
- Password: password

**Mahasiswa:**

- Email: mahasiswa@jayq.com
- Password: password

### Main Flows

#### Admin Flow

1. Login sebagai admin
2. Kelola user (dosen & mahasiswa)
3. Kelola mata kuliah
4. Tambah peserta ke mata kuliah
5. Lihat rekap absensi

#### Dosen Flow

1. Login sebagai dosen
2. Pilih mata kuliah
3. Generate QR code untuk absensi
4. Upload materi pembelajaran
5. Buat dan kelola tugas
6. Lihat rekap kehadiran mahasiswa

#### Mahasiswa Flow

1. Login sebagai mahasiswa
2. Scan QR code untuk absen
3. Lihat mata kuliah yang diambil
4. Download materi
5. Upload tugas
6. Lihat riwayat absensi

## 🎨 UI Components

### Color Scheme

- **Primary**: Deep Blue (#1E3A8A)
- **Secondary**: Indigo (#6366F1)
- **Success**: Green (#10B981)
- **Warning**: Orange (#F59E0B)
- **Error**: Red (#EF4444)

### Typography

- **Font Family**: Inter (Google Fonts)
- **Heading**: Bold, 24-32px
- **Body**: Regular, 14-16px
- **Caption**: Regular, 12px

### Components

- Modern card design with shadows
- Rounded corners (12-16px)
- Gradient backgrounds
- Smooth animations
- Loading states
- Empty states

## 📱 Screens

### Implemented

- ✅ Splash Screen
- ✅ Login Screen
- ✅ Admin Dashboard
- ✅ Dosen Dashboard
- ✅ Mahasiswa Dashboard

### To Be Implemented

- ⏳ QR Scanner Screen
- ⏳ Generate QR Screen
- ⏳ Mata Kuliah List
- ⏳ Upload Materi Screen
- ⏳ Upload Tugas Screen
- ⏳ Rekap Absensi Screen
- ⏳ Profile Screen
- ⏳ Settings Screen

## 🔧 Configuration

### Android Permissions

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
```

### iOS Permissions

Add to `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera permission is required for QR code scanning</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>Photo library access is required for file upload</string>
```

## 🧪 Testing

```bash
# Run tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📦 Build

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🤝 Contributing

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👥 Team

- **Developer**: Your Name
- **Designer**: Your Name
- **Backend**: Laravel Team

## 📞 Support

For support, email support@jayq.com or join our Slack channel.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Google Fonts for beautiful typography
- Community packages contributors

---

**Made with ❤️ using Flutter**
