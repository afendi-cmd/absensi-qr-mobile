# 🔧 Cara Memperbaiki Icon Terpotong

## ❌ Masalah

Icon aplikasi JAYQ terpotong di bagian atas (topi toga) dan samping.

## ✅ Solusi yang Sudah Diterapkan

### 1. Update pubspec.yaml

Padding sudah ditingkatkan dari **20** menjadi **50**:

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/logo/image.png"
  adaptive_icon_background: "#F8F9FB"
  adaptive_icon_foreground: "assets/logo/image.png"
  adaptive_icon_padding: 50 # ✅ Padding 50 untuk icon kompleks
  min_sdk_android: 21
  remove_alpha_ios: true
```

### 2. Regenerate Icon

Jalankan command:

```bash
flutter pub run flutter_launcher_icons
```

### 3. Rebuild Aplikasi

```bash
flutter run
# atau
flutter build apk
```

## 📊 Panduan Padding

| Padding | Hasil                | Cocok Untuk                  |
| ------- | -------------------- | ---------------------------- |
| 0-10    | ❌ Terpotong         | -                            |
| 20-30   | ⚠️ Mungkin terpotong | Icon sederhana               |
| 40-50   | ✅ Aman              | Icon kompleks (toga, detail) |
| 60-70   | ✅ Sangat aman       | Icon dengan banyak detail    |
| 80+     | ⚠️ Terlalu kecil     | -                            |

## 🎯 Untuk Icon JAYQ (Toga)

**Rekomendasi: Padding 50-60**

Karena icon toga memiliki:

- Bagian atas (topi) yang tinggi
- Detail di samping kiri-kanan
- Bentuk yang tidak simetris

## 🔄 Jika Masih Terpotong

### Opsi 1: Tingkatkan Padding Lagi

```yaml
adaptive_icon_padding: 60 # Naikkan ke 60
```

### Opsi 2: Edit Icon Secara Manual

1. Buka `assets/logo/image.png` di image editor
2. Tambahkan canvas/padding manual
3. Resize icon menjadi lebih kecil di tengah
4. Save dan regenerate

### Opsi 3: Buat Icon Khusus Android

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/logo/icon_ios.png" # Icon untuk iOS
  adaptive_icon_background: "#F8F9FB"
  adaptive_icon_foreground: "assets/logo/icon_android.png" # Icon khusus Android (sudah ada padding)
  adaptive_icon_padding: 0 # Tidak perlu padding karena sudah ada di image
```

## 📱 Testing

Setelah regenerate icon, test di:

1. **Emulator/Device**

   ```bash
   flutter run
   ```

2. **Berbagai Launcher**
   - Google Pixel Launcher
   - Samsung One UI
   - Xiaomi MIUI
   - OnePlus OxygenOS

3. **Berbagai Bentuk**
   - Circle (bulat)
   - Rounded Square (persegi bulat)
   - Squircle (campuran)

## 🎨 Tips Desain Icon

### Safe Zone untuk Adaptive Icon

```
┌─────────────────────────────┐
│     Padding Area (50%)      │
│  ┌───────────────────────┐  │
│  │                       │  │
│  │    Safe Zone (66%)    │  │
│  │   Icon harus di sini  │  │
│  │                       │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

### Checklist Icon yang Baik

- [ ] Icon terlihat jelas di ukuran kecil
- [ ] Tidak ada elemen penting di tepi
- [ ] Terlihat baik dalam bentuk circle
- [ ] Terlihat baik dalam bentuk square
- [ ] Background color kontras dengan foreground
- [ ] Icon tidak terlalu kompleks

## 🚀 Quick Fix

Jika masih terpotong setelah padding 50, langsung gunakan padding 60:

```bash
# Edit pubspec.yaml
adaptive_icon_padding: 60

# Regenerate
flutter pub run flutter_launcher_icons

# Test
flutter run
```

## 📞 Troubleshooting

### Icon tidak berubah setelah regenerate?

1. **Uninstall aplikasi lama**

   ```bash
   flutter clean
   flutter pub get
   flutter pub run flutter_launcher_icons
   flutter run
   ```

2. **Clear cache launcher**
   - Buka Settings > Apps > Launcher
   - Clear cache & data
   - Restart device

3. **Rebuild dari awal**
   ```bash
   flutter clean
   flutter pub get
   flutter pub run flutter_launcher_icons
   flutter build apk --release
   ```

---

**Status: ✅ Padding sudah diupdate ke 50**
**Next: Test di device dan lihat hasilnya**
