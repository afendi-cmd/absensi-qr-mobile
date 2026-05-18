import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class AdminScheduleScreen extends StatefulWidget {
  const AdminScheduleScreen({super.key});

  @override
  State<AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<AdminScheduleScreen> {
  String _selectedFilter = 'Semua';

  // Dummy data - nanti bisa diganti dengan data dari API
  final List<Map<String, dynamic>> _schedules = [
    {
      'id': 1,
      'course': 'Pemrograman Mobile',
      'class': 'TI-3A',
      'lecturer': 'Dr. Ahmad Fauzi',
      'day': 'Senin',
      'time': '08:00 - 10:00',
      'room': 'Lab Komputer 1',
      'students': 42,
      'status': 'Aktif',
    },
    {
      'id': 2,
      'course': 'Basis Data Lanjut',
      'class': 'TI-3B',
      'lecturer': 'Prof. Siti Nurhaliza',
      'day': 'Selasa',
      'time': '10:00 - 12:00',
      'room': 'Ruang 301',
      'students': 38,
      'status': 'Aktif',
    },
    {
      'id': 3,
      'course': 'Jaringan Komputer',
      'class': 'TI-3C',
      'lecturer': 'Dr. Budi Santoso',
      'day': 'Rabu',
      'time': '13:00 - 15:00',
      'room': 'Lab Jaringan',
      'students': 35,
      'status': 'Aktif',
    },
    {
      'id': 4,
      'course': 'Kecerdasan Buatan',
      'class': 'TI-4A',
      'lecturer': 'Dr. Rina Wijaya',
      'day': 'Kamis',
      'time': '08:00 - 10:00',
      'room': 'Ruang 402',
      'students': 40,
      'status': 'Selesai',
    },
    {
      'id': 5,
      'course': 'Sistem Informasi',
      'class': 'SI-3A',
      'lecturer': 'Dr. Hendra Gunawan',
      'day': 'Jumat',
      'time': '10:00 - 12:00',
      'room': 'Ruang 201',
      'students': 45,
      'status': 'Aktif',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildFilterChips(isDark),
            Expanded(child: _buildScheduleList(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Jadwal Kuliah',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Add schedule
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Filter
            },
            icon: Icon(
              Icons.filter_list,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = ['Semua', 'Aktif', 'Selesai', 'Hari Ini'];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
              selectedColor: const Color(0xFF2563EB),
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : const Color(0xFF111827)),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _schedules.length,
      itemBuilder: (context, index) {
        final schedule = _schedules[index];
        return _buildScheduleCard(schedule, isDark);
      },
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showScheduleDetail(schedule, isDark);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        schedule['course'],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: schedule['status'] == 'Aktif'
                            ? (isDark
                                  ? const Color(0xFF065F46)
                                  : const Color(0xFFD1FAE5))
                            : (isDark
                                  ? const Color(0xFF374151)
                                  : const Color(0xFFF3F4F6)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        schedule['status'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: schedule['status'] == 'Aktif'
                              ? const Color(0xFF10B981)
                              : (isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  schedule['class'],
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      schedule['lecturer'],
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${schedule['day']}, ${schedule['time']}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.room_outlined,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      schedule['room'],
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.groups_outlined,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${schedule['students']} Mahasiswa',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScheduleDetail(Map<String, dynamic> schedule, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              schedule['course'],
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(
              Icons.class_outlined,
              'Kelas',
              schedule['class'],
              isDark,
            ),
            _buildDetailRow(
              Icons.person_outline,
              'Dosen',
              schedule['lecturer'],
              isDark,
            ),
            _buildDetailRow(
              Icons.calendar_today,
              'Hari',
              schedule['day'],
              isDark,
            ),
            _buildDetailRow(
              Icons.access_time,
              'Waktu',
              schedule['time'],
              isDark,
            ),
            _buildDetailRow(
              Icons.room_outlined,
              'Ruangan',
              schedule['room'],
              isDark,
            ),
            _buildDetailRow(
              Icons.groups_outlined,
              'Mahasiswa',
              '${schedule['students']} orang',
              isDark,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Edit schedule
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: View attendance
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Lihat Presensi'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
