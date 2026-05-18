class DashboardStats {
  final int totalMataKuliah;
  final int totalDosen;
  final int totalMahasiswa;
  final int totalAbsensiHariIni;

  DashboardStats({
    required this.totalMataKuliah,
    required this.totalDosen,
    required this.totalMahasiswa,
    required this.totalAbsensiHariIni,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      totalMataKuliah: json['total_mata_kuliah'] as int? ?? 0,
      totalDosen: json['total_dosen'] as int? ?? 0,
      totalMahasiswa: json['total_mahasiswa'] as int? ?? 0,
      totalAbsensiHariIni: json['total_absensi_hari_ini'] as int? ?? 0,
    );
  }
}

class MahasiswaStats {
  final int totalMataKuliah;
  final double persentaseKehadiran;
  final int tugasSelesai;
  final int tugasPending;

  MahasiswaStats({
    required this.totalMataKuliah,
    required this.persentaseKehadiran,
    required this.tugasSelesai,
    required this.tugasPending,
  });

  factory MahasiswaStats.fromJson(Map<String, dynamic> json) {
    return MahasiswaStats(
      totalMataKuliah: json['total_mata_kuliah'] as int? ?? 0,
      persentaseKehadiran:
          (json['persentase_kehadiran'] as num?)?.toDouble() ?? 0.0,
      tugasSelesai: json['tugas_selesai'] as int? ?? 0,
      tugasPending: json['tugas_pending'] as int? ?? 0,
    );
  }
}
