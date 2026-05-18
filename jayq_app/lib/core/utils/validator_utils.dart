/// Utility class untuk validasi form
class ValidatorUtils {
  // Validate required field
  static String? required(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName tidak boleh kosong';
    }
    return null;
  }

  // Validate email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email tidak boleh kosong';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // Validate password
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < minLength) {
      return 'Password minimal $minLength karakter';
    }

    return null;
  }

  // Validate password with strength
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }

    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password harus mengandung huruf besar';
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password harus mengandung huruf kecil';
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password harus mengandung angka';
    }

    return null;
  }

  // Validate confirm password
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }

    if (value != password) {
      return 'Password tidak cocok';
    }

    return null;
  }

  // Validate phone number (Indonesia)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }

    final cleanPhone = value.replaceAll(RegExp(r'[\s-]'), '');
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');

    if (!phoneRegex.hasMatch(cleanPhone)) {
      return 'Format nomor telepon tidak valid';
    }

    return null;
  }

  // Validate NIM/NIP
  static String? nim(String? value, {int length = 9}) {
    if (value == null || value.isEmpty) {
      return 'NIM tidak boleh kosong';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return 'NIM hanya boleh berisi angka';
    }

    if (value.length != length) {
      return 'NIM harus $length digit';
    }

    return null;
  }

  // Validate min length
  static String? minLength(
    String? value,
    int min, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (value.length < min) {
      return '$fieldName minimal $min karakter';
    }

    return null;
  }

  // Validate max length
  static String? maxLength(
    String? value,
    int max, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty if not required
    }

    if (value.length > max) {
      return '$fieldName maksimal $max karakter';
    }

    return null;
  }

  // Validate numeric
  static String? numeric(String? value, {String fieldName = 'Field'}) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    if (double.tryParse(value) == null) {
      return '$fieldName harus berupa angka';
    }

    return null;
  }

  // Validate min value
  static String? minValue(
    String? value,
    double min, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName harus berupa angka';
    }

    if (number < min) {
      return '$fieldName minimal $min';
    }

    return null;
  }

  // Validate max value
  static String? maxValue(
    String? value,
    double max, {
    String fieldName = 'Field',
  }) {
    if (value == null || value.isEmpty) {
      return '$fieldName tidak boleh kosong';
    }

    final number = double.tryParse(value);
    if (number == null) {
      return '$fieldName harus berupa angka';
    }

    if (number > max) {
      return '$fieldName maksimal $max';
    }

    return null;
  }

  // Validate URL
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL tidak boleh kosong';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Format URL tidak valid';
    }

    return null;
  }

  // Validate date format (YYYY-MM-DD)
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Tanggal tidak boleh kosong';
    }

    try {
      DateTime.parse(value);
      return null;
    } catch (e) {
      return 'Format tanggal tidak valid (YYYY-MM-DD)';
    }
  }

  // Validate time format (HH:MM)
  static String? time(String? value) {
    if (value == null || value.isEmpty) {
      return 'Waktu tidak boleh kosong';
    }

    final timeRegex = RegExp(r'^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');

    if (!timeRegex.hasMatch(value)) {
      return 'Format waktu tidak valid (HH:MM)';
    }

    return null;
  }

  // Combine multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
