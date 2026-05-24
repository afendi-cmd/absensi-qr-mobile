class MataKuliah {
  final int id;
  final String namaMk;
  final String kodeMk;
  final int sks;
  final String semester;
  final int dosenId;
  final Dosen? dosen;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MataKuliah({
    required this.id,
    required this.namaMk,
    required this.kodeMk,
    required this.sks,
    required this.semester,
    required this.dosenId,
    this.dosen,
    this.createdAt,
    this.updatedAt,
  });

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(
      id: json['id'] as int,
      namaMk: json['nama_mk'] as String,
      kodeMk: json['kode_mk'] as String,
      sks: json['sks'] as int,
      semester: json['semester'].toString(),
      dosenId: json['dosen_id'] as int,
      dosen: json['dosen'] != null ? Dosen.fromJson(json['dosen']) : null,
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
      'sks': sks,
      'semester': semester,
      'dosen_id': dosenId,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class Dosen {
  final int id;
  final String nama;
  final String? email;

  Dosen({required this.id, required this.nama, this.email});

  factory Dosen.fromJson(Map<String, dynamic> json) {
    return Dosen(
      id: json['id'] as int,
      nama: json['nama'] as String,
      email: json['email'] as String?,
    );
  }
}
