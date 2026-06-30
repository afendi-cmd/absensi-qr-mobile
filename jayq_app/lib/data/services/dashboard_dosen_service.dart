import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../../core/constants/app_constants.dart';

class DashboardDosenService {
  final Dio _dio;
  final StorageService _storageService = StorageService();
  final String baseUrl = AppConstants.baseUrl;

  DashboardDosenService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Accept'] = 'application/json';
  }

  Future<Map<String, dynamic>> getDosenStats(int dosenId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.get(
        '/dashboard/dosen/$dosenId/stats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success']) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Server error');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Gagal mengambil statistik: $e');
    }
  }
}
