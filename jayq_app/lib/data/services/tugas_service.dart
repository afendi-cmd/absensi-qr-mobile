import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../../core/constants/app_constants.dart';

class TugasService {
  final Dio _dio;
  final StorageService _storageService = StorageService();
  final String baseUrl = AppConstants.baseUrl;

  TugasService() : _dio = Dio() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.headers['Accept'] = 'application/json';
  }

  Future<List<Map<String, dynamic>>> getTugasDosen({int? mataKuliahId}) async {
    try {
      final token = await _storageService.getToken();

      final queryParams = <String, dynamic>{};
      if (mataKuliahId != null) {
        queryParams['mata_kuliah_id'] = mataKuliahId;
      }

      final response = await _dio.get(
        '/tugas',
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
      throw Exception('Gagal mengambil data tugas: $e');
    }
  }

  Future<Map<String, dynamic>> createTugas({
    required int mataKuliahId,
    required String judul,
    String? deskripsi,
    required String deadline,
    String? filePath,
  }) async {
    try {
      final token = await _storageService.getToken();

      FormData formData = FormData.fromMap({
        'mata_kuliah_id': mataKuliahId,
        'judul': judul,
        'deskripsi': deskripsi ?? '',
        'deadline': deadline,
      });

      if (filePath != null) {
        formData.files.add(
          MapEntry('file_tugas', await MultipartFile.fromFile(filePath)),
        );
      }

      final response = await _dio.post(
        '/tugas',
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
      throw Exception('Gagal membuat tugas: $e');
    }
  }

  Future<Map<String, dynamic>> getTugasDetail(int tugasId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.get(
        '/tugas/$tugasId',
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
      throw Exception('Gagal mengambil detail tugas: $e');
    }
  }

  Future<Map<String, dynamic>> getPengumpulan(int tugasId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.get(
        '/tugas/$tugasId/pengumpulan',
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
      throw Exception('Gagal mengambil data pengumpulan: $e');
    }
  }

  Future<void> beriNilai({
    required int pengumpulanId,
    required int nilai,
    String? catatan,
  }) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.put(
        '/pengumpulan-tugas/$pengumpulanId/nilai',
        data: {'nilai': nilai, 'catatan': catatan},
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
      throw Exception('Gagal memberi nilai: $e');
    }
  }

  Future<void> deleteTugas(int tugasId) async {
    try {
      final token = await _storageService.getToken();

      final response = await _dio.delete(
        '/tugas/$tugasId',
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
      throw Exception('Gagal menghapus tugas: $e');
    }
  }

  // For Mahasiswa
  Future<List<Map<String, dynamic>>> getTugasMahasiswa({
    int? mataKuliahId,
  }) async {
    try {
      final token = await _storageService.getToken();

      final queryParams = <String, dynamic>{};
      if (mataKuliahId != null) {
        queryParams['mata_kuliah_id'] = mataKuliahId;
      }

      final response = await _dio.get(
        '/tugas/mahasiswa/me',
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
      throw Exception('Gagal mengambil data tugas: $e');
    }
  }

  Future<Map<String, dynamic>> uploadTugas({
    required int tugasId,
    required String filePath,
  }) async {
    try {
      final token = await _storageService.getToken();

      FormData formData = FormData.fromMap({
        'tugas_id': tugasId,
        'file_jawaban': await MultipartFile.fromFile(filePath),
      });

      final response = await _dio.post(
        '/upload-tugas',
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
      throw Exception('Gagal upload tugas: $e');
    }
  }

  String getDownloadUrl(String filePath) {
    return '${baseUrl.replaceAll('/api', '')}/storage/$filePath';
  }
}
