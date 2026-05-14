import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';
import 'storage_service.dart';

class ApiService {
  final StorageService _storageService = StorageService();

  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _storageService.getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .get(url, headers: headers)
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> post(
    String endpoint,
    Map<String, dynamic> data, {
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      print('🌐 POST Request to: $url');
      print('📤 Request Body: ${jsonEncode(data)}');

      final response = await http
          .post(url, headers: headers, body: jsonEncode(data))
          .timeout(AppConstants.apiTimeout);

      print('📥 Response Status: ${response.statusCode}');
      print('📥 Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      print('❌ SocketException: No internet connection');
      throw Exception('No internet connection');
    } on HttpException {
      print('❌ HttpException: Service unavailable');
      throw Exception('Service unavailable');
    } catch (e) {
      print('❌ Error: $e');
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> put(
    String endpoint,
    Map<String, dynamic> data, {
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .put(url, headers: headers, body: jsonEncode(data))
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final headers = await _getHeaders(requiresAuth: requiresAuth);

      final response = await http
          .delete(url, headers: headers)
          .timeout(AppConstants.apiTimeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<dynamic> uploadFile(
    String endpoint,
    File file, {
    Map<String, String>? fields,
    String fileField = 'file',
  }) async {
    try {
      final url = Uri.parse('${AppConstants.baseUrl}$endpoint');
      final token = await _storageService.getToken();

      var request = http.MultipartRequest('POST', url);
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      if (fields != null) {
        request.fields.addAll(fields);
      }

      request.files.add(
        await http.MultipartFile.fromPath(fileField, file.path),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body;

    if (statusCode >= 200 && statusCode < 300) {
      if (body.isEmpty) return {'success': true};
      return jsonDecode(body);
    } else if (statusCode == 401) {
      throw Exception('Unauthorized - Please login again');
    } else if (statusCode == 403) {
      throw Exception('Forbidden - Access denied');
    } else if (statusCode == 404) {
      throw Exception('Not found');
    } else if (statusCode == 422) {
      final error = jsonDecode(body);
      throw Exception(error['message'] ?? 'Validation error');
    } else if (statusCode >= 500) {
      throw Exception('Server error - Please try again later');
    } else {
      try {
        final error = jsonDecode(body);
        throw Exception(error['message'] ?? 'Request failed');
      } catch (e) {
        throw Exception('Request failed with status: $statusCode');
      }
    }
  }
}
