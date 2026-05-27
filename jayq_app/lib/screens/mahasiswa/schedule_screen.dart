import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/schedule_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScheduleService _scheduleService;

  bool _isLoading = false;
  String _errorMessage = '';
  List<ScheduleModel> _allSchedules = [];
  Map<String, List<ScheduleModel>> _groupedSchedules = {};

  final List<String> _days = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _days.length, vsync: this);
    _initializeService();

    // Set tab to today
    final today = DateTime.now().weekday;
    if (today >= 1 && today <= 6) {
      _tabController.index = today - 1;
    }
  }

  Future<void> _initializeService() async {
    final storageService = StorageService();
    final token = await storageService.getToken();

    final dio = Dio();
    dio.options.baseUrl = 'http://10.0.2.2:8000/api';
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Accept'] = 'application/json';

    _scheduleService = ScheduleService(dio);
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final schedules = await _scheduleService.getMahasiswaSchedule();
      final grouped = _scheduleService.groupScheduleByDay(schedules);

      setState(() {
        _allSchedules = schedules;
        _groupedSchedules = grouped;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildTabBar(isDark),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage.isNotEmpty
                  ? _buildErrorState(isDark)
                  : _buildScheduleContent(isDark),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      child: Row(
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: Color(0xFF003d9b),
            size: 24,
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Jadwal Kuliah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF003d9b),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark ? Colors.white : const Color(0xFF003d9b),
            ),
            onPressed: _loadSchedule,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: const Color(0xFF003d9b),
        indicatorWeight: 3,
        labelColor: const Color(0xFF003d9b),
        unselectedLabelColor: isDark
            ? const Color(0xFF9CA3AF)
            : const Color(0xFF6B7280),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        tabs: _days.map((day) => Tab(text: day)).toList(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF003d9b)),
      ),
    );
  }

  Widget _buildErrorState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadSchedule,
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003d9b),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleContent(bool isDark) {
    return TabBarView(
      controller: _tabController,
      children: _days.map((day) {
        final dayKey = day.toLowerCase();
        final schedules = _groupedSchedules[dayKey] ?? [];

        if (schedules.isEmpty) {
          return _buildEmptyState(day, isDark);
        }

        return RefreshIndicator(
          onRefresh: _loadSchedule,
          color: const Color(0xFF003d9b),
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              return _buildScheduleCard(schedules[index], isDark);
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState(String day, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy_rounded,
            size: 80,
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada jadwal',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tidak ada mata kuliah di hari $day',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleCard(ScheduleModel schedule, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
        ),
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
          onTap: () => _showScheduleDetail(schedule, isDark),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Time Badge
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.access_time_rounded,
                            size: 16,
                            color: Color(0xFF003d9b),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            schedule.timeRange,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF003d9b),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${schedule.sks} SKS',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Course Name
                Text(
                  schedule.namaMk,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 4),

                // Course Code
                Text(
                  schedule.kodeMk,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 12),

                // Location
                if (schedule.ruangan != null) ...[
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        schedule.ruangan!,
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
                ],

                // Lecturer
                if (schedule.dosen != null)
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        size: 16,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          schedule.dosen!.nama,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
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

  void _showScheduleDetail(ScheduleModel schedule, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
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

            // Title
            Text(
              'Detail Jadwal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),

            // Course Info
            _buildDetailRow(
              Icons.book_rounded,
              'Mata Kuliah',
              schedule.namaMk,
              isDark,
            ),
            _buildDetailRow(
              Icons.tag_rounded,
              'Kode MK',
              schedule.kodeMk,
              isDark,
            ),
            _buildDetailRow(
              Icons.calendar_today_rounded,
              'Hari',
              schedule.hariCapitalized,
              isDark,
            ),
            _buildDetailRow(
              Icons.access_time_rounded,
              'Waktu',
              schedule.timeRange,
              isDark,
            ),
            if (schedule.ruangan != null)
              _buildDetailRow(
                Icons.location_on_rounded,
                'Ruangan',
                schedule.ruangan!,
                isDark,
              ),
            if (schedule.dosen != null)
              _buildDetailRow(
                Icons.person_rounded,
                'Dosen',
                schedule.dosen!.nama,
                isDark,
              ),
            _buildDetailRow(
              Icons.school_rounded,
              'SKS',
              '${schedule.sks} SKS',
              isDark,
            ),

            const SizedBox(height: 24),

            // Close Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003d9b),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF003d9b).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF003d9b)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
