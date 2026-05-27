class ScheduleModel {
  final int id;
  final String namaMk;
  final String kodeMk;
  final int sks;
  final String? hari;
  final String? jamMulai;
  final String? jamSelesai;
  final String? ruangan;
  final DosenSchedule? dosen;

  ScheduleModel({
    required this.id,
    required this.namaMk,
    required this.kodeMk,
    required this.sks,
    this.hari,
    this.jamMulai,
    this.jamSelesai,
    this.ruangan,
    this.dosen,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] ?? 0,
      namaMk: json['nama_mk'] ?? '',
      kodeMk: json['kode_mk'] ?? '',
      sks: json['sks'] ?? 0,
      hari: json['hari'],
      jamMulai: json['jam_mulai'],
      jamSelesai: json['jam_selesai'],
      ruangan: json['ruangan'],
      dosen: json['dosen'] != null
          ? DosenSchedule.fromJson(json['dosen'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_mk': namaMk,
      'kode_mk': kodeMk,
      'sks': sks,
      'hari': hari,
      'jam_mulai': jamMulai,
      'jam_selesai': jamSelesai,
      'ruangan': ruangan,
      'dosen': dosen?.toJson(),
    };
  }

  String get hariCapitalized {
    if (hari == null) return '-';
    return hari![0].toUpperCase() + hari!.substring(1);
  }

  String get timeRange {
    if (jamMulai == null || jamSelesai == null) return '-';
    // Format: HH:mm:ss to HH:mm
    final mulai = jamMulai!.substring(0, 5);
    final selesai = jamSelesai!.substring(0, 5);
    return '$mulai - $selesai';
  }
}

class DosenSchedule {
  final int id;
  final String nama;
  final String? email;

  DosenSchedule({required this.id, required this.nama, this.email});

  factory DosenSchedule.fromJson(Map<String, dynamic> json) {
    return DosenSchedule(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'email': email};
  }
}
