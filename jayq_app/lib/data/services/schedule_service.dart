import 'package:dio/dio.dart';
import '../models/schedule_model.dart';

class ScheduleService {
  final Dio _dio;

  ScheduleService(this._dio);

  /// Get jadwal mata kuliah mahasiswa
  Future<List<ScheduleModel>> getMahasiswaSchedule() async {
    try {
      final response = await _dio.get('/mata-kuliah/mahasiswa/me');

      if (response.data['success'] == true) {
        final List<dynamic> data = response.data['data'] ?? [];
        return data.map((json) => ScheduleModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Gagal memuat jadwal');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response!.data['message'] ?? 'Gagal memuat jadwal');
      } else {
        throw Exception('Koneksi gagal: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get jadwal by hari
  Future<List<ScheduleModel>> getScheduleByDay(String hari) async {
    try {
      final allSchedule = await getMahasiswaSchedule();
      return allSchedule
          .where(
            (schedule) => schedule.hari?.toLowerCase() == hari.toLowerCase(),
          )
          .toList();
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Get jadwal hari ini
  Future<List<ScheduleModel>> getTodaySchedule() async {
    try {
      final now = DateTime.now();
      final hariMap = {
        1: 'senin',
        2: 'selasa',
        3: 'rabu',
        4: 'kamis',
        5: 'jumat',
        6: 'sabtu',
        7: 'minggu',
      };

      final hariIni = hariMap[now.weekday] ?? '';
      return await getScheduleByDay(hariIni);
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  /// Group schedule by hari
  Map<String, List<ScheduleModel>> groupScheduleByDay(
    List<ScheduleModel> schedules,
  ) {
    final Map<String, List<ScheduleModel>> grouped = {
      'senin': [],
      'selasa': [],
      'rabu': [],
      'kamis': [],
      'jumat': [],
      'sabtu': [],
    };

    for (final schedule in schedules) {
      final hari = schedule.hari?.toLowerCase();
      if (hari != null && grouped.containsKey(hari)) {
        grouped[hari]!.add(schedule);
      }
    }

    // Sort by jam_mulai
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) {
        if (a.jamMulai == null || b.jamMulai == null) return 0;
        return a.jamMulai!.compareTo(b.jamMulai!);
      });
    }

    return grouped;
  }
}
