class MateriModel {
  final int id;
  final int mataKuliahId;
  final String judul;
  final String deskripsi;
  final String fileUrl;
  final String? mataKuliahName;
  final DateTime? createdAt;

  MateriModel({
    required this.id,
    required this.mataKuliahId,
    required this.judul,
    required this.deskripsi,
    required this.fileUrl,
    this.mataKuliahName,
    this.createdAt,
  });

  factory MateriModel.fromJson(Map<String, dynamic> json) {
    return MateriModel(
      id: json['id'] ?? 0,
      mataKuliahId: json['mata_kuliah_id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      fileUrl: json['file_url'] ?? '',
      mataKuliahName:
          json['mata_kuliah_name'] ?? json['mata_kuliah']?['nama_mk'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mata_kuliah_id': mataKuliahId,
      'judul': judul,
      'deskripsi': deskripsi,
      'file_url': fileUrl,
      'mata_kuliah_name': mataKuliahName,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get fileExtension {
    return fileUrl.split('.').last.toLowerCase();
  }

  bool get isPdf => fileExtension == 'pdf';
  bool get isDoc => ['doc', 'docx'].contains(fileExtension);
  bool get isImage => ['jpg', 'jpeg', 'png'].contains(fileExtension);
}
