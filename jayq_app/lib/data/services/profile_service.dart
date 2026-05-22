import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

class ProfileService {
  final Dio _dio;

  ProfileService(this._dio);

  // Update profile
  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? noHp,
    String? alamat,
    String? currentPassword,
    String? newPassword,
    String? newPasswordConfirmation,
  }) async {
    try {
      Map<String, dynamic> data = {};

      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;
      if (noHp != null) data['no_hp'] = noHp;
      if (alamat != null) data['alamat'] = alamat;

      // If changing password
      if (newPassword != null && currentPassword != null) {
        data['current_password'] = currentPassword;
        data['new_password'] = newPassword;
        data['new_password_confirmation'] =
            newPasswordConfirmation ?? newPassword;
      }

      final response = await _dio.put(
        '${AppConstants.baseUrl}/profile/update',
        data: data,
      );

      if (response.data['success']) {
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        final errorData = e.response!.data;
        if (errorData['errors'] != null) {
          final errors = errorData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          throw Exception(firstError is List ? firstError[0] : firstError);
        }
        throw Exception(errorData['message'] ?? 'Gagal mengupdate profil');
      }
      throw Exception('Gagal mengupdate profil: $e');
    }
  }
}
