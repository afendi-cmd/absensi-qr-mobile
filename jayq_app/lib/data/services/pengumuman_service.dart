import '../models/pengumuman_model.dart';
import 'api_service.dart';

class PengumumanService {
  final ApiService _apiService = ApiService();

  // Get all pengumuman
  Future<List<PengumumanModel>> getPengumuman() async {
    try {
      final response = await _apiService.get('/pengumuman');

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => PengumumanModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data pengumuman');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get single pengumuman
  Future<PengumumanModel> getPengumumanById(int id) async {
    try {
      final response = await _apiService.get('/pengumuman/$id');

      if (response['success'] == true) {
        return PengumumanModel.fromJson(response['data']);
      } else {
        throw Exception(
          response['message'] ?? 'Gagal memuat detail pengumuman',
        );
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Mark pengumuman as read
  Future<void> markAsRead(int id) async {
    try {
      final response = await _apiService.post(
        '/pengumuman/$id/mark-as-read',
        {},
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Gagal menandai pengumuman');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Mark all pengumuman as read
  Future<void> markAllAsRead() async {
    try {
      final response = await _apiService.post(
        '/pengumuman/mark-all-as-read',
        {},
      );

      if (response['success'] != true) {
        throw Exception(
          response['message'] ?? 'Gagal menandai semua pengumuman',
        );
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get unread count
  Future<Map<String, int>> getUnreadCount() async {
    try {
      final response = await _apiService.get('/pengumuman/unread/count');

      if (response['success'] == true) {
        return {
          'unread_count': response['data']['unread_count'] ?? 0,
          'total_count': response['data']['total_count'] ?? 0,
        };
      } else {
        throw Exception(
          response['message'] ?? 'Gagal memuat jumlah pengumuman',
        );
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // ========== ADMIN METHODS ==========

  // Get all pengumuman for admin
  Future<List<PengumumanModel>> getAdminPengumuman() async {
    try {
      final response = await _apiService.get('/pengumuman/admin');

      if (response['success'] == true) {
        final List<dynamic> data = response['data'];
        return data.map((json) => PengumumanModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data pengumuman');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Create new pengumuman
  Future<PengumumanModel> createPengumuman(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post('/pengumuman', data);

      if (response['success'] == true) {
        return PengumumanModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal membuat pengumuman');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Update pengumuman
  Future<PengumumanModel> updatePengumuman(
    int id,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await _apiService.put('/pengumuman/$id', data);

      if (response['success'] == true) {
        return PengumumanModel.fromJson(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal mengupdate pengumuman');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Delete pengumuman
  Future<void> deletePengumuman(int id) async {
    try {
      final response = await _apiService.delete('/pengumuman/$id');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Gagal menghapus pengumuman');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Toggle active status
  Future<PengumumanModel> toggleActive(int id) async {
    try {
      final response = await _apiService.post('/pengumuman/$id/toggle', {});

      if (response['success'] == true) {
        return PengumumanModel.fromJson(response['data']);
      } else {
        throw Exception(
          response['message'] ?? 'Gagal mengubah status pengumuman',
        );
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
