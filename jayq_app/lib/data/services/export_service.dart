import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../core/constants/app_constants.dart';

class ExportService {
  final Dio _dio;

  ExportService(this._dio);

  // Export absensi
  Future<String> exportAbsensi({
    int? mataKuliahId,
    String? startDate,
    String? endDate,
  }) async {
    try {
      Map<String, dynamic> queryParams = {};
      if (mataKuliahId != null) queryParams['mata_kuliah_id'] = mataKuliahId;
      if (startDate != null) queryParams['start_date'] = startDate;
      if (endDate != null) queryParams['end_date'] = endDate;

      final response = await _dio.get(
        '${AppConstants.baseUrl}/export/absensi',
        queryParameters: queryParams,
      );

      if (response.data['success']) {
        return await _saveFile(
          response.data['data']['csv'],
          response.data['data']['filename'],
        );
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal export absensi: $e');
    }
  }

  // Export rekap mahasiswa
  Future<String> exportRekapMahasiswa(int mataKuliahId) async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/export/rekap-mahasiswa',
        queryParameters: {'mata_kuliah_id': mataKuliahId},
      );

      if (response.data['success']) {
        return await _saveFile(
          response.data['data']['csv'],
          response.data['data']['filename'],
        );
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal export rekap: $e');
    }
  }

  // Export mahasiswa
  Future<String> exportMahasiswa() async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/export/mahasiswa',
      );

      if (response.data['success']) {
        return await _saveFile(
          response.data['data']['csv'],
          response.data['data']['filename'],
        );
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal export mahasiswa: $e');
    }
  }

  // Export dosen
  Future<String> exportDosen() async {
    try {
      final response = await _dio.get('${AppConstants.baseUrl}/export/dosen');

      if (response.data['success']) {
        return await _saveFile(
          response.data['data']['csv'],
          response.data['data']['filename'],
        );
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal export dosen: $e');
    }
  }

  // Export mata kuliah
  Future<String> exportMataKuliah() async {
    try {
      final response = await _dio.get(
        '${AppConstants.baseUrl}/export/mata-kuliah',
      );

      if (response.data['success']) {
        return await _saveFile(
          response.data['data']['csv'],
          response.data['data']['filename'],
        );
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal export mata kuliah: $e');
    }
  }

  // Helper: Save file to device
  Future<String> _saveFile(String base64Data, String filename) async {
    try {
      // Decode base64
      final bytes = base64Decode(base64Data);

      // Get download directory
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      // Create JAYQ folder if not exists
      final jayqDir = Directory('${directory!.path}/JAYQ_Exports');
      if (!await jayqDir.exists()) {
        await jayqDir.create(recursive: true);
      }

      // Save file
      final filePath = '${jayqDir.path}/$filename';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return filePath;
    } catch (e) {
      throw Exception('Gagal menyimpan file: $e');
    }
  }
}
