class TugasModel {
  final int id;
  final int mataKuliahId;
  final String judul;
  final String deskripsi;
  final DateTime deadline;
  final String? fileUrl;
  final String? mataKuliahName;
  final bool? isSubmitted;
  final DateTime? createdAt;

  TugasModel({
    required this.id,
    required this.mataKuliahId,
    required this.judul,
    required this.deskripsi,
    required this.deadline,
    this.fileUrl,
    this.mataKuliahName,
    this.isSubmitted,
    this.createdAt,
  });

  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id'] ?? 0,
      mataKuliahId: json['mata_kuliah_id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now(),
      fileUrl: json['file_url'],
      mataKuliahName:
          json['mata_kuliah_name'] ?? json['mata_kuliah']?['nama_mk'],
      isSubmitted: json['is_submitted'],
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
      'deadline': deadline.toIso8601String(),
      'file_url': fileUrl,
      'mata_kuliah_name': mataKuliahName,
      'is_submitted': isSubmitted,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  bool get isOverdue => DateTime.now().isAfter(deadline);

  Duration get timeRemaining => deadline.difference(DateTime.now());
}
