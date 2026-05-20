# 🎨 Panduan Icon Aplikasi JAYQ

## Masalah Icon Terpotong

Jika icon aplikasi terlihat terpotong pada perangkat Android, ini disebabkan oleh:

1. Icon terlalu besar untuk area adaptive icon
2. Tidak ada padding yang cukup
3. Safe zone tidak dipertimbangkan

## Solusi

### 1. Menggunakan Padding di pubspec.yaml

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/logo/image.png"
  adaptive_icon_background: "#F8F9FB"
  adaptive_icon_foreground: "assets/logo/image.png"
  adaptive_icon_padding: 20 # Tambahkan padding (0-100)
  min_sdk_android: 21
  remove_alpha_ios: true
```

**Nilai padding yang disarankan:**

- `0` = Tidak ada padding (icon bisa terpotong)
- `10-20` = Padding minimal (recommended)
- `30-40` = Padding sedang
- `50+` = Padding besar (icon terlalu kecil)

### 2. Regenerate Icon

Setelah mengubah konfigurasi, jalankan:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

### 3. Membuat Icon dengan Safe Zone

Jika ingin membuat icon baru, pastikan:

**Ukuran Icon:**

- **1024x1024 px** (ukuran standar)
- **Safe zone**: 768x768 px (75% dari total)
- **Padding**: 128 px dari setiap sisi

**Contoh:**

```
┌─────────────────────────┐
│  Padding (128px)        │
│  ┌─────────────────┐    │
│  │                 │    │
│  │   Safe Zone     │    │
│  │   768x768 px    │    │
│  │                 │    │
│  └─────────────────┘    │
│                         │
└─────────────────────────┘
     1024x1024 px
```

## Tips Desain Icon

### ✅ DO (Lakukan)

- Gunakan desain sederhana dan jelas
- Pastikan icon terlihat baik dalam ukuran kecil
- Gunakan warna kontras yang baik
- Pertimbangkan berbagai bentuk mask (circle, rounded square, squircle)
- Test di berbagai perangkat dan launcher

### ❌ DON'T (Jangan)

- Jangan gunakan detail yang terlalu kecil
- Jangan letakkan elemen penting di tepi
- Jangan gunakan teks yang terlalu kecil
- Jangan abaikan safe zone

## Android Adaptive Icon

Android menggunakan adaptive icon yang terdiri dari:

1. **Background Layer** - Warna solid atau gambar
2. **Foreground Layer** - Icon utama (harus transparan)

**Bentuk Mask yang Berbeda:**

- Circle (bulat penuh)
- Rounded Square (persegi dengan sudut membulat)
- Squircle (antara circle dan square)
- Square (persegi penuh)

Icon Anda akan di-crop sesuai dengan launcher yang digunakan.

## Testing Icon

### 1. Test di Emulator

```bash
flutter run
```

### 2. Test di Device Fisik

```bash
flutter install
```

### 3. Test Berbagai Launcher

- Google Pixel Launcher
- Samsung One UI
- Xiaomi MIUI
- OnePlus OxygenOS
- Stock Android

## Troubleshooting

### Icon Masih Terpotong?

**Solusi 1: Tingkatkan Padding**

```yaml
adaptive_icon_padding: 30 # Naikkan dari 20 ke 30
```

**Solusi 2: Buat Icon Lebih Kecil**
Edit file `assets/logo/image.png` dan tambahkan margin/padding secara manual menggunakan image editor.

**Solusi 3: Gunakan Icon Terpisah**

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/logo/icon_ios.png" # Icon untuk iOS
  adaptive_icon_background: "#F8F9FB"
  adaptive_icon_foreground: "assets/logo/icon_android.png" # Icon khusus Android
  adaptive_icon_padding: 0 # Karena sudah ada padding di image
```

### Icon Terlalu Kecil?

Kurangi nilai padding:

```yaml
adaptive_icon_padding: 10 # Turunkan padding
```

## Tools Rekomendasi

### Design Tools

- **Figma** - Design icon online
- **Adobe Illustrator** - Professional vector design
- **Inkscape** - Free vector editor
- **Canva** - Simple online design

### Icon Generator

- **Android Asset Studio** - https://romannurik.github.io/AndroidAssetStudio/
- **App Icon Generator** - https://appicon.co/
- **Icon Kitchen** - https://icon.kitchen/

## Checklist Icon

Sebelum publish aplikasi, pastikan:

- [ ] Icon terlihat jelas di ukuran kecil (48x48 dp)
- [ ] Icon tidak terpotong di berbagai launcher
- [ ] Background color sesuai dengan brand
- [ ] Icon terlihat baik di light dan dark mode
- [ ] File icon tidak terlalu besar (< 500 KB)
- [ ] Icon memiliki format yang benar (PNG dengan transparency)
- [ ] Test di minimal 3 perangkat berbeda

## Referensi

- [Material Design - Product Icons](https://m3.material.io/styles/icons/designing-icons)
- [Android Adaptive Icons](https://developer.android.com/develop/ui/views/launch/icon_design_adaptive)
- [Flutter Launcher Icons Package](https://pub.dev/packages/flutter_launcher_icons)

---

**Dibuat untuk JAYQ App**
_Last updated: 2026_
