import 'dart:async';
import 'package:flutter/material.dart';
import '../data/services/qr_service.dart';

class QrProvider with ChangeNotifier {
  final QrService _qrService = QrService();

  Map<String, dynamic>? _currentSession;
  List<Map<String, dynamic>> _attendances = [];
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;

  Map<String, dynamic>? get currentSession => _currentSession;
  List<Map<String, dynamic>> get attendances => _attendances;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get totalHadir => _attendances.length;
  bool get isSessionActive => _currentSession != null;

  Future<void> generateQr({
    required int mataKuliahId,
    required int duration,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentSession = await _qrService.generateQr(
        mataKuliahId: mataKuliahId,
        duration: duration,
      );
      _attendances = [];
      _isLoading = false;
      notifyListeners();

      // Start auto-refresh untuk attendance list
      _startAutoRefresh();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshSessionDetail() async {
    if (_currentSession == null) return;

    try {
      final sessionId = _currentSession!['id'];
      final detail = await _qrService.getQrSessionDetail(sessionId);

      _currentSession = detail;
      _attendances = List<Map<String, dynamic>>.from(
        detail['attendances'] ?? [],
      );
      notifyListeners();

      // Stop auto-refresh jika session sudah tidak aktif
      if (detail['is_active'] == false) {
        _stopAutoRefresh();
      }
    } catch (e) {
      debugPrint('Error refreshing session: $e');
    }
  }

  Future<void> closeSession() async {
    if (_currentSession == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final sessionId = _currentSession!['id'];
      await _qrService.closeQrSession(sessionId);

      _stopAutoRefresh();
      _currentSession = null;
      _attendances = [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void _startAutoRefresh() {
    _stopAutoRefresh(); // Stop existing timer if any
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => refreshSessionDetail(),
    );
  }

  void _stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void clearSession() {
    _stopAutoRefresh();
    _currentSession = null;
    _attendances = [];
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopAutoRefresh();
    super.dispose();
  }
}
