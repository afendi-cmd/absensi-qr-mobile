import 'api_service.dart';

class MataKuliahService {
  final ApiService _apiService = ApiService();

  // Get all mata kuliah
  Future<List<Map<String, dynamic>>> getMataKuliah() async {
    try {
      final response = await _apiService.get('/mata-kuliah');

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data mata kuliah');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Create new mata kuliah
  Future<Map<String, dynamic>> createMataKuliah(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.post('/mata-kuliah', data);

      if (response['success'] == true) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Gagal menambahkan mata kuliah');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Update mata kuliah
  Future<Map<String, dynamic>> updateMataKuliah(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.put('/mata-kuliah/$id', data);

      if (response['success'] == true) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Gagal mengupdate mata kuliah');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get mata kuliah mahasiswa
  Future<List<Map<String, dynamic>>> getMahasiswaMataKuliah() async {
    try {
      final response = await _apiService.get('/mata-kuliah/mahasiswa/me');

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data mata kuliah');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Delete mata kuliah
  Future<void> deleteMataKuliah(int id) async {
    try {
      final response = await _apiService.delete('/mata-kuliah/$id');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Gagal menghapus mata kuliah');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
