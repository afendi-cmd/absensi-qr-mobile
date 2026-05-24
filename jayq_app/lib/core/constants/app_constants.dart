class AppConstants {
  // App Info
  static const String appName = 'JAYQ';
  static const String appTagline = 'Scan • Attend • Done';
  static const String appVersion = '1.0.0';

  // API Configuration
  // ============================================================
  // CARA MENGGANTI BASE URL:
  // 1. Uncomment (hapus //) URL yang sesuai dengan device Anda
  // 2. Comment (tambah //) URL yang lain
  // 3. Hot restart app (tekan R di terminal)
  // ============================================================

  // 1. Untuk web browser (Chrome, Edge, dll)
  //    Gunakan saat: flutter run -d chrome
  // static const String baseUrl = "http://127.0.0.1:8000/api";

  // 2. Untuk emulator Android (DEFAULT)
  //    10.0.2.2 adalah alias untuk localhost dari emulator
  //    Gunakan saat: flutter run (di emulator)
  //static const String baseUrl = "http://10.0.2.2:8000/api";

  // 3. Untuk HP fisik (ganti dengan IP komputer Anda)
  //    Cara cek IP: buka CMD/Terminal, ketik "ipconfig" (Windows) atau "ifconfig" (Mac/Linux)
  //    Pastikan HP dan komputer di WiFi yang sama
  //    Backend harus jalan dengan: php artisan serve --host=0.0.0.0
  static const String baseUrl =
      "http://192.168.1.10:8000/api"; // Ganti dengan IP Anda

  // 4. Untuk iOS Simulator
  //    Gunakan saat: flutter run -d ios
  // static const String baseUrl = "http://localhost:8000/api";

  // ============================================================
  // TROUBLESHOOTING:
  // - Connection refused? Pastikan backend Laravel sudah jalan (php artisan serve)
  // - Timeout? Cek network atau increase apiTimeout di bawah
  // - 404 Not Found? Pastikan URL diakhiri dengan /api
  // - HP tidak connect? Pastikan di WiFi yang sama & firewall allow port 8000
  // ============================================================

  static const Duration apiTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String keyToken = 'auth_token';
  static const String keyUserId = 'user_id';
  static const String keyUserRole = 'user_role';
  static const String keyUserData = 'user_data';
  static const String keyRememberMe = 'remember_me';

  // QR Code
  static const Duration qrExpireDuration = Duration(minutes: 5);
  static const int qrScanDelay = 2000; // milliseconds

  // Pagination
  static const int defaultPageSize = 20;

  // File Upload
  static const int maxFileSize = 10 * 1024 * 1024; // 10MB
  static const List<String> allowedFileTypes = [
    'pdf',
    'doc',
    'docx',
    'jpg',
    'jpeg',
    'png',
  ];
}
