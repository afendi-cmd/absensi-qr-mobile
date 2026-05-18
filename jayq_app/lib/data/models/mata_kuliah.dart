class MataKuliah {
  final int id;
  final String namaMk;
  final String kodeMk;
  final int dosenId;
  final String? dosenNama;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MataKuliah({
    required this.id,
    required this.namaMk,
    required this.kodeMk,
    required this.dosenId,
    this.dosenNama,
    this.createdAt,
    this.updatedAt,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      id: json['id'] as int,
      namaMk: json['nama_mk'] as String,
      kodeMk: json['kode_mk'] as String,
      dosenId: json['dosen_id'] as int,
      dosenNama: json['dosen']?['nama'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_mk': namaMk,
      'kode_mk': kodeMk,
      'dosen_id': dosenId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
