class AbsensiModel {
  final int id;
  final int mahasiswaId;
  final int mataKuliahId;
  final int qrSessionId;
  final String status;
  final DateTime waktuAbsen;
  final String? mahasiswaName;
  final String? mahasiswaNim;
  final String? mataKuliahName;
  final String? keterangan;

  AbsensiModel({
    required this.id,
    required this.mahasiswaId,
    required this.mataKuliahId,
    required this.qrSessionId,
    required this.status,
    required this.waktuAbsen,
    this.mahasiswaName,
    this.mahasiswaNim,
    this.mataKuliahName,
    this.keterangan,
  });

  factory AbsensiModel.fromJson(Map<String, dynamic> json) {
    return AbsensiModel(
      id: json['id'] ?? 0,
      mahasiswaId: json['mahasiswa_id'] ?? 0,
      mataKuliahId: json['mata_kuliah_id'] ?? 0,
      qrSessionId: json['qr_session_id'] ?? 0,
      status: json['status'] ?? 'hadir',
      waktuAbsen: json['waktu_absen'] != null
          ? DateTime.parse(json['waktu_absen'])
          : DateTime.now(),
      mahasiswaName: json['mahasiswa_name'] ?? json['mahasiswa']?['name'],
      mahasiswaNim: json['mahasiswa_nim'] ?? json['mahasiswa']?['nim'],
      mataKuliahName:
          json['mata_kuliah_name'] ?? json['mata_kuliah']?['nama_mk'],
      keterangan: json['keterangan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mahasiswa_id': mahasiswaId,
      'mata_kuliah_id': mataKuliahId,
      'qr_session_id': qrSessionId,
      'status': status,
      'waktu_absen': waktuAbsen.toIso8601String(),
      'mahasiswa_name': mahasiswaName,
      'mahasiswa_nim': mahasiswaNim,
      'mata_kuliah_name': mataKuliahName,
      'keterangan': keterangan,
    };
  }

  bool get isHadir => status.toLowerCase() == 'hadir';
  bool get isAlfa => status.toLowerCase() == 'alfa';
  bool get isIzin => status.toLowerCase() == 'izin';
  bool get isSakit => status.toLowerCase() == 'sakit';
}
