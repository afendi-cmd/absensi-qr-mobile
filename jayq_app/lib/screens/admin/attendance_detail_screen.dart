import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../providers/theme_provider.dart';
import '../../data/models/mata_kuliah.dart';
import '../../data/services/storage_service.dart';
import '../../core/constants/app_constants.dart';

class AttendanceDetailScreen extends StatefulWidget {
  final MataKuliah mataKuliah;

  const AttendanceDetailScreen({super.key, required this.mataKuliah});

  @override
  State<AttendanceDetailScreen> createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _attendanceList = [];
  Map<String, dynamic>? _stats;
  String _selectedFilter = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    setState(() => _isLoading = true);

    try {
      final storageService = StorageService();
      final token = await storageService.getToken();

      final dio = Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';
      dio.options.headers['Accept'] = 'application/json';

      final response = await dio.get(
        '${AppConstants.baseUrl}/mata-kuliah/${widget.mataKuliah.id}/absensi',
      );

      if (response.data['success']) {
        setState(() {
          _attendanceList = List<Map<String, dynamic>>.from(
            response.data['data'] ?? [],
          );
          _calculateStats();
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _calculateStats() {
    if (_attendanceList.isEmpty) {
      _stats = {
        'total_pertemuan': 0,
        'total_hadir': 0,
        'rata_rata_kehadiran': 0.0,
      };
      return;
    }

    // Hitung total pertemuan unik
    final uniqueSessions = _attendanceList
        .map((item) => item['qr_session_id'])
        .toSet()
        .length;

    _stats = {
      'total_pertemuan': uniqueSessions,
      'total_hadir': _attendanceList.length,
      'rata_rata_kehadiran': uniqueSessions > 0
          ? (_attendanceList.length / uniqueSessions)
          : 0.0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Presensi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAttendanceData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildCourseInfo(isDark),
                      const SizedBox(height: 16),
                      _buildStatsCards(isDark),
                      const SizedBox(height: 20),
                      _buildFilterChips(isDark),
                      const SizedBox(height: 16),
                      _buildAttendanceList(isDark),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildCourseInfo(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.mataKuliah.namaMk,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.mataKuliah.kodeMk,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${widget.mataKuliah.sks} SKS',
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
                Icons.person_outline,
                size: 16,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
              const SizedBox(width: 6),
              Text(
                widget.mataKuliah.dosen?.nama ?? 'Belum ada dosen',
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
    );
  }

  Widget _buildStatsCards(bool isDark) {
    if (_stats == null) return const SizedBox.shrink();

    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Pertemuan',
            '${_stats!['total_pertemuan']}',
            Icons.calendar_today,
            const Color(0xFF2563EB),
            isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Total Hadir',
            '${_stats!['total_hadir']}',
            Icons.check_circle_outline,
            const Color(0xFF10B981),
            isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = ['Semua', 'Hari Ini', 'Minggu Ini', 'Bulan Ini'];

    return SizedBox(
      height: 40,
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
                fontSize: 13,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAttendanceList(bool isDark) {
    if (_attendanceList.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: isDark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada data presensi',
              style: TextStyle(
                fontSize: 16,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      );
    }

    // Group by date
    final groupedByDate = <String, List<Map<String, dynamic>>>{};
    for (var item in _attendanceList) {
      final date = item['created_at'].toString().split('T')[0];
      if (!groupedByDate.containsKey(date)) {
        groupedByDate[date] = [];
      }
      groupedByDate[date]!.add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Riwayat Presensi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        ...groupedByDate.entries.map((entry) {
          return _buildDateGroup(entry.key, entry.value, isDark);
        }),
      ],
    );
  }

  Widget _buildDateGroup(
    String date,
    List<Map<String, dynamic>> items,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            _formatDate(date),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ),
        ...items.map((item) => _buildAttendanceItem(item, isDark)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildAttendanceItem(Map<String, dynamic> item, bool isDark) {
    final mahasiswa = item['mahasiswa'] ?? item['user'];
    final nama = mahasiswa?['nama'] ?? 'Unknown';
    final nim = mahasiswa?['nim'] ?? '-';
    final time = item['created_at'].toString().split('T')[1].substring(0, 5);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: Color(0xFF10B981), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nama,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nim,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String date) {
    final parts = date.split('-');
    if (parts.length != 3) return date;

    final months = [
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

    final year = parts[0];
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);

    return '$day ${months[month - 1]} $year';
  }
}
