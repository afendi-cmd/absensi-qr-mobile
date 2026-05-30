class PengumumanModel {
  final int id;
  final String judul;
  final String isi;
  final String tipe; // info, penting, urgent
  final String target; // all, dosen, mahasiswa
  final bool isActive;
  final Creator? creator;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isRead;

  PengumumanModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tipe,
    required this.target,
    required this.isActive,
    this.creator,
    required this.createdAt,
    required this.updatedAt,
    this.isRead = false,
  });

  factory PengumumanModel.fromJson(Map<String, dynamic> json) {
    return PengumumanModel(
      id: json['id'] ?? 0,
      judul: json['judul'] ?? '',
      isi: json['isi'] ?? '',
      tipe: json['tipe'] ?? 'info',
      target: json['target'] ?? 'all',
      isActive: json['is_active'] ?? true,
      creator: json['creator'] != null
          ? Creator.fromJson(json['creator'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
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
      'creator': creator?.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_read': isRead,
    };
  }

  // Helper methods
  String get tipeLabel {
    switch (tipe) {
      case 'info':
        return 'Info';
      case 'penting':
        return 'Penting';
      case 'urgent':
        return 'Urgent';
      default:
        return 'Info';
    }
  }

  String get targetLabel {
    switch (target) {
      case 'all':
        return 'Semua';
      case 'dosen':
        return 'Dosen';
      case 'mahasiswa':
        return 'Mahasiswa';
      default:
        return 'Semua';
    }
  }

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Baru saja';
        }
        return '${difference.inMinutes} menit yang lalu';
      }
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays == 1) {
      return 'Kemarin';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
    }
  }
}

class Creator {
  final int id;
  final String nama;
  final String email;

  Creator({required this.id, required this.nama, required this.email});

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      id: json['id'] ?? 0,
      nama: json['nama'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'email': email};
  }
}
