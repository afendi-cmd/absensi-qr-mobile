import 'user_model.dart';
import 'mata_kuliah_model.dart';

class PesertaMk {
  final int id;
  final int mahasiswaId;
  final int mataKuliahId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final UserModel? mahasiswa;
  final MataKuliahModel? mataKuliah;

  PesertaMk({
    required this.id,
    required this.mahasiswaId,
    required this.mataKuliahId,
    required this.createdAt,
    required this.updatedAt,
    this.mahasiswa,
    this.mataKuliah,
  });

  factory PesertaMk.fromJson(Map<String, dynamic> json) {
    return PesertaMk(
      id: json['id'] ?? 0,
      mahasiswaId: json['mahasiswa_id'] ?? 0,
      mataKuliahId: json['mata_kuliah_id'] ?? 0,
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
      mahasiswa: json['mahasiswa'] != null
          ? UserModel.fromJson(json['mahasiswa'])
          : null,
      mataKuliah: json['mata_kuliah'] != null
          ? MataKuliahModel.fromJson(json['mata_kuliah'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mahasiswa_id': mahasiswaId,
      'mata_kuliah_id': mataKuliahId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'mahasiswa': mahasiswa?.toJson(),
      'mata_kuliah': mataKuliah?.toJson(),
    };
  }
}
