import '../models/dashboard_stats.dart';
import '../models/mata_kuliah.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class DashboardService {
  final ApiService _apiService = ApiService();

  // Get Admin Dashboard Stats
  Future<DashboardStats> getAdminStats() async {
    try {
      final response = await _apiService.get('/admin/dashboard/stats');

      // Jika API belum ada endpoint ini, hitung manual
      if (response['data'] != null) {
        return DashboardStats.fromJson(response['data']);
      }

      // Fallback: ambil data manual
      final users = await _apiService.get('/users');
      final mataKuliah = await _apiService.get('/mata-kuliah');

      final usersList = (users['data'] as List?) ?? [];
      final mataKuliahList = (mataKuliah['data'] as List?) ?? [];

      final totalDosen = usersList.where((u) => u['role'] == 'dosen').length;
      final totalMahasiswa = usersList
          .where((u) => u['role'] == 'mahasiswa')
          .length;

      return DashboardStats(
        totalMataKuliah: mataKuliahList.length,
        totalDosen: totalDosen,
        totalMahasiswa: totalMahasiswa,
        totalAbsensiHariIni: 0,
      );
    } catch (e) {
      throw Exception('Failed to load admin stats: $e');
    }
  }

  // Get Mahasiswa Dashboard Stats
  Future<MahasiswaStats> getMahasiswaStats(int mahasiswaId) async {
    try {
      final response = await _apiService.get('/mahasiswa/$mahasiswaId/stats');

      if (response['data'] != null) {
        return MahasiswaStats.fromJson(response['data']);
      }

      // Fallback: hitung manual
      final pesertaMk = await _apiService.get(
        '/mahasiswa/$mahasiswaId/mata-kuliah',
      );
      final pesertaList = (pesertaMk['data'] as List?) ?? [];

      return MahasiswaStats(
        totalMataKuliah: pesertaList.length,
        persentaseKehadiran: 0.0,
        tugasSelesai: 0,
        tugasPending: 0,
      );
    } catch (e) {
      throw Exception('Failed to load mahasiswa stats: $e');
    }
  }

  // Get All Mata Kuliah
  Future<List<MataKuliah>> getAllMataKuliah() async {
    try {
      final response = await _apiService.get('/mata-kuliah');
      final data = response['data'] as List?;

      if (data == null) return [];

      return data.map((json) => MataKuliah.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load mata kuliah: $e');
    }
  }

  // Get Mahasiswa Mata Kuliah
  Future<List<MataKuliah>> getMahasiswaMataKuliah(int mahasiswaId) async {
    try {
      final response = await _apiService.get('/mata-kuliah/mahasiswa/me');
      final data = response['data'] as List?;

      if (data == null) return [];

      return data.map((json) => MataKuliah.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load mahasiswa mata kuliah: $e');
    }
  }

  // Get All Users (for admin)
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await _apiService.get('/users');
      final data = response['data'] as List?;

      if (data == null) return [];

      return data.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load users: $e');
    }
  }

  // Get Users by Role
  Future<List<UserModel>> getUsersByRole(String role) async {
    try {
      final allUsers = await getAllUsers();
      return allUsers.where((user) => user.role == role).toList();
    } catch (e) {
      throw Exception('Failed to load users by role: $e');
    }
  }

  // Create Mata Kuliah
  Future<void> createMataKuliah(
    String namaMk,
    String kodeMk,
    int sks,
    String semester,
    int dosenId,
  ) async {
    try {
      await _apiService.post('/mata-kuliah', {
        'nama_mk': namaMk,
        'kode_mk': kodeMk,
        'sks': sks,
        'semester': semester,
        'dosen_id': dosenId,
      });
    } catch (e) {
      // Extract clean error message
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      throw Exception(errorMessage);
    }
  }

  // Update Mata Kuliah
  Future<void> updateMataKuliah(
    int id,
    String namaMk,
    String kodeMk,
    int sks,
    String semester,
    int dosenId,
  ) async {
    try {
      await _apiService.put('/mata-kuliah/$id', {
        'nama_mk': namaMk,
        'kode_mk': kodeMk,
        'sks': sks,
        'semester': semester,
        'dosen_id': dosenId,
      });
    } catch (e) {
      // Extract clean error message
      final errorMessage = e.toString().replaceFirst('Exception: ', '');
      throw Exception(errorMessage);
    }
  }

  // Delete Mata Kuliah
  Future<void> deleteMataKuliah(int id) async {
    try {
      await _apiService.delete('/mata-kuliah/$id');
    } catch (e) {
      throw Exception('Failed to delete mata kuliah: $e');
    }
  }
}
