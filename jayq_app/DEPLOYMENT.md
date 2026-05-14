# JAYQ - Deployment Guide

Panduan lengkap untuk build dan deploy aplikasi JAYQ.

## 📦 Build APK

### Debug APK (Development)

```bash
flutter build apk --debug
```

**Output:**

- Location: `build/app/outputs/flutter-apk/app-debug.apk`
- Size: ~40-50 MB
- Use: Testing & development

### Release APK (Production)

```bash
flutter build apk --release
```

**Output:**

- Location: `build/app/outputs/flutter-apk/app-release.apk`
- Size: ~15-20 MB (optimized)
- Use: Production deployment

### Split APK by ABI (Recommended)

```bash
flutter build apk --split-per-abi --release
```

**Output:**

- `app-armeabi-v7a-release.apk` (~12 MB)
- `app-arm64-v8a-release.apk` (~15 MB)
- `app-x86_64-release.apk` (~16 MB)

**Benefits:**

- Smaller file size
- Faster download
- Better performance

## 📱 Build App Bundle (Play Store)

### Android App Bundle (AAB)

```bash
flutter build appbundle --release
```

**Output:**

- Location: `build/app/outputs/bundle/release/app-release.aab`
- Size: ~20-25 MB
- Use: Google Play Store upload

**Benefits:**

- Dynamic delivery
- Smaller downloads
- Automatic optimization

## 🔐 Code Signing

### Generate Keystore

```bash
keytool -genkey -v -keystore jayq-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias jayq
```

**Information needed:**

- Password
- Name
- Organization
- City
- State
- Country

### Configure Signing

Create `android/key.properties`:

```properties
storePassword=your_store_password
keyPassword=your_key_password
keyAlias=jayq
storeFile=../jayq-release-key.jks
```

Update `android/app/build.gradle`:

```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    ...

    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }

    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

## 🎨 App Icon

### Generate Icons

1. **Prepare Icon**
   - Size: 1024x1024 px
   - Format: PNG
   - No transparency
   - Square shape

2. **Use Online Tool**
   - Visit: https://appicon.co/
   - Upload icon
   - Download Android icons

3. **Replace Icons**
   - Copy to: `android/app/src/main/res/mipmap-*/`
   - Replace all `ic_launcher.png` files

### Using flutter_launcher_icons

Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/icon/icon.png"
```

Run:

```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

## 🎬 Splash Screen

### Native Splash Screen

1. **Prepare Image**
   - Size: 1242x2688 px
   - Format: PNG
   - Centered logo

2. **Use flutter_native_splash**

Add to `pubspec.yaml`:

```yaml
dev_dependencies:
  flutter_native_splash: ^2.3.5

flutter_native_splash:
  color: "#1E3A8A"
  image: assets/logo/splash.png
  android: true
  ios: true
```

Run:

```bash
flutter pub get
flutter pub run flutter_native_splash:create
```

## 🌐 Environment Configuration

### Development

`lib/core/constants/app_constants.dart`:

```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

### Staging

```dart
static const String baseUrl = 'https://staging.jayq.com/api';
```

### Production

```dart
static const String baseUrl = 'https://api.jayq.com/api';
```

### Using Flavors

Create different configurations:

- `lib/main_dev.dart`
- `lib/main_staging.dart`
- `lib/main_prod.dart`

## 📊 Version Management

### Update Version

Edit `pubspec.yaml`:

```yaml
version: 1.0.0+1
```

Format: `major.minor.patch+buildNumber`

Example:

- `1.0.0+1` - Initial release
- `1.0.1+2` - Bug fix
- `1.1.0+3` - New features
- `2.0.0+4` - Major update

### Version Code (Android)

In `android/app/build.gradle`:

```gradle
defaultConfig {
    versionCode flutterVersionCode.toInteger()
    versionName flutterVersionName
}
```

## 🚀 Google Play Store

### Prerequisites

1. **Google Play Console Account**
   - Cost: $25 (one-time)
   - URL: https://play.google.com/console

2. **App Information**
   - App name: JAYQ
   - Package name: com.jayq.jayq_app
   - Category: Education
   - Content rating: Everyone

3. **Store Listing**
   - Short description (80 chars)
   - Full description (4000 chars)
   - Screenshots (2-8 images)
   - Feature graphic (1024x500 px)
   - App icon (512x512 px)

### Upload Steps

1. **Create App**
   - Go to Play Console
   - Create new app
   - Fill basic information

2. **Store Listing**
   - Add descriptions
   - Upload screenshots
   - Add graphics
   - Set category

3. **Content Rating**
   - Complete questionnaire
   - Get rating

4. **Pricing & Distribution**
   - Set free/paid
   - Select countries
   - Accept policies

5. **App Release**
   - Create release
   - Upload AAB file
   - Add release notes
   - Review and publish

### Release Tracks

