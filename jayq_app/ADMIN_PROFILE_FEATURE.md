# Admin Profile & Dark Mode Feature

## 📋 Overview

Fitur halaman profil admin yang lengkap dengan dukungan mode gelap (dark mode) untuk meningkatkan pengalaman pengguna.

## ✨ Fitur Utama

### 1. **Halaman Profil Admin**

Halaman profil yang komprehensif dengan informasi dan pengaturan admin:

#### Informasi Profil

- Avatar dengan inisial nama
- Nama lengkap admin
- Email admin
- Badge role "Administrator"

#### Pengaturan (Settings)

- **Mode Gelap**: Toggle switch untuk mengaktifkan/menonaktifkan dark mode
- **Notifikasi**: Pengaturan notifikasi aplikasi
- **Bahasa**: Pemilihan bahasa (default: Indonesia)

#### Akun (Account)

- **Edit Profil**: Mengubah informasi profil
- **Ubah Password**: Mengganti password akun
- **Keamanan**: Pengaturan keamanan akun

#### Tentang (About)

- **Bantuan & Dukungan**: Akses ke pusat bantuan
- **Syarat & Ketentuan**: Membaca syarat dan ketentuan
- **Kebijakan Privasi**: Informasi kebijakan privasi
- **Tentang Aplikasi**: Informasi versi aplikasi (v1.0.0)

#### Logout

- Tombol logout dengan konfirmasi dialog
- Redirect ke halaman login setelah logout

### 2. **Dark Mode**

Mode gelap yang konsisten di seluruh aplikasi:

#### Fitur Dark Mode

- Toggle switch di halaman profil
- Preferensi tersimpan secara persisten menggunakan SharedPreferences
- Transisi smooth antara light dan dark mode
- Warna yang disesuaikan untuk readability optimal

#### Color Scheme

**Light Mode:**

- Background: `#F5F5F5`
- Surface: `#FFFFFF`
- Primary: `#2563EB`
- Text: `#111827`

**Dark Mode:**

- Background: `#111827`
- Surface: `#1F2937`
- Primary: `#3B82F6`
- Text: `#FFFFFF`

## 🗂️ File Structure

```
lib/
├── providers/
│   └── theme_provider.dart          # Provider untuk mengelola theme
├── screens/
│   └── admin/
│       ├── admin_dashboard_screen.dart  # Dashboard dengan dark mode support
│       └── admin_profile_screen.dart    # Halaman profil admin
└── main.dart                        # Updated dengan ThemeProvider
```

## 🔧 Implementasi Teknis

### 1. Theme Provider

```dart
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  // Load preference dari SharedPreferences
  // Toggle theme
  // Provide light & dark theme
}
```

### 2. Admin Profile Screen

- Responsive design
- Dark mode support
- Section-based layout
- Material Design 3 components

### 3. Admin Dashboard Updates

- Dark mode support di semua komponen
- Dynamic color berdasarkan theme
- Smooth transitions

## 🎨 Design Principles

### Accessibility

- High contrast colors untuk readability
- Consistent spacing dan sizing
- Clear visual hierarchy

### User Experience

- Intuitive navigation
- Clear section grouping
- Immediate visual feedback
- Persistent preferences

### Visual Design

- Modern Material Design 3
- Rounded corners (16px)
- Subtle shadows
- Smooth animations

## 📱 Navigasi

### Dari Dashboard ke Profile

```dart
// Tap icon "Profil" di bottom navigation
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const AdminProfileScreen(),
  ),
);
```

### Toggle Dark Mode

```dart
// Di halaman profil, toggle switch
themeProvider.toggleTheme();
```

## 🔐 Security Features

- Logout confirmation dialog
- Secure password change flow
- Protected admin routes

## 📊 State Management

Menggunakan Provider untuk:

- Theme state (dark/light mode)
- User authentication state
- Persistent preferences

## 🚀 Usage

### Mengakses Halaman Profil

1. Login sebagai admin
2. Tap icon "Profil" di bottom navigation
3. Halaman profil akan terbuka

### Mengaktifkan Dark Mode

1. Buka halaman profil
2. Di section "PENGATURAN"
3. Toggle switch "Mode Gelap"
4. Theme akan berubah secara real-time

### Logout

1. Scroll ke bawah halaman profil
2. Tap tombol "Keluar dari Akun"
3. Konfirmasi di dialog
4. Redirect ke login screen

## 🎯 Future Enhancements

- [ ] Edit profil functionality
- [ ] Change password implementation
- [ ] Notification settings
- [ ] Language selection
- [ ] Profile picture upload
- [ ] Activity log
- [ ] Two-factor authentication
- [ ] Biometric authentication

## 📝 Notes

- Dark mode preference tersimpan secara lokal
- Theme berlaku untuk seluruh aplikasi
- Semua screen admin sudah support dark mode
- Design mengikuti Material Design 3 guidelines

## 🐛 Known Issues

Tidak ada issue yang diketahui saat ini.

## 📞 Support

Untuk pertanyaan atau masalah, silakan hubungi tim development.
