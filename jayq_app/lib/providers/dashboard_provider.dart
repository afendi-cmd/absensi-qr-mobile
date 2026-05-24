import 'package:flutter/foundation.dart';
import '../data/models/dashboard_stats.dart';
import '../data/models/mata_kuliah.dart';
import '../data/models/user_model.dart';
import '../data/services/dashboard_service.dart';

class DashboardProvider with ChangeNotifier {
  final DashboardService _dashboardService = DashboardService();

  // Admin Stats
  DashboardStats? _adminStats;
  DashboardStats? get adminStats => _adminStats;

  // Mahasiswa Stats
  MahasiswaStats? _mahasiswaStats;
  MahasiswaStats? get mahasiswaStats => _mahasiswaStats;

  // Mata Kuliah
  List<MataKuliah> _mataKuliahList = [];
  List<MataKuliah> get mataKuliahList => _mataKuliahList;
  List<MataKuliah> get allMataKuliah =>
      _mataKuliahList; // Alias for consistency

  // Users
  List<UserModel> _usersList = [];
  List<UserModel> get usersList => _usersList;
  List<UserModel> get allUsers => _usersList; // Alias for consistency

  List<UserModel> _dosenList = [];
  List<UserModel> get dosenList => _dosenList;

  List<UserModel> _mahasiswaList = [];
  List<UserModel> get mahasiswaList => _mahasiswaList;

  // Loading states
  bool _isLoadingAdminStats = false;
  bool get isLoadingAdminStats => _isLoadingAdminStats;

  bool _isLoadingMahasiswaStats = false;
  bool get isLoadingMahasiswaStats => _isLoadingMahasiswaStats;

  bool _isLoadingMataKuliah = false;
  bool get isLoadingMataKuliah => _isLoadingMataKuliah;

  bool _isLoadingUsers = false;
  bool get isLoadingUsers => _isLoadingUsers;

  // Error states
  String? _error;
  String? get error => _error;

  // Load Admin Stats
  Future<void> loadAdminStats() async {
    _isLoadingAdminStats = true;
    _error = null;
    notifyListeners();

    try {
      _adminStats = await _dashboardService.getAdminStats();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading admin stats: $e');
    } finally {
      _isLoadingAdminStats = false;
      notifyListeners();
    }
  }

  // Load Mahasiswa Stats
  Future<void> loadMahasiswaStats(int mahasiswaId) async {
    _isLoadingMahasiswaStats = true;
    _error = null;
    notifyListeners();

    try {
      _mahasiswaStats = await _dashboardService.getMahasiswaStats(mahasiswaId);
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading mahasiswa stats: $e');
    } finally {
      _isLoadingMahasiswaStats = false;
      notifyListeners();
    }
  }

  // Load All Mata Kuliah
  Future<void> loadAllMataKuliah() async {
    _isLoadingMataKuliah = true;
    _error = null;
    notifyListeners();

    try {
      _mataKuliahList = await _dashboardService.getAllMataKuliah();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading mata kuliah: $e');
    } finally {
      _isLoadingMataKuliah = false;
      notifyListeners();
    }
  }

  // Load Mahasiswa Mata Kuliah
  Future<void> loadMahasiswaMataKuliah(int mahasiswaId) async {
    _isLoadingMataKuliah = true;
    _error = null;
    notifyListeners();

    try {
      _mataKuliahList = await _dashboardService.getMahasiswaMataKuliah(
        mahasiswaId,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading mahasiswa mata kuliah: $e');
    } finally {
      _isLoadingMataKuliah = false;
      notifyListeners();
    }
  }

  // Load All Users
  Future<void> loadAllUsers() async {
    _isLoadingUsers = true;
    _error = null;
    notifyListeners();

    try {
      _usersList = await _dashboardService.getAllUsers();
      _dosenList = _usersList.where((user) => user.role == 'dosen').toList();
      _mahasiswaList = _usersList
          .where((user) => user.role == 'mahasiswa')
          .toList();
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading users: $e');
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }

  // Clear data
  void clearData() {
    _adminStats = null;
    _mahasiswaStats = null;
    _mataKuliahList = [];
    _usersList = [];
    _dosenList = [];
    _mahasiswaList = [];
    _error = null;
    notifyListeners();
  }

  // Create Mata Kuliah
  Future<void> createMataKuliah(
    String namaMk,
    String kodeMk,
    int sks,
    String semester,
    int dosenId,
  ) async {
    try {
      await _dashboardService.createMataKuliah(
        namaMk,
        kodeMk,
        sks,
        semester,
        dosenId,
      );
      // Reload mata kuliah list
      await loadAllMataKuliah();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error creating mata kuliah: $e');
      rethrow;
    }
  }

  // Update Mata Kuliah
  Future<void> updateMataKuliah(
    int id,
    String namaMk,
    String kodeMk,
    int sks,
    String semester,
    int dosenId,
  ) async {
    try {
      await _dashboardService.updateMataKuliah(
        id,
        namaMk,
        kodeMk,
        sks,
        semester,
        dosenId,
      );
      // Reload mata kuliah list
      await loadAllMataKuliah();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error updating mata kuliah: $e');
      rethrow;
    }
  }

  // Delete Mata Kuliah
  Future<void> deleteMataKuliah(int id) async {
    try {
      await _dashboardService.deleteMataKuliah(id);
      // Reload mata kuliah list
      await loadAllMataKuliah();
    } catch (e) {
      _error = e.toString();
      debugPrint('Error deleting mata kuliah: $e');
      rethrow;
    }
  }
}
