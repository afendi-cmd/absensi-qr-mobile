# JAYQ - Setup Guide

Panduan lengkap untuk setup dan menjalankan aplikasi JAYQ.

## 📋 Prerequisites

Pastikan Anda sudah menginstall:

1. **Flutter SDK** (versi terbaru)
   - Download dari: https://flutter.dev/docs/get-started/install
   - Verifikasi: `flutter --version`

2. **Android Studio** atau **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

3. **Android SDK & Emulator**
   - Bisa diinstall melalui Android Studio
   - Atau gunakan device Android fisik

4. **Git**
   - Download dari: https://git-scm.com/

## 🚀 Installation Steps

### 1. Clone Project

```bash
cd jayq_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Konfigurasi Backend API

Edit file `lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'http://localhost:8000/api';
```

**Catatan:**

- Jika menggunakan emulator Android: `http://10.0.2.2:8000/api`
- Jika menggunakan device fisik: `http://YOUR_IP:8000/api`
- Contoh: `http://192.168.1.100:8000/api`

### 4. Setup Android Permissions

File `android/app/src/main/AndroidManifest.xml` sudah dikonfigurasi dengan permissions:

- Camera (untuk QR scanner)
- Internet (untuk API calls)
- Storage (untuk upload file)

### 5. Jalankan Aplikasi

```bash
# Cek device yang tersedia
flutter devices

# Run aplikasi
flutter run

# Atau pilih device spesifik
flutter run -d <device_id>
```

## 🔧 Configuration

### Backend Connection

Pastikan backend Laravel sudah running:

```bash
cd backendabsensi
php artisan serve
```

Backend akan berjalan di `http://localhost:8000`

### Test API Connection

Anda bisa test API menggunakan:

- Postman
- Browser: `http://localhost:8000/api/login`
- Atau langsung dari aplikasi

## 👤 Demo Accounts

Gunakan akun berikut untuk testing:

### Admin

- **Email**: admin@jayq.com
- **Password**: password
- **Role**: admin

### Dosen

- **Email**: dosen@jayq.com
- **Password**: password
- **Role**: dosen

### Mahasiswa

- **Email**: mahasiswa@jayq.com
- **Password**: password
- **Role**: mahasiswa

## 📱 Running on Physical Device

### Android

1. **Enable Developer Options**
   - Settings → About Phone
   - Tap "Build Number" 7 times

2. **Enable USB Debugging**
   - Settings → Developer Options
   - Enable "USB Debugging"

3. **Connect Device**
   - Connect via USB
   - Allow USB debugging on device
   - Run: `flutter devices`
   - Run: `flutter run`

### iOS (Mac only)

1. Open project in Xcode
2. Select your device
3. Run from Xcode or `flutter run`

## 🏗 Build APK

### Debug APK

```bash
flutter build apk --debug
```

### Release APK

```bash
flutter build apk --release
```

APK akan tersimpan di: `build/app/outputs/flutter-apk/`

### App Bundle (untuk Play Store)

```bash
flutter build appbundle --release
```

## 🐛 Troubleshooting

### 1. Dependencies Error

```bash
flutter clean
flutter pub get
```

### 2. Gradle Build Error

```bash
cd android
./gradlew clean
cd ..
flutter run
```

### 3. Camera Permission Error

Pastikan permissions sudah ditambahkan di `AndroidManifest.xml`

### 4. API Connection Error

- Cek backend sudah running
- Cek IP address sudah benar
- Cek firewall tidak memblokir koneksi
- Untuk emulator gunakan `10.0.2.2` bukan `localhost`

### 5. Hot Reload Not Working

```bash
# Stop app
# Run again
flutter run
```

## 📂 Project Structure

```
jayq_app/
├── android/              # Android native code
├── ios/                  # iOS native code
├── lib/                  # Flutter source code
│   ├── core/            # Core utilities
│   ├── data/            # Models & Services
│   ├── providers/       # State management
│   ├── screens/         # UI Screens
│   ├── widgets/         # Reusable widgets
│   ├── routes/          # Navigation
│   └── main.dart        # Entry point
├── assets/              # Images, icons, fonts
├── pubspec.yaml         # Dependencies
└── README.md            # Documentation
```

## 🎨 Customization

### Change App Name

Edit `android/app/src/main/AndroidManifest.xml`:

```xml
<application
    android:label="JAYQ"
    ...>
```

### Change App Icon

1. Prepare icon (1024x1024 px)
2. Use: https://appicon.co/
3. Replace files in:
   - `android/app/src/main/res/mipmap-*/`
   - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Change Theme Colors

Edit `lib/core/constants/app_colors.dart`:

```dart
static const Color primary = Color(0xFF1E3A8A);
```

## 📊 Features Status

### ✅ Implemented

- Splash Screen
- Login Screen
- Admin Dashboard
- Dosen Dashboard
- Mahasiswa Dashboard
- Authentication Flow
- API Integration
- State Management

### 🚧 In Progress

- QR Scanner
- Generate QR Code
- Upload File
- Rekap Absensi
- Profile Management

### 📝 Planned

- Push Notifications
- Dark Mode
- Offline Mode
- Export PDF
- Analytics

## 🔐 Security

- Token-based authentication
- Secure storage for sensitive data
- HTTPS recommended for production
- Input validation
- Error handling

## 📈 Performance

- Lazy loading
- Image caching
- Optimized builds
- Minimal dependencies
- Clean architecture

## 🤝 Development Workflow

1. Create feature branch
2. Develop feature
3. Test thoroughly
4. Create pull request
5. Code review
6. Merge to main

## 📞 Support

Jika mengalami masalah:

1. Cek dokumentasi ini
2. Cek Flutter documentation
3. Cek GitHub issues
4. Contact developer

## 🎓 Learning Resources

- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Provider: https://pub.dev/packages/provider
- Material Design: https://material.io/

## ✅ Checklist Setup

- [ ] Flutter SDK installed
- [ ] Android Studio/VS Code installed
- [ ] Project cloned
- [ ] Dependencies installed
- [ ] Backend running
- [ ] API endpoint configured
- [ ] Device/emulator ready
- [ ] App running successfully
- [ ] Login tested
- [ ] All roles tested

## 🎉 Next Steps

Setelah setup berhasil:

1. Explore aplikasi dengan 3 role berbeda
2. Test semua fitur yang ada
3. Lanjutkan development fitur baru
4. Customize sesuai kebutuhan
5. Deploy ke production

---

**Happy Coding! 🚀**
