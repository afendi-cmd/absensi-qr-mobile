import 'api_service.dart';

/// Service untuk Audit Log (admin).
class AuditLogService {
  final ApiService _api = ApiService();

  Future<List<Map<String, dynamic>>> getLogs({int limit = 100}) async {
    final res = await _api.get('/audit-logs?limit=$limit');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }
}
