import 'package:flutter/material.dart';
import '../data/models/peserta_mk_model.dart';
import '../data/models/user_model.dart';
import '../data/models/mata_kuliah_model.dart';
import '../data/services/peserta_mk_service.dart';

class PesertaMkProvider with ChangeNotifier {
  final PesertaMkService _pesertaMkService = PesertaMkService();

  // State variables
  bool _isLoading = false;
  bool _isLoadingMahasiswa = false;
  bool _isLoadingMataKuliah = false;
  String? _error;

  // Data
  MataKuliahModel? _selectedMataKuliah;
  List<PesertaMk> _pesertaList = [];
  List<UserModel> _mahasiswaList = [];
  List<MataKuliahModel> _mataKuliahList = [];

  // Getters
  bool get isLoading => _isLoading;
  bool get isLoadingMahasiswa => _isLoadingMahasiswa;
  bool get isLoadingMataKuliah => _isLoadingMataKuliah;
  String? get error => _error;
  MataKuliahModel? get selectedMataKuliah => _selectedMataKuliah;
  List<PesertaMk> get pesertaList => _pesertaList;
  List<UserModel> get mahasiswaList => _mahasiswaList;
  List<MataKuliahModel> get mataKuliahList => _mataKuliahList;

  // Get available mahasiswa (not enrolled in selected course)
  List<UserModel> get availableMahasiswa {
    if (_selectedMataKuliah == null) return _mahasiswaList;

    final enrolledIds = _pesertaList.map((p) => p.mahasiswaId).toSet();
    return _mahasiswaList.where((m) => !enrolledIds.contains(m.id)).toList();
  }

  /// Load all mata kuliah
  Future<void> loadMataKuliah() async {
    _isLoadingMataKuliah = true;
    _error = null;
    notifyListeners();

    try {
      _mataKuliahList = await _pesertaMkService.getAllMataKuliah();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMataKuliah = false;
      notifyListeners();
    }
  }

  /// Load all mahasiswa
  Future<void> loadMahasiswa() async {
    _isLoadingMahasiswa = true;
    _error = null;
    notifyListeners();

    try {
      _mahasiswaList = await _pesertaMkService.getAllMahasiswa();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingMahasiswa = false;
      notifyListeners();
    }
  }

  /// Select mata kuliah and load its peserta
  Future<void> selectMataKuliah(MataKuliahModel mataKuliah) async {
    _selectedMataKuliah = mataKuliah;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _pesertaMkService.getPesertaByMataKuliah(
        mataKuliah.id,
      );
      _pesertaList = result['peserta'] as List<PesertaMk>;
    } catch (e) {
      _error = e.toString();
      _pesertaList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add mahasiswa to selected mata kuliah
  Future<bool> addPeserta(UserModel mahasiswa) async {
    if (_selectedMataKuliah == null) {
      _error = 'Pilih mata kuliah terlebih dahulu';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newPeserta = await _pesertaMkService.addPeserta(
        mahasiswaId: mahasiswa.id,
        mataKuliahId: _selectedMataKuliah!.id,
      );

      // Add to local list
      _pesertaList.add(newPeserta);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Remove peserta from mata kuliah
  Future<bool> removePeserta(PesertaMk peserta) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _pesertaMkService.removePeserta(peserta.id);

      // Remove from local list
      _pesertaList.removeWhere((p) => p.id == peserta.id);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Clear selection
  void clearSelection() {
    _selectedMataKuliah = null;
    _pesertaList = [];
    _error = null;
    notifyListeners();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
