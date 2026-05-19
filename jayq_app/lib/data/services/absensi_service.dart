import 'api_service.dart';

class AbsensiService {
  final ApiService _apiService = ApiService();

  // Get rekap absensi dengan filter
  Future<Map<String, dynamic>> getRekapAbsensi({
    int? mataKuliahId,
    String? tanggalMulai,
    String? tanggalSelesai,
  }) async {
    try {
      var endpoint = '/rekap-absensi?';
      if (mataKuliahId != null) {
        endpoint += 'mata_kuliah_id=$mataKuliahId&';
      }
      if (tanggalMulai != null) {
        endpoint += 'tanggal_mulai=$tanggalMulai&';
      }
      if (tanggalSelesai != null) {
        endpoint += 'tanggal_selesai=$tanggalSelesai&';
      }

      final response = await _apiService.get(endpoint);

      if (response['success'] == true) {
        return response['data'];
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat rekap absensi');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get all absensi dengan filter
  Future<List<Map<String, dynamic>>> getAllAbsensi({
    int? mataKuliahId,
    int? mahasiswaId,
    String? tanggalMulai,
    String? tanggalSelesai,
  }) async {
    try {
      var endpoint = '/absensi/all?';
      if (mataKuliahId != null) {
        endpoint += 'mata_kuliah_id=$mataKuliahId&';
      }
      if (mahasiswaId != null) {
        endpoint += 'mahasiswa_id=$mahasiswaId&';
      }
      if (tanggalMulai != null) {
        endpoint += 'tanggal_mulai=$tanggalMulai&';
      }
      if (tanggalSelesai != null) {
        endpoint += 'tanggal_selesai=$tanggalSelesai&';
      }

      final response = await _apiService.get(endpoint);

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data absensi');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  // Get absensi by mata kuliah
  Future<List<Map<String, dynamic>>> getAbsensiByMataKuliah(
    int mataKuliahId,
  ) async {
    try {
      final response = await _apiService.get(
        '/mata-kuliah/$mataKuliahId/absensi',
      );

      if (response['success'] == true) {
        return List<Map<String, dynamic>>.from(response['data']);
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data absensi');
      }
    } catch (e) {
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
