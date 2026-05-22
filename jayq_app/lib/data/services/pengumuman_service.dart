import 'package:dio/dio.dart';
import '../models/pengumuman_model.dart';
import '../../core/constants/app_constants.dart';

class PengumumanService {
  final Dio _dio;

  PengumumanService(this._dio);

  // Get all pengumuman (filtered by role)
  Future<List<Pengumuman>> getPengumuman() async {
    try {
      final response = await _dio.get('${AppConstants.baseUrl}/pengumuman');

      if (response.data['success']) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => Pengumuman.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengambil pengumuman: $e');
    }
  }

  // Get all pengumuman for admin (including inactive)
  Future<List<Pengumuman>> getAdminPengumuman() async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/pengumuman/admin',
      );

      if (response.data['success']) {
        List<dynamic> data = response.data['data'];
        return data.map((json) => Pengumuman.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengambil pengumuman: $e');
    }
  }

  // Get single pengumuman
  Future<Pengumuman> getPengumumanById(int id) async {
    try {
      final response = await _dio.get('${AppConstants.baseUrl}/pengumuman/$id');

      if (response.data['success']) {
        return Pengumuman.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengambil pengumuman: $e');
    }
  }

  // Create pengumuman
  Future<Pengumuman> createPengumuman({
    required String judul,
    required String isi,
    required String tipe,
    required String target,
  }) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/pengumuman',
        data: {'judul': judul, 'isi': isi, 'tipe': tipe, 'target': target},
      );

      if (response.data['success']) {
        return Pengumuman.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal membuat pengumuman: $e');
    }
  }

  // Update pengumuman
  Future<Pengumuman> updatePengumuman({
    required int id,
    String? judul,
    String? isi,
    String? tipe,
    String? target,
    bool? isActive,
  }) async {
    try {
      Map<String, dynamic> data = {};
      if (judul != null) data['judul'] = judul;
      if (isi != null) data['isi'] = isi;
      if (tipe != null) data['tipe'] = tipe;
      if (target != null) data['target'] = target;
      if (isActive != null) data['is_active'] = isActive;

      final response = await _dio.put(
        '${AppConstants.baseUrl}/pengumuman/$id',
        data: data,
      );

      if (response.data['success']) {
        return Pengumuman.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengupdate pengumuman: $e');
    }
  }

  // Delete pengumuman
  Future<void> deletePengumuman(int id) async {
    try {
      final response = await _dio.delete(
        '${AppConstants.baseUrl}/pengumuman/$id',
      );

      if (!response.data['success']) {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal menghapus pengumuman: $e');
    }
  }

  // Toggle active status
  Future<Pengumuman> toggleActive(int id) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/pengumuman/$id/toggle-active',
      );

      if (response.data['success']) {
        return Pengumuman.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengubah status pengumuman: $e');
    }
  }
}
