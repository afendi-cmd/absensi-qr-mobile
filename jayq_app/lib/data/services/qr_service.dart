import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../../core/constants/app_constants.dart';

class QrService {
  final Dio _dio;
  final StorageService _storageService = StorageService();
  final String baseUrl = AppConstants.baseUrl;

  QrService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Accept'] = 'application/json';
  }

  Future<Map<String, dynamic>> generateQr({
    required int mataKuliahId,
    required int duration,
  }) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.post(
        '/generate-qr',
        data: {'mata_kuliah_id': mataKuliahId, 'duration': duration},
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
      throw Exception('Gagal generate QR: $e');
    }
  }

  Future<Map<String, dynamic>> getQrSessionDetail(int sessionId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.get(
        '/qr-sessions/$sessionId',
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
      throw Exception('Gagal mengambil detail QR session: $e');
    }
  }

  Future<void> closeQrSession(int sessionId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.put(
        '/qr-sessions/$sessionId/close',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (!response.data['success']) {
        throw Exception(response.data['message']);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Server error');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Gagal menutup QR session: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getQrHistory({
    int? mataKuliahId,
    String? status,
  }) async {
    try {
      final token = await _storageService.getToken();

      final queryParams = <String, dynamic>{};
      if (mataKuliahId != null) {
        queryParams['mata_kuliah_id'] = mataKuliahId;
      }
      if (status != null) {
        queryParams['status'] = status;
      }

      final response = await _dio.get(
        '/qr-sessions',
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.data['success']) {
        return List<Map<String, dynamic>>.from(response.data['data']);
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
      throw Exception('Gagal mengambil history QR: $e');
    }
  }
}
