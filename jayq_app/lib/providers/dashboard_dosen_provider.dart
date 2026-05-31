import 'package:flutter/material.dart';
import '../data/services/dashboard_dosen_service.dart';
import '../data/services/matakuliah_service.dart';

class DashboardDosenProvider with ChangeNotifier {
  final DashboardDosenService _dashboardService = DashboardDosenService();
  final MataKuliahService _mataKuliahService = MataKuliahService();

  Map<String, dynamic>? _stats;
  List<Map<String, dynamic>> _mataKuliahList = [];
  bool _isLoadingStats = false;
  bool _isLoadingMataKuliah = false;
  String? _error;

  Map<String, dynamic>? get stats => _stats;
  List<Map<String, dynamic>> get mataKuliahList => _mataKuliahList;
  bool get isLoadingStats => _isLoadingStats;
  bool get isLoadingMataKuliah => _isLoadingMataKuliah;
  String? get error => _error;

  int get totalMataKuliah => _stats?['total_mata_kuliah'] ?? 0;
  int get totalMahasiswa => _stats?['total_mahasiswa'] ?? 0;
  int get totalAbsensiHariIni => _stats?['total_absensi_hari_ini'] ?? 0;
  int get totalTugas => _stats?['total_tugas'] ?? 0;

  Future<void> loadStats(int dosenId) async {
    _isLoadingStats = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await _dashboardService.getDosenStats(dosenId);
      _isLoadingStats = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingStats = false;
      notifyListeners();
    }
  }

  Future<void> loadMataKuliah() async {
    _isLoadingMataKuliah = true;
    _error = null;
    notifyListeners();

    try {
      _mataKuliahList = await _mataKuliahService.getDosenMataKuliah();
      _isLoadingMataKuliah = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoadingMataKuliah = false;
      notifyListeners();
    }
  }

  Future<void> refreshAll(int dosenId) async {
    await Future.wait([loadStats(dosenId), loadMataKuliah()]);
  }
}
