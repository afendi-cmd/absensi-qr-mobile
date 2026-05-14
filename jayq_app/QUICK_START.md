# JAYQ - Quick Start Guide

Panduan cepat untuk menjalankan aplikasi JAYQ dalam 5 menit!

## ⚡ Quick Setup (5 Minutes)

### 1. Prerequisites Check ✓

```bash
# Check Flutter
flutter --version

# Check devices
flutter devices
```

### 2. Install Dependencies ✓

```bash
cd jayq_app
flutter pub get
```

### 3. Configure Backend URL ✓

Edit `lib/core/constants/app_constants.dart`:

**Untuk Emulator Android:**

```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

**Untuk Device Fisik:**

```dart
static const String baseUrl = 'http://192.168.1.XXX:8000/api';
```

_Ganti XXX dengan IP komputer Anda_

### 4. Start Backend ✓

```bash
cd backendabsensi
php artisan serve
```

### 5. Run App ✓

```bash
cd jayq_app
flutter run
```

## 🎯 Test Login

### Admin

```
Email: admin@jayq.com
Password: password
```

### Dosen

```
Email: dosen@jayq.com
Password: password
```

### Mahasiswa

```
Email: mahasiswa@jayq.com
Password: password
```

## 📱 What You'll See

### 1. Splash Screen (2 seconds)

- JAYQ logo dengan animasi
- Tagline: "Scan • Attend • Done"
- Loading animation

### 2. Login Screen

- Modern login form
- Email & password fields
- Remember me checkbox
- Demo accounts info

### 3. Dashboard (Based on Role)

**Admin Dashboard:**

- Statistics cards (4 cards)
- Quick actions menu
- Recent activity
- Bottom navigation

**Dosen Dashboard:**

- Statistics grid
- Generate QR button
- Upload materi button
- Mata kuliah list

**Mahasiswa Dashboard:**

- Large Scan QR button
- Statistics cards
- Mata kuliah cards
- Upcoming tasks

## 🎨 UI Preview

### Color Scheme

- **Primary**: Deep Blue (#1E3A8A)
- **Secondary**: Indigo (#6366F1)
- **Success**: Green (#10B981)

### Design Style

- Modern & Minimalist
- Rounded corners
- Soft shadows
- Gradient backgrounds
- Smooth animations

## 🔧 Common Issues & Solutions

### Issue 1: "No devices found"

**Solution:**

```bash
# For Android Emulator
# Open Android Studio → AVD Manager → Start Emulator

# For Physical Device
# Enable USB Debugging in Developer Options
```

### Issue 2: "Dependencies error"

**Solution:**

```bash
flutter clean
flutter pub get
```

### Issue 3: "Cannot connect to backend"

**Solution:**

- Check backend is running: `php artisan serve`
- Check IP address is correct
- For emulator use: `10.0.2.2`
- For device use: Your computer's IP

### Issue 4: "Gradle build failed"

**Solution:**

```bash
cd android
./gradlew clean
cd ..
flutter run
```

## 📂 Project Structure

```
jayq_app/
├── lib/
│   ├── core/           # Constants, theme, utils
│   ├── data/           # Models, services
│   ├── providers/      # State management
│   ├── screens/        # UI screens
│   ├── widgets/        # Reusable widgets
│   └── main.dart       # Entry point
├── assets/             # Images, icons
└── android/            # Android config
```

## 🚀 Next Steps

After successful run:

1. **Explore the App**
   - Login with different roles
   - Navigate through dashboards
   - Check UI/UX design

2. **Test Features**
   - Authentication flow
   - Role-based access
   - Navigation
   - Logout

3. **Development**
   - Implement QR Scanner
   - Add more screens
   - Connect to real API
   - Add more features

## 📚 Documentation

- **README.md** - Overview & introduction
- **SETUP_GUIDE.md** - Detailed setup instructions
- **API_INTEGRATION.md** - API documentation
- **FEATURES.md** - Complete feature list
- **PROJECT_SUMMARY.md** - What's implemented

## 💡 Tips

### Hot Reload

Press `r` in terminal for hot reload
Press `R` for hot restart

### Debug Mode

```bash
flutter run --debug
```

### Release Mode

```bash
flutter run --release
```

### Check Performance

```bash
flutter run --profile
```

## 🎓 Learning Path

1. **Day 1**: Setup & Run
   - Install dependencies
   - Run the app
   - Test login

2. **Day 2**: Explore Code
   - Check project structure
   - Read models
   - Understand services

3. **Day 3**: Add Features
   - Implement QR Scanner
   - Add new screens
   - Connect API

4. **Day 4**: Customize
   - Change colors
   - Modify UI
   - Add animations

5. **Day 5**: Deploy
   - Build APK
   - Test on device
   - Share with users

## 🎯 Goals

### Short Term (1 Week)

- ✅ Setup complete
- ✅ App running
- ✅ Login working
- ⏳ QR Scanner implemented
- ⏳ File upload working

### Medium Term (1 Month)

- ⏳ All screens completed
- ⏳ API fully integrated
- ⏳ Testing done
- ⏳ Bug fixes

### Long Term (3 Months)

- ⏳ Production ready
- ⏳ Published to Play Store
- ⏳ User feedback
- ⏳ Version 2.0 planning

## 🤝 Need Help?

### Resources

- Flutter Docs: https://flutter.dev/docs
- Dart Docs: https://dart.dev/guides
- Stack Overflow: Search "Flutter [your issue]"

### Community

- Flutter Discord
- Reddit r/FlutterDev
- GitHub Issues

### Contact

- Email: support@jayq.com
- GitHub: [Your GitHub]
- Discord: [Your Discord]

## ✅ Checklist

Before you start:

- [ ] Flutter installed
- [ ] Android Studio/VS Code installed
- [ ] Device/Emulator ready
- [ ] Backend running
- [ ] Dependencies installed
- [ ] API configured

After first run:

- [ ] App launched successfully
- [ ] Login working
- [ ] Dashboard showing
- [ ] Navigation working
- [ ] No errors in console

## 🎉 Success!

If you see the dashboard, congratulations! 🎊

You now have:

- ✅ Modern Flutter app running
- ✅ Multi-role authentication
- ✅ Beautiful UI/UX
- ✅ Clean architecture
- ✅ Ready for development

**Next**: Start implementing remaining features!

---

**Happy Coding! 🚀**

_Made with ❤️ using Flutter_
