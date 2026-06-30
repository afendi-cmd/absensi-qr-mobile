import 'api_service.dart';

/// Service untuk fitur Nilai (transkrip mahasiswa, input nilai dosen,
/// rekap admin). Dibangun di atas [ApiService] agar base URL konsisten
/// dengan AppConstants.
class NilaiService {
  final ApiService _api = ApiService();

  /// Transkrip nilai milik mahasiswa yang sedang login.
  /// Mengembalikan map: { nilai: [...], ipk: double?, total_sks: int }
  Future<Map<String, dynamic>> getMine() async {
    final res = await _api.get('/nilai/me');
    return Map<String, dynamic>.from(res['data'] ?? {});
  }

  /// Daftar nilai pada satu mata kuliah (untuk dosen).
  Future<List<Map<String, dynamic>>> getByMataKuliah(int mataKuliahId) async {
    final res = await _api.get('/nilai/mata-kuliah/$mataKuliahId');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  /// Semua nilai (untuk admin).
  Future<List<Map<String, dynamic>>> getAll() async {
    final res = await _api.get('/nilai');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  /// Input / perbarui nilai (dosen). Nilai akhir & grade dihitung otomatis
  /// di backend.
  Future<Map<String, dynamic>> inputNilai({
    required int mahasiswaId,
    required int mataKuliahId,
    num? nilaiTugas,
    num? nilaiUts,
    num? nilaiUas,
    String? catatan,
  }) async {
    final res = await _api.post('/nilai', {
      'mahasiswa_id': mahasiswaId,
      'mata_kuliah_id': mataKuliahId,
      'nilai_tugas': nilaiTugas,
      'nilai_uts': nilaiUts,
      'nilai_uas': nilaiUas,
      'catatan': catatan,
    });
    return Map<String, dynamic>.from(res['data'] ?? {});
  }

  Future<void> deleteNilai(int id) async {
    await _api.delete('/nilai/$id');
  }
}
