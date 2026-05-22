class Pengumuman {
  final int id;
  final String judul;
  final String isi;
  final String tipe; // info, penting, urgent
  final String target; // all, dosen, mahasiswa
  final bool isActive;
  final int createdBy;
  final Creator? creator;
  final DateTime createdAt;
  final DateTime updatedAt;

  Pengumuman({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tipe,
    required this.target,
    required this.isActive,
    required this.createdBy,
    this.creator,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Pengumuman.fromJson(Map<String, dynamic> json) {
    return Pengumuman(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      tipe: json['tipe'],
      target: json['target'],
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdBy: json['created_by'],
      creator: json['creator'] != null
          ? Creator.fromJson(json['creator'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'judul': judul,
      'isi': isi,
      'tipe': tipe,
      'target': target,
      'is_active': isActive,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Creator {
  final int id;
  final String nama;
  final String email;

  Creator({required this.id, required this.nama, required this.email});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(id: json['id'], nama: json['nama'], email: json['email']);
  }
}