- **Internal Testing**: Team only
- **Closed Testing**: Selected users
- **Open Testing**: Public beta
- **Production**: All users

## 📸 Screenshots

### Required Sizes

**Phone:**

- Minimum: 320 px
- Maximum: 3840 px
- Aspect ratio: 16:9 or 9:16

**Tablet (Optional):**

- 7-inch: 1024x600 px
- 10-inch: 1920x1200 px

### Capture Screenshots

```bash
# Run app
flutter run

# Take screenshot
# Use device screenshot button
# Or use Android Studio Device File Explorer
```

### Tools

- **Figma**: Design mockups
- **Canva**: Add text/graphics
- **Photoshop**: Edit images

## 📝 Release Notes

### Template

```
Version 1.0.0

What's New:
• Modern attendance app with QR code
• Multi-role system (Admin, Dosen, Mahasiswa)
• Real-time attendance tracking
• Upload materials and assignments
• View attendance reports

Improvements:
• Better performance
• Bug fixes
• UI enhancements

Thank you for using JAYQ!
```

## 🔍 Pre-Launch Checklist

### Code

- [ ] All features working
- [ ] No console errors
- [ ] No warnings
- [ ] Code optimized
- [ ] Comments added
- [ ] Documentation updated

### Testing

- [ ] Tested on emulator
- [ ] Tested on device
- [ ] Tested all roles
- [ ] Tested all features
- [ ] Tested edge cases
- [ ] Performance tested

### Configuration

- [ ] API URL correct
- [ ] App name correct
- [ ] Package name correct
- [ ] Version updated
- [ ] Icons updated
- [ ] Splash screen updated

### Security

- [ ] API keys secured
- [ ] Sensitive data encrypted
- [ ] Permissions minimal
- [ ] Code obfuscated
- [ ] ProGuard enabled

### Store Listing

- [ ] Screenshots ready
- [ ] Description written
- [ ] Graphics prepared
- [ ] Privacy policy ready
- [ ] Terms of service ready

## 🛡️ Security

### Code Obfuscation

```bash
flutter build apk --release --obfuscate --split-debug-info=build/debug-info
```

### ProGuard Rules

Create `android/app/proguard-rules.pro`:

```proguard
-keep class com.jayq.jayq_app.** { *; }
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**
```

### Remove Debug Info

```bash
flutter build apk --release --no-tree-shake-icons
```

## 📊 Analytics

### Firebase Analytics

1. **Setup Firebase**
   - Create project
   - Add Android app
   - Download `google-services.json`
   - Place in `android/app/`

2. **Add Dependencies**

```yaml
dependencies:
  firebase_core: ^2.24.2
  firebase_analytics: ^10.7.4
```

3. **Initialize**

```dart
await Firebase.initializeApp();
```

### Track Events

```dart
FirebaseAnalytics.instance.logEvent(
  name: 'login',
  parameters: {'role': 'mahasiswa'},
);
```

## 🐛 Crash Reporting

### Firebase Crashlytics

```yaml
dependencies:
  firebase_crashlytics: ^3.4.8
```

```dart
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
```

## 📈 Performance

### Optimize Build

```bash
flutter build apk --release --target-platform android-arm64
```

### Reduce Size

1. **Remove unused resources**
2. **Compress images**
3. **Use WebP format**
4. **Enable R8/ProGuard**
5. **Split APK by ABI**

### Performance Tips

- Use `const` constructors
- Avoid rebuilds
- Use `ListView.builder`
- Cache images
- Lazy load data

## 🔄 CI/CD

### GitHub Actions

Create `.github/workflows/build.yml`:

```yaml
name: Build APK

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v2
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

## 📱 Distribution

### Internal Distribution

1. **Direct APK**
   - Share APK file
   - Install manually

2. **Firebase App Distribution**
   - Upload to Firebase
   - Share link
   - Track installs

3. **TestFlight (iOS)**
   - Upload to App Store Connect
   - Invite testers
   - Get feedback

### Public Distribution

1. **Google Play Store**
   - Official store
   - Paid ($25)
   - Review process

2. **Alternative Stores**
   - Amazon Appstore
   - Samsung Galaxy Store
   - Huawei AppGallery

## 📞 Support

### Post-Launch

- Monitor crashes
- Read reviews
- Fix bugs
- Update regularly
- Respond to feedback

### Update Strategy

- **Patch**: Bug fixes (1.0.1)
- **Minor**: New features (1.1.0)
- **Major**: Big changes (2.0.0)

## ✅ Launch Checklist

- [ ] Build APK/AAB
- [ ] Test thoroughly
- [ ] Update version
- [ ] Sign app
- [ ] Prepare store listing
- [ ] Upload to Play Console
- [ ] Submit for review
- [ ] Monitor launch
- [ ] Respond to feedback
- [ ] Plan updates

---

**Good luck with your launch! 🚀**

_Last Updated: May 14, 2026_
