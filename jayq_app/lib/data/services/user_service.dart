import 'api_service.dart';

class UserService {
  final ApiService _apiService = ApiService();

  // Get all users with optional role filter
  Future<List<Map<String, dynamic>>> getUsers({String? role}) async {
    try {
      final endpoint = role != null ? '/users?role=$role' : '/users';
      final response = await _apiService.get(endpoint);

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data users');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Create new user
  Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await _apiService.post('/users', userData);

      if (response['success'] == true) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Gagal menambahkan user');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Update user
  Future<Map<String, dynamic>> updateUser(
    int id,
    Map<String, dynamic> userData,
  ) async {
    try {
      final response = await _apiService.put('/users/$id', userData);

      if (response['success'] == true) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Gagal mengupdate user');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Delete user
  Future<void> deleteUser(int id) async {
    try {
      final response = await _apiService.delete('/users/$id');

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Gagal menghapus user');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Update profile (self update)
  Future<Map<String, dynamic>> updateProfile(
    Map<String, dynamic> profileData,
  ) async {
    try {
      final response = await _apiService.put('/profile/update', profileData);

      if (response['success'] == true) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Gagal mengupdate profil');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final response = await _apiService.put('/profile/update', {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      });

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Gagal mengubah password');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
