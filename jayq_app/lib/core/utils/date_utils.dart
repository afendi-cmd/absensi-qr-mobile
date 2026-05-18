import 'package:intl/intl.dart';

/// Utility class untuk formatting dan manipulasi tanggal/waktu
class DateTimeUtils {
  // Format tanggal Indonesia
  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  // Format tanggal pendek (01 Jan 2024)
  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM yyyy', 'id_ID').format(date);
  }

  // Format waktu (14:30)
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // Format tanggal dan waktu lengkap
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMMM yyyy, HH:mm', 'id_ID').format(dateTime);
  }

  // Format untuk display di card (Senin, 01 Jan)
  static String formatDayDate(DateTime date) {
    return DateFormat('EEEE, dd MMM', 'id_ID').format(date);
  }

  // Cek apakah hari ini
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  // Cek apakah kemarin
  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day;
  }

  // Get relative time (2 jam yang lalu, 3 hari yang lalu)
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} minggu yang lalu';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} bulan yang lalu';
    } else {
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    }
  }

  // Get nama hari dalam bahasa Indonesia
  static String getDayName(DateTime date) {
    const days = [
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
      'Minggu',
    ];
    return days[date.weekday - 1];
  }

  // Get nama bulan dalam bahasa Indonesia
  static String getMonthName(DateTime date) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return months[date.month - 1];
  }

  // Parse string ISO ke DateTime
  static DateTime? parseISOString(String? isoString) {
    if (isoString == null || isoString.isEmpty) return null;
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }

  // Get range tanggal untuk minggu ini
  static Map<String, DateTime> getCurrentWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return {
      'start': DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day),
      'end': DateTime(
        endOfWeek.year,
        endOfWeek.month,
        endOfWeek.day,
        23,
        59,
        59,
      ),
    };
  }

  // Get range tanggal untuk bulan ini
  static Map<String, DateTime> getCurrentMonth() {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1);
    final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59);
    return {'start': firstDay, 'end': lastDay};
  }

  // Cek apakah waktu sudah lewat
  static bool isPast(DateTime dateTime) {
    return dateTime.isBefore(DateTime.now());
  }

  // Cek apakah waktu di masa depan
  static bool isFuture(DateTime dateTime) {
    return dateTime.isAfter(DateTime.now());
  }

  // Get durasi dalam format readable (2j 30m)
  static String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours > 0) {
      return '${hours}j ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}
