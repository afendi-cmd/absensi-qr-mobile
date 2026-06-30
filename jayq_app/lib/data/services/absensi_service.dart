import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';

class AbsensiService {
  final Dio _dio;

  AbsensiService(this._dio);

  // Scan QR untuk absensi
  Future<Map<String, dynamic>> scanQr(String qrCode) async {
    try {
      final response = await _dio.post(
        '${AppConstants.baseUrl}/scan-qr',
        data: {'kode_qr': qrCode},
      );

      if (response.data['success']) {
        return response.data;
      } else {
        throw Exception(response.data['message'] ?? 'Gagal melakukan absensi');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final message =
            e.response!.data['message'] ?? 'Gagal melakukan absensi';
        throw Exception(message);
      } else {
        throw Exception('Koneksi bermasalah. Cek internet Anda.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: ${e.toString()}');
    }
  }

  // Get riwayat absensi mahasiswa
  Future<List<Map<String, dynamic>>> getRiwayatAbsensi({
    int? mataKuliahId,
    String? tanggalMulai,
    String? tanggalSelesai,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (mataKuliahId != null) {
        queryParams['mata_kuliah_id'] = mataKuliahId;
      }
      if (tanggalMulai != null) {
        queryParams['tanggal_mulai'] = tanggalMulai;
      }
      if (tanggalSelesai != null) {
        queryParams['tanggal_selesai'] = tanggalSelesai;
      }

      final response = await _dio.get(
        '${AppConstants.baseUrl}/riwayat-absensi',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.data['success']) {
        List<dynamic> data = response.data['data'];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengambil riwayat absensi: $e');
    }
  }

  // Get all absensi (for admin)
  Future<List<Map<String, dynamic>>> getAllAbsensi({
    String? tanggalMulai,
    String? tanggalSelesai,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (tanggalMulai != null) {
        queryParams['tanggal_mulai'] = tanggalMulai;
      }
      if (tanggalSelesai != null) {
        queryParams['tanggal_selesai'] = tanggalSelesai;
      }

      final response = await _dio.get(
        '${AppConstants.baseUrl}/absensi/all',
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.data['success']) {
        List<dynamic> data = response.data['data'];
        return data.cast<Map<String, dynamic>>();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Gagal mengambil data absensi: $e');
    }
  }
}
