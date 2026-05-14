class MataKuliahModel {
  final int id;
  final String kodeMk;
  final String namaMk;
  final int sks;
  final String semester;
  final int? dosenId;
  final String? dosenName;
  final int? jumlahPeserta;
  final DateTime? createdAt;

  MataKuliahModel({
    required this.id,
    required this.kodeMk,
    required this.namaMk,
    required this.sks,
    required this.semester,
    this.dosenId,
    this.dosenName,
    this.jumlahPeserta,
    this.createdAt,
  });

  factory MataKuliahModel.fromJson(Map<String, dynamic> json) {
    return MataKuliahModel(
      id: json['id'] ?? 0,
      kodeMk: json['kode_mk'] ?? '',
      namaMk: json['nama_mk'] ?? '',
      sks: json['sks'] ?? 0,
      semester: json['semester'] ?? '',
      dosenId: json['dosen_id'],
      dosenName: json['dosen_name'] ?? json['dosen']?['name'],
      jumlahPeserta: json['jumlah_peserta'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kode_mk': kodeMk,
      'nama_mk': namaMk,
      'sks': sks,
      'semester': semester,
      'dosen_id': dosenId,
      'dosen_name': dosenName,
      'jumlah_peserta': jumlahPeserta,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
