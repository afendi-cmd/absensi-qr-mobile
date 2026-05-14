class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? nip;
  final String? nim;
  final String? photoUrl;
  final String? phone;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.nip,
    this.nim,
    this.photoUrl,
    this.phone,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['nama'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      nip: json['nip'],
      nim: json['nim'],
      photoUrl: json['photo_url'],
      phone: json['phone'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'nip': nip,
      'nim': nim,
      'photo_url': photoUrl,
      'phone': phone,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isDosen => role.toLowerCase() == 'dosen';
  bool get isMahasiswa => role.toLowerCase() == 'mahasiswa';
}
