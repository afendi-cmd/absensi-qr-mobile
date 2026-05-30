import '../models/materi_model.dart';
import 'api_service.dart';
import '../../core/constants/app_constants.dart';

class MateriService {
  final ApiService _apiService = ApiService();

  // Get materi untuk mahasiswa
  Future<List<MateriModel>> getMateriMahasiswa({int? mataKuliahId}) async {
    try {
      String endpoint = '/materi/mahasiswa';
      if (mataKuliahId != null) {
        endpoint += '?mata_kuliah_id=$mataKuliahId';
      }

      final response = await _apiService.get(endpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => MateriModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data materi');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get single materi
  Future<MateriModel> getMateriById(int id) async {
    try {
      final response = await _apiService.get('/materi/$id');

      if (response['success'] == true) {
        return MateriModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat detail materi');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get download URL for materi file
  String getDownloadUrl(String filePath) {
    // Remove 'public/' prefix if exists
    final cleanPath = filePath.replaceFirst('public/', '');
    return '${AppConstants.baseUrl.replaceAll('/api', '')}/storage/$cleanPath';
  }
}
