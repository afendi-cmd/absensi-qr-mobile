import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/matakuliah_service.dart';
import 'qr_scanner_screen.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _mataKuliahService = MataKuliahService();
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, List<Map<String, dynamic>>> _groupedSchedules = {};
  int _selectedDayIndex = 0;

  final List<Map<String, dynamic>> _weekDays = [];

  @override
  void initState() {
    super.initState();
    _generateWeekDays();
    _loadSchedule();
  }

  void _generateWeekDays() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));

    final dayNames = ['SEN', 'SEL', 'RAB', 'KAM', 'JUM', 'SAB'];

    for (int i = 0; i < 6; i++) {
      final date = monday.add(Duration(days: i));
      _weekDays.add({'name': dayNames[i], 'date': date.day, 'fullDate': date});
    }

    // Set selected to today
    _selectedDayIndex = now.weekday - 1;
    if (_selectedDayIndex < 0 || _selectedDayIndex > 5) {
      _selectedDayIndex = 0;
    }
  }

  Future<void> _loadSchedule() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final mataKuliahList = await _mataKuliahService.getMahasiswaMataKuliah();
      final grouped = _groupScheduleByDay(mataKuliahList);

      setState(() {
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

  Map<String, List<Map<String, dynamic>>> _groupScheduleByDay(
    List<Map<String, dynamic>> mataKuliahList,
  ) {
    final Map<String, List<Map<String, dynamic>>> grouped = {
      'senin': [],
      'selasa': [],
      'rabu': [],
      'kamis': [],
      'jumat': [],
      'sabtu': [],
    };

    for (final mk in mataKuliahList) {
      final hari = mk['hari']?.toString().toLowerCase();
      if (hari != null && grouped.containsKey(hari)) {
        grouped[hari]!.add(mk);
      }
    }

    // Sort by jam_mulai
    for (final key in grouped.keys) {
      grouped[key]!.sort((a, b) {
        final jamMulaiA = a['jam_mulai']?.toString() ?? '00:00';
        final jamMulaiB = b['jam_mulai']?.toString() ?? '00:00';
        return jamMulaiA.compareTo(jamMulaiB);
      });
    }

    return grouped;
  }

  String _getStatusForSchedule(Map<String, dynamic> schedule) {
    final now = DateTime.now();
    final currentTime = TimeOfDay.now();

    // Check if schedule has time data
    final jamMulai = schedule['jam_mulai']?.toString();
    final jamSelesai = schedule['jam_selesai']?.toString();

    if (jamMulai == null || jamSelesai == null) {
      return 'Belum Mulai';
    }

    // Parse jam_mulai and jam_selesai
    final startParts = jamMulai.split(':');
    final endParts = jamSelesai.split(':');

    final startTime = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );
    final endTime = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );

    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    // Check if today matches schedule day
    final dayNames = ['senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu'];
    final todayName = dayNames[now.weekday - 1];

    if (schedule['hari']?.toString().toLowerCase() != todayName) {
      return 'Belum Mulai';
    }

    if (currentMinutes < startMinutes) {
      return 'Belum Mulai';
    } else if (currentMinutes >= startMinutes && currentMinutes <= endMinutes) {
      return 'Berlangsung';
    } else {
      return 'Selesai';
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Selesai':
        return const Color(0xFF10B981);
      case 'Berlangsung':
        return const Color(0xFF003d9b);
      case 'Belum Mulai':
        return const Color(0xFF6B7280);
      default:
        return const Color(0xFF6B7280);
    }
  }

  Color _getStatusBgColor(String status) {
    switch (status) {
      case 'Selesai':
        return const Color(0xFFD1FAE5);
      case 'Berlangsung':
        return const Color(0xFFDCE9FF);
      case 'Belum Mulai':
        return const Color(0xFFF3F4F6);
      default:
        return const Color(0xFFF3F4F6);
    }
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
            _buildHeader(),
            _buildDaySelector(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage.isNotEmpty
                  ? _buildErrorState()
                  : _buildScheduleList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF003d9b),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Jadwal Kuliah',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.notifications_outlined,
                  color: isDark ? Colors.white : const Color(0xFF003d9b),
                ),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Satu semester, satu genggaman.',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDaySelector() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      height: 90,
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _weekDays.length,
        itemBuilder: (context, index) {
          final day = _weekDays[index];
          final isSelected = index == _selectedDayIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDayIndex = index;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF003d9b)
                    : (isDark ? const Color(0xFF374151) : Colors.white),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF003d9b)
                      : (isDark
                            ? const Color(0xFF4B5563)
                            : const Color(0xFFE1E2E4)),
                  width: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day['name'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.white
                          : (isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF737685)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${day['date']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? Colors.white : const Color(0xFF191c1e)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
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

  Widget _buildErrorState() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
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
            ElevatedButton(
              onPressed: _loadSchedule,
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
              child: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleList() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final dayNames = ['senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu'];
    final selectedDay = dayNames[_selectedDayIndex];
    final schedules = _groupedSchedules[selectedDay] ?? [];

    if (schedules.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadSchedule,
        color: const Color(0xFF003d9b),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    size: 80,
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Tidak ada jadwal kuliah lainnya.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSchedule,
      color: const Color(0xFF003d9b),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: schedules.length,
        itemBuilder: (context, index) {
          final schedule = schedules[index];
          final status = _getStatusForSchedule(schedule);
          return _buildScheduleCard(schedule, status);
        },
      ),
    );
  }

  Widget _buildScheduleCard(Map<String, dynamic> schedule, String status) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final statusColor = _getStatusColor(status);
    final statusBgColor = _getStatusBgColor(status);
    final isBerlangsung = status == 'Berlangsung';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isBerlangsung
            ? (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDCE9FF))
            : (isDark ? const Color(0xFF1F2937) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isBerlangsung
              ? const Color(0xFF003d9b)
              : (isDark ? const Color(0xFF374151) : const Color(0xFFE1E2E4)),
          width: isBerlangsung ? 2 : 1,
        ),
        boxShadow: [
          if (isBerlangsung)
            BoxShadow(
              color: const Color(0xFF003d9b).withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time and Status
            Row(
              children: [
                Text(
                  '${schedule['jam_mulai'] ?? '00:00'} - ${schedule['jam_selesai'] ?? '00:00'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isBerlangsung
                        ? const Color(0xFF003d9b)
                        : const Color(0xFF191c1e),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Course Name
            Text(
              schedule['nama_mk'] ?? 'Mata Kuliah',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isBerlangsung
                    ? const Color(0xFF003d9b)
                    : const Color(0xFF191c1e),
              ),
            ),
            const SizedBox(height: 12),

            // Lecturer
            if (schedule['dosen'] != null)
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: isBerlangsung
                        ? const Color(0xFF003d9b)
                        : const Color(0xFF737685),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    schedule['dosen']['nama'] ?? 'Dosen',
                    style: TextStyle(
                      fontSize: 14,
                      color: isBerlangsung
                          ? const Color(0xFF003d9b)
                          : const Color(0xFF737685),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 8),

            // Location
            if (schedule['ruangan'] != null)
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 16,
                    color: isBerlangsung
                        ? const Color(0xFF003d9b)
                        : const Color(0xFF737685),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    schedule['ruangan'],
                    style: TextStyle(
                      fontSize: 14,
                      color: isBerlangsung
                          ? const Color(0xFF003d9b)
                          : const Color(0xFF737685),
                    ),
                  ),
                ],
              ),

            // Action Button
            if (isBerlangsung) ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrScannerScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003d9b),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.qr_code_scanner, size: 20),
                  label: const Text(
                    'Scan Kehadiran',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ] else if (status == 'Selesai') ...[
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    // Navigate to attendance history
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF003d9b),
                    side: const BorderSide(color: Color(0xFF003d9b)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Lihat Presensi',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: Color(0xFF6B7280),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Presensi Belum Dibuka',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
