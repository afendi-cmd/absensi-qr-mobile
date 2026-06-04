import 'package:flutter/material.dart';
import '../data/services/materi_service.dart';

class MateriProvider with ChangeNotifier {
  final MateriService _materiService = MateriService();

  List<Map<String, dynamic>> _materiList = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get materiList => _materiList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMateri({int? mataKuliahId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _materiList = await _materiService.getMateriDosen(
        mataKuliahId: mataKuliahId,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> uploadMateri({
    required int mataKuliahId,
    required String judul,
    String? deskripsi,
    required String filePath,
  }) async {
    try {
      await _materiService.uploadMateri(
        mataKuliahId: mataKuliahId,
        judul: judul,
        deskripsi: deskripsi,
        filePath: filePath,
      );
      await loadMateri();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteMateri(int materiId) async {
    try {
      await _materiService.deleteMateri(materiId);
      await loadMateri();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<String> getDownloadUrl(String filePath) async {
    return _materiService.getDownloadUrl(filePath);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
