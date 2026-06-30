import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../../core/constants/app_constants.dart';

class MateriService {
  final Dio _dio;
  final StorageService _storageService = StorageService();
  final String baseUrl = AppConstants.baseUrl;

  MateriService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Accept'] = 'application/json';
  }

  Future<List<Map<String, dynamic>>> getMateriDosen({int? mataKuliahId}) async {
    try {
      final token = await _storageService.getToken();

      final queryParams = <String, dynamic>{};
      if (mataKuliahId != null) {
        queryParams['mata_kuliah_id'] = mataKuliahId;
      }

      final response = await _dio.get(
        '/materi',
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
      throw Exception('Gagal mengambil data materi: $e');
    }
  }

  Future<Map<String, dynamic>> uploadMateri({
    required int mataKuliahId,
    required String judul,
    String? deskripsi,
    required String filePath,
  }) async {
    try {
      final token = await _storageService.getToken();

      FormData formData = FormData.fromMap({
        'mata_kuliah_id': mataKuliahId,
        'judul': judul,
        'deskripsi': deskripsi ?? '',
        'file_materi': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        '/materi',
        data: formData,
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
      throw Exception('Gagal upload materi: $e');
    }
  }

  Future<void> deleteMateri(int materiId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.delete(
        '/materi/$materiId',
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
      throw Exception('Gagal menghapus materi: $e');
    }
  }

  // For Mahasiswa
  Future<List<Map<String, dynamic>>> getMateriMahasiswa({
    int? mataKuliahId,
  }) async {
    try {
      final token = await _storageService.getToken();

      final queryParams = <String, dynamic>{};
      if (mataKuliahId != null) {
        queryParams['mata_kuliah_id'] = mataKuliahId;
      }

      final response = await _dio.get(
        '/materi/mahasiswa/me',
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
      throw Exception('Gagal mengambil data materi: $e');
    }
  }

  String getDownloadUrl(String filePath) {
    return '${baseUrl.replaceAll('/api', '')}/storage/$filePath';
  }
}
