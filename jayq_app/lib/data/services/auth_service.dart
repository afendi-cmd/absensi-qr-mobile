import '../models/user_model.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final StorageService _storageService = StorageService();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post('/login', {
        'email': email,
        'password': password,
      }, requiresAuth: false);

      // Handle response structure: { success: true, data: { token, user } }
      final data = response['data'] ?? response;
      final token = data['token'];
      final userData = data['user'];

      if (token != null) {
        await _storageService.saveToken(token);
      }

      if (userData != null) {
        final user = UserModel.fromJson(userData);
        await _storageService.saveUser(user);
      }

      return {
        'success': true,
        'user': userData != null ? UserModel.fromJson(userData) : null,
        'message': response['message'] ?? 'Login successful',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }

  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.post(
        '/register',
        data,
        requiresAuth: false,
      );

      return {
        'success': true,
        'message': response['message'] ?? 'Registration successful',
      };
    } catch (e) {
      return {
        'success': false,
        'message': e.toString().replaceAll('Exception: ', ''),
      };
    }
  }

  Future<void> logout() async {
    try {
      await _apiService.post('/logout', {});
    } catch (e) {
      // Continue with local logout even if API call fails
    } finally {
      await _storageService.clearAll();
    }
  }

  Future<UserModel?> getCurrentUser() async {
    return await _storageService.getUser();
  }

  Future<bool> isLoggedIn() async {
    return await _storageService.isLoggedIn();
  }

  Future<String?> getUserRole() async {
    return await _storageService.getUserRole();
  }
}
