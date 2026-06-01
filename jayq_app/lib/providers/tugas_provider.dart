import 'package:flutter/material.dart';
import '../data/services/tugas_service.dart';

class TugasProvider with ChangeNotifier {
  final TugasService _tugasService = TugasService();

  List<Map<String, dynamic>> _tugasList = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get tugasList => _tugasList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTugas({int? mataKuliahId}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tugasList = await _tugasService.getTugasDosen(
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

  Future<bool> createTugas({
    required int mataKuliahId,
    required String judul,
    String? deskripsi,
    required String deadline,
    String? filePath,
  }) async {
    try {
      await _tugasService.createTugas(
        mataKuliahId: mataKuliahId,
        judul: judul,
        deskripsi: deskripsi,
        deadline: deadline,
        filePath: filePath,
      );
      await loadTugas();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteTugas(int tugasId) async {
    try {
      await _tugasService.deleteTugas(tugasId);
      await loadTugas();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
