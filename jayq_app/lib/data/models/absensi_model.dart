class AbsensiModel {
  final int id;
  final int mahasiswaId;
  final int mataKuliahId;
  final int? qrSessionId;
  final String tanggal;
  final String jam;
  final String status;
  final double? latitude;
  final double? longitude;
  final String? createdAt;
  final MataKuliahAbsensi? mataKuliah;

  AbsensiModel({
    required this.id,
    required this.mahasiswaId,
    required this.mataKuliahId,
    this.qrSessionId,
    required this.tanggal,
    required this.jam,
    required this.status,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.mataKuliah,
  });

  factory AbsensiModel.fromJson(Map<String, dynamic> json) {
    return AbsensiModel(
      id: json['id'] ?? 0,
      mahasiswaId: json['mahasiswa_id'] ?? 0,
      mataKuliahId: json['mata_kuliah_id'] ?? 0,
      qrSessionId: json['qr_session_id'],
      tanggal: json['tanggal'] ?? '',
      jam: json['jam'] ?? '',
      status: json['status'] ?? 'hadir',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
      createdAt: json['created_at'],
      mataKuliah: json['mata_kuliah'] != null
          ? MataKuliahAbsensi.fromJson(json['mata_kuliah'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mahasiswa_id': mahasiswaId,
      'mata_kuliah_id': mataKuliahId,
      'qr_session_id': qrSessionId,
      'tanggal': tanggal,
      'jam': jam,
      'status': status,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt,
      'mata_kuliah': mataKuliah?.toJson(),
    };
  }

  String get formattedDate {
    try {
      final date = DateTime.parse(tanggal);
      final months = [
        '',
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      return '${date.day} ${months[date.month]} ${date.year}';
    } catch (e) {
      return tanggal;
    }
  }

  String get formattedTime {
    try {
      // Format: HH:mm:ss to HH:mm
      return jam.substring(0, 5);
    } catch (e) {
      return jam;
    }
  }

  String get statusLabel {
    switch (status.toLowerCase()) {
      case 'hadir':
        return 'Hadir';
      case 'izin':
        return 'Izin';
      case 'sakit':
        return 'Sakit';
      case 'alpha':
        return 'Alpha';
      default:
        return status;
    }
  }
}

class MataKuliahAbsensi {
  final int id;
  final String namaMk;
  final String kodeMk;

  MataKuliahAbsensi({
    required this.id,
    required this.namaMk,
    required this.kodeMk,
  });

  factory MataKuliahAbsensi.fromJson(Map<String, dynamic> json) {
    return MataKuliahAbsensi(
      id: json['id'] ?? 0,
      namaMk: json['nama_mk'] ?? '',
      kodeMk: json['kode_mk'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama_mk': namaMk, 'kode_mk': kodeMk};
  }
}
