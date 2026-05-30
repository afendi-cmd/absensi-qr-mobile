class MateriModel {
  final int id;
  final int mataKuliahId;
  final String judul;
  final String? deskripsi;
  final String fileMateri;
  final MataKuliahInfo? mataKuliah;
  final DateTime createdAt;
  final DateTime updatedAt;

  MateriModel({
    required this.id,
    required this.mataKuliahId,
    required this.judul,
    this.deskripsi,
    required this.fileMateri,
    this.mataKuliah,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MateriModel.fromJson(Map<String, dynamic> json) {
    return MateriModel(
      id: json['id'] ?? 0,
      mataKuliahId: json['mata_kuliah_id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'],
      fileMateri: json['file_materi'] ?? '',
      mataKuliah: json['mata_kuliah'] != null
          ? MataKuliahInfo.fromJson(json['mata_kuliah'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mata_kuliah_id': mataKuliahId,
      'judul': judul,
      'deskripsi': deskripsi,
      'file_materi': fileMateri,
      'mata_kuliah': mataKuliah?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get fileExtension {
    return fileMateri.split('.').last.toUpperCase();
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      return 'Hari ini';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

class MataKuliahInfo {
  final int id;
  final String namaMk;
  final String kodeMk;

  MataKuliahInfo({
    required this.id,
    required this.namaMk,
    required this.kodeMk,
  });

  factory MataKuliahInfo.fromJson(Map<String, dynamic> json) {
    return MataKuliahInfo(
      id: json['id'] ?? 0,
      namaMk: json['nama_mk'] ?? '',
      kodeMk: json['kode_mk'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama_mk': namaMk, 'kode_mk': kodeMk};
  }
}
