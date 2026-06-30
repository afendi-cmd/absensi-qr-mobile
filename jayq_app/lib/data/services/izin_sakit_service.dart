import 'dart:io';
import 'api_service.dart';

/// Service untuk fitur Izin / Sakit.
class IzinSakitService {
  final ApiService _api = ApiService();

  /// Pengajuan milik mahasiswa yang sedang login.
  Future<List<Map<String, dynamic>>> getMine() async {
    final res = await _api.get('/izin-sakit/me');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  /// Pengajuan untuk mata kuliah yang diampu dosen.
  Future<List<Map<String, dynamic>>> getForDosen() async {
    final res = await _api.get('/izin-sakit');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  /// Semua pengajuan (admin).
  Future<List<Map<String, dynamic>>> getAll() async {
    final res = await _api.get('/izin-sakit/all');
    return List<Map<String, dynamic>>.from(res['data'] ?? []);
  }

  /// Ajukan izin/sakit. Bila [filePath] diisi, surat diunggah via multipart.
  Future<Map<String, dynamic>> ajukan({
    int? mataKuliahId,
    required String tanggal,
    required String jenis, // 'izin' | 'sakit'
    required String alasan,
    String? filePath,
  }) async {
    if (filePath != null && filePath.isNotEmpty) {
      final fields = <String, String>{
        'tanggal': tanggal,
        'jenis': jenis,
        'alasan': alasan,
      };
      if (mataKuliahId != null) {
        fields['mata_kuliah_id'] = mataKuliahId.toString();
      }
      final res = await _api.uploadFile(
        '/izin-sakit',
        File(filePath),
        fields: fields,
        fileField: 'file_surat',
      );
      return Map<String, dynamic>.from(res['data'] ?? {});
    }

    final res = await _api.post('/izin-sakit', {
      'mata_kuliah_id': mataKuliahId,
      'tanggal': tanggal,
      'jenis': jenis,
      'alasan': alasan,
    });
    return Map<String, dynamic>.from(res['data'] ?? {});
  }

  /// Tinjau pengajuan (dosen): status 'disetujui' | 'ditolak'.
  Future<void> review({
    required int id,
    required String status,
    String? catatan,
  }) async {
    await _api.put('/izin-sakit/$id/review', {
      'status': status,
      'catatan': catatan,
    });
  }
}
