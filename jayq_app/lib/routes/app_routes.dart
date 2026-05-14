class AppRoutes {
  // Auth Routes
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';

  // Admin Routes
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminMataKuliah = '/admin/mata-kuliah';
  static const String adminPeserta = '/admin/peserta';
  static const String adminRekap = '/admin/rekap';

  // Dosen Routes
  static const String dosenDashboard = '/dosen/dashboard';
  static const String dosenGenerateQr = '/dosen/generate-qr';
  static const String dosenRekap = '/dosen/rekap';
  static const String dosenMateri = '/dosen/materi';
  static const String dosenTugas = '/dosen/tugas';

  // Mahasiswa Routes
  static const String mahasiswaDashboard = '/mahasiswa/dashboard';
  static const String mahasiswaScanQr = '/mahasiswa/scan-qr';
  static const String mahasiswaMataKuliah = '/mahasiswa/mata-kuliah';
  static const String mahasiswaRiwayat = '/mahasiswa/riwayat';
  static const String mahasiswaTugas = '/mahasiswa/tugas';
  static const String mahasiswaProfile = '/mahasiswa/profile';

  // Shared Routes
  static const String profile = '/profile';
}
