import '../models/peserta_mk_model.dart';
import '../models/user_model.dart';
import '../models/mata_kuliah_model.dart';
import 'api_service.dart';
import 'user_service.dart';
import 'matakuliah_service.dart';

class PesertaMkService {
  final ApiService _apiService = ApiService();
  final UserService _userService = UserService();
  final MataKuliahService _mataKuliahService = MataKuliahService();

  /// Get peserta by mata kuliah ID
  Future<Map<String, dynamic>> getPesertaByMataKuliah(int mataKuliahId) async {
    try {
      final response = await _apiService.get(
        '/mata-kuliah/$mataKuliahId/peserta',
      );

      if (response['success'] == true) {
        final data = response['data'];

        // Parse mata kuliah
        final mataKuliah = MataKuliahModel.fromJson(data['mata_kuliah']);

        // Parse peserta list
        final pesertaList = (data['peserta'] as List)
            .map((item) => PesertaMk.fromJson(item))
            .toList();

        return {'mata_kuliah': mataKuliah, 'peserta': pesertaList};
      } else {
        throw Exception(response['message'] ?? 'Failed to get peserta');
      }
    } catch (e) {
      throw Exception('Error getting peserta: $e');
    }
  }

  /// Add mahasiswa to mata kuliah
  Future<PesertaMk> addPeserta({
    required int mahasiswaId,
    required int mataKuliahId,
  }) async {
    try {
      final response = await _apiService.post('/peserta-mk', {
        'mahasiswa_id': mahasiswaId,
        'mata_kuliah_id': mataKuliahId,
      });

      if (response['success'] == true) {
        return PesertaMk.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Failed to add peserta');
      }
    } catch (e) {
      throw Exception('Error adding peserta: $e');
    }
  }

  /// Remove mahasiswa from mata kuliah
  Future<void> removePeserta(int pesertaId) async {
    try {
      final response = await _apiService.delete('/peserta-mk/$pesertaId');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Failed to remove peserta');
      }
    } catch (e) {
      throw Exception('Error removing peserta: $e');
    }
  }

  /// Get all mahasiswa (for adding to course)
  Future<List<UserModel>> getAllMahasiswa() async {
    try {
      final users = await _userService.getUsers(role: 'mahasiswa');
      return users.map((item) => UserModel.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Error getting mahasiswa: $e');
    }
  }

  /// Get all mata kuliah (for selection)
  Future<List<MataKuliahModel>> getAllMataKuliah() async {
    try {
      final mataKuliahData = await _mataKuliahService.getMataKuliah();
      return mataKuliahData
          .map((item) => MataKuliahModel.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error getting mata kuliah: $e');
    }
  }
}
