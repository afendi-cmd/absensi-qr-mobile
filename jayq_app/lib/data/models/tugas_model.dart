import 'materi_model.dart';

class TugasModel {
  final int id;
  final int mataKuliahId;
  final String judul;
  final String? deskripsi;
  final String? fileTugas;
  final DateTime deadline;
  final MataKuliahInfo? mataKuliah;
  final bool sudahDikumpulkan;
  final PengumpulanTugas? pengumpulan;
  final DateTime createdAt;
  final DateTime updatedAt;

  TugasModel({
    required this.id,
    required this.mataKuliahId,
    required this.judul,
    this.deskripsi,
    this.fileTugas,
    required this.deadline,
    this.mataKuliah,
    this.sudahDikumpulkan = false,
    this.pengumpulan,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TugasModel.fromJson(Map<String, dynamic> json) {
    return TugasModel(
      id: json['id'] ?? 0,
      mataKuliahId: json['mata_kuliah_id'] ?? 0,
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'],
      fileTugas: json['file_tugas'],
      deadline: json['deadline'] != null
          ? DateTime.parse(json['deadline'])
          : DateTime.now(),
      mataKuliah: json['mata_kuliah'] != null
          ? MataKuliahInfo.fromJson(json['mata_kuliah'])
          : null,
      sudahDikumpulkan: json['sudah_dikumpulkan'] ?? false,
      pengumpulan: json['pengumpulan'] != null
          ? PengumpulanTugas.fromJson(json['pengumpulan'])
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
      'file_tugas': fileTugas,
      'deadline': deadline.toIso8601String(),
      'mata_kuliah': mataKuliah?.toJson(),
      'sudah_dikumpulkan': sudahDikumpulkan,
      'pengumpulan': pengumpulan?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  String get statusLabel {
    if (sudahDikumpulkan) {
      return 'Sudah Dikumpulkan';
    } else if (isOverdue) {
      return 'Terlambat';
    } else {
      return 'Belum Dikumpulkan';
    }
  }

  bool get isOverdue {
    return DateTime.now().isAfter(deadline) && !sudahDikumpulkan;
  }

  String get formattedDeadline {
    final now = DateTime.now();
    final difference = deadline.difference(now);

    if (difference.isNegative) {
      return 'Terlambat';
    } else if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} menit lagi';
      }
      return '${difference.inHours} jam lagi';
    } else if (difference.inDays == 1) {
      return 'Besok';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari lagi';
    } else {
      return '${deadline.day}/${deadline.month}/${deadline.year}';
    }
  }
}

class PengumpulanTugas {
  final int id;
  final int tugasId;
  final int mahasiswaId;
  final String fileJawaban;
  final DateTime tanggalUpload;
  final int? nilai;
  final String? catatan;

  PengumpulanTugas({
    required this.id,
    required this.tugasId,
    required this.mahasiswaId,
    required this.fileJawaban,
    required this.tanggalUpload,
    this.nilai,
    this.catatan,
  });

  factory PengumpulanTugas.fromJson(Map<String, dynamic> json) {
    return PengumpulanTugas(
      id: json['id'] ?? 0,
      tugasId: json['tugas_id'] ?? 0,
      mahasiswaId: json['mahasiswa_id'] ?? 0,
      fileJawaban: json['file_jawaban'] ?? '',
      tanggalUpload: json['tanggal_upload'] != null
          ? DateTime.parse(json['tanggal_upload'])
          : DateTime.now(),
      nilai: json['nilai'],
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tugas_id': tugasId,
      'mahasiswa_id': mahasiswaId,
      'file_jawaban': fileJawaban,
      'tanggal_upload': tanggalUpload.toIso8601String(),
      'nilai': nilai,
      'catatan': catatan,
    };
  }

  bool get sudahDinilai => nilai != null;
}
