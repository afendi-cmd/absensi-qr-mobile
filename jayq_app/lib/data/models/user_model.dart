class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? nip;
  final String? nim;
  final String? nidn;
  final String? photoUrl;
  final String? phone;
  final String? noHp;
  final String? alamat;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.nip,
    this.nim,
    this.nidn,
    this.photoUrl,
    this.phone,
    this.noHp,
    this.alamat,
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
      nidn: json['nidn'],
      photoUrl: json['photo_url'],
      phone: json['phone'],
      noHp: json['no_hp'],
      alamat: json['alamat'],
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
      'nidn': nidn,
      'photo_url': photoUrl,
      'phone': phone,
      'no_hp': noHp,
      'alamat': alamat,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isDosen => role.toLowerCase() == 'dosen';
  bool get isMahasiswa => role.toLowerCase() == 'mahasiswa';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
