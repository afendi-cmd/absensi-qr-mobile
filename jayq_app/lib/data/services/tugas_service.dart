import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/tugas_model.dart';
import 'api_service.dart';
import 'storage_service.dart';
import '../../core/constants/app_constants.dart';

class TugasService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  // Get tugas untuk mahasiswa
  Future<List<TugasModel>> getTugasMahasiswa({int? mataKuliahId}) async {
    try {
      String endpoint = '/tugas/mahasiswa';
      if (mataKuliahId != null) {
        endpoint += '?mata_kuliah_id=$mataKuliahId';
      }

      final response = await _apiService.get(endpoint);

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => TugasModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data tugas');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get single tugas
  Future<TugasModel> getTugasById(int id) async {
    try {
      final response = await _apiService.get('/tugas/$id');

      if (response['success'] == true) {
        return TugasModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat detail tugas');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Upload tugas (submit assignment)
  Future<void> uploadTugas(int tugasId, File file) async {
    try {
      final token = await _storageService.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }

      final uri = Uri.parse('${AppConstants.baseUrl}/tugas/upload');
      final request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['tugas_id'] = tugasId.toString();

      request.files.add(
        await http.MultipartFile.fromPath('file_jawaban', file.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return;
      } else {
        throw Exception('Gagal mengupload tugas');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get pengumpulan tugas mahasiswa
  Future<List<PengumpulanTugas>> getPengumpulanMahasiswa() async {
    try {
      final response = await _apiService.get('/tugas/pengumpulan/mahasiswa');

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => PengumpulanTugas.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data pengumpulan');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get download URL for tugas file
  String getDownloadUrl(String filePath) {
    final cleanPath = filePath.replaceFirst('public/', '');
    return '${AppConstants.baseUrl.replaceAll('/api', '')}/storage/$cleanPath';
  }
}
