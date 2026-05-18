/// Utility class untuk manipulasi string
class StringUtils {
  // Capitalize first letter
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  // Capitalize setiap kata
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  // Get initials dari nama (John Doe -> JD)
  static String getInitials(String name, {int maxLength = 2}) {
    if (name.isEmpty) return '';

    final words = name.trim().split(' ');
    String initials = '';

    for (var i = 0; i < words.length && i < maxLength; i++) {
      if (words[i].isNotEmpty) {
        initials += words[i][0].toUpperCase();
      }
    }

    return initials;
  }

  // Truncate text dengan ellipsis
  static String truncate(
    String text,
    int maxLength, {
    String ellipsis = '...',
  }) {
    if (text.length <= maxLength) return text;
    return text.substring(0, maxLength - ellipsis.length) + ellipsis;
  }

  // Remove extra spaces
  static String removeExtraSpaces(String text) {
    return text.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Mask email (john@example.com -> j***@example.com)
  static String maskEmail(String email) {
    if (!email.contains('@')) return email;

    final parts = email.split('@');
    final username = parts[0];
    final domain = parts[1];

    if (username.length <= 2) return email;

    return '${username[0]}${'*' * (username.length - 1)}@$domain';
  }

  // Mask phone number (081234567890 -> 0812****7890)
  static String maskPhone(String phone) {
    if (phone.length < 8) return phone;

    final start = phone.substring(0, 4);
    final end = phone.substring(phone.length - 4);

    return '$start${'*' * (phone.length - 8)}$end';
  }

  // Format NIM/NIP (202301001 -> 2023.01.001)
  static String formatNIM(String nim) {
    if (nim.length < 9) return nim;

    return '${nim.substring(0, 4)}.${nim.substring(4, 6)}.${nim.substring(6)}';
  }

  // Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // Validate phone number (Indonesia)
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^(\+62|62|0)[0-9]{9,12}$');
    return phoneRegex.hasMatch(phone.replaceAll(RegExp(r'[\s-]'), ''));
  }

  // Format file size (1024 -> 1 KB)
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Remove special characters
  static String removeSpecialChars(String text) {
    return text.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '');
  }

  // Convert to slug (Hello World -> hello-world)
  static String toSlug(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_-]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
  }

  // Check if string is numeric
  static bool isNumeric(String text) {
    return double.tryParse(text) != null;
  }

  // Format currency (1000000 -> Rp 1.000.000)
  static String formatCurrency(double amount, {String symbol = 'Rp'}) {
    final formatter = amount.toStringAsFixed(0);
    final parts = <String>[];

    for (var i = formatter.length - 1; i >= 0; i -= 3) {
      final start = i - 2 < 0 ? 0 : i - 2;
      parts.insert(0, formatter.substring(start, i + 1));
    }

    return '$symbol ${parts.join('.')}';
  }

  // Generate random string
  static String generateRandomString(int length) {
    const chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      length,
      (index) =>
          chars[(DateTime.now().millisecondsSinceEpoch + index) % chars.length],
    ).join();
  }
}
