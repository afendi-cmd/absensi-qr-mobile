class AppConstants {
  // App Info
  static const String appName = 'JAYQ';
  static const String appTagline = 'Scan • Attend • Done';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'http://10.0.2.2:8000/api';
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
