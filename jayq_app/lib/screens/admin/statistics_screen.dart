import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/absensi_service.dart';
import '../../data/services/matakuliah_service.dart';
import '../../data/services/storage_service.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late AbsensiService _absensiService;
  late MataKuliahService _mataKuliahService;

  String _selectedPeriod = 'Bulan Ini';
  bool _isLoading = false;
  String _errorMessage = '';

  List<Map<String, dynamic>> _allAbsensi = [];
  List<Map<String, dynamic>> _allMataKuliah = [];

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final storageService = StorageService();
    final token = await storageService.getToken();

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Accept'] = 'application/json';

    _absensiService = AbsensiService(dio);
    _mataKuliahService = MataKuliahService();

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Calculate date range based on selected period
      final dateRange = _getDateRange(_selectedPeriod);

      // Load data from API
      final absensi = await _absensiService.getAllAbsensi(
        tanggalMulai: dateRange['start'],
        tanggalSelesai: dateRange['end'],
      );

      final mataKuliah = await _mataKuliahService.getMataKuliah();

      setState(() {
        _allAbsensi = absensi;
        _allMataKuliah = mataKuliah;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Map<String, String> _getDateRange(String period) {
    final now = DateTime.now();
    DateTime start;
    DateTime end = now;

    switch (period) {
      case 'Hari Ini':
        start = DateTime(now.year, now.month, now.day);
        break;
      case 'Minggu Ini':
        start = now.subtract(Duration(days: now.weekday - 1));
        break;
      case 'Bulan Ini':
        start = DateTime(now.year, now.month, 1);
        break;
      case 'Semester Ini':
        // Assume semester starts in January or July
        final semesterStart = now.month <= 6 ? 1 : 7;
        start = DateTime(now.year, semesterStart, 1);
        break;
      default:
        start = DateTime(now.year, now.month, 1);
    }

    return {
      'start': DateFormat('yyyy-MM-dd').format(start),
      'end': DateFormat('yyyy-MM-dd').format(end),
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Laporan Presensi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
            onPressed: _loadData,
          ),
          IconButton(
            icon: Icon(
              Icons.download_rounded,
              color: isDark ? Colors.white : const Color(0xFF6B7280),
            ),
            onPressed: () => _showExportDialog(isDark),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? _buildErrorState(isDark)
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPeriodSelector(isDark),
                  _buildOverviewCards(isDark),
                  _buildMataKuliahList(isDark),
                  _buildRecentActivities(isDark),
                  const SizedBox(height: 20),
                ],
              ),
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
              Icons.error_outline,
              size: 64,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
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

  Widget _buildPeriodSelector(bool isDark) {
    final periods = ['Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Semester Ini'];

    return Container(
      height: 60,
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: periods.length,
        itemBuilder: (context, index) {
          final period = periods[index];
          final isSelected = _selectedPeriod == period;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(period),
              selected: isSelected,
              onSelected: (selected) {
                setState(() => _selectedPeriod = period);
                _loadData();
              },
              backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
              selectedColor: const Color(0xFF2563EB).withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: isSelected
                    ? const Color(0xFF2563EB)
                    : (isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280)),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                fontSize: 13,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : (isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFE5E7EB)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCards(bool isDark) {
    final totalAbsensi = _allAbsensi.length;
    final totalHadir = _allAbsensi.where((a) => a['status'] == 'hadir').length;
    final totalMataKuliah = _allMataKuliah.length;
    final persentaseKehadiran = totalAbsensi > 0
        ? (totalHadir / totalAbsensi * 100).toStringAsFixed(1)
        : '0.0';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.9,
            children: [
              _buildStatCard(
                'Total Kehadiran',
                '$totalHadir',
                Icons.check_circle_rounded,
                const Color(0xFF10B981),
                isDark,
              ),
              _buildStatCard(
                'Persentase',
                '$persentaseKehadiran%',
                Icons.trending_up_rounded,
                const Color(0xFF2563EB),
                isDark,
              ),
              _buildStatCard(
                'Total Absensi',
                '$totalAbsensi',
                Icons.assignment_turned_in_rounded,
                const Color(0xFF8B5CF6),
                isDark,
              ),
              _buildStatCard(
                'Mata Kuliah',
                '$totalMataKuliah',
                Icons.book_rounded,
                const Color(0xFFF59E0B),
                isDark,
              ),
            ],
          ),
        ],
      ),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF9CA3AF),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMataKuliahList(bool isDark) {
    if (_allMataKuliah.isEmpty) {
      return const SizedBox.shrink();
    }

    // Group absensi by mata kuliah
    final mataKuliahStats = <int, Map<String, dynamic>>{};
    for (final mk in _allMataKuliah) {
      final mkId = mk['id'];
      final absensiMk = _allAbsensi.where((a) => a['mata_kuliah_id'] == mkId);
      final totalAbsensi = absensiMk.length;
      final totalHadir = absensiMk.where((a) => a['status'] == 'hadir').length;

      mataKuliahStats[mkId] = {
        'nama_mk': mk['nama_mk'],
        'kode_mk': mk['kode_mk'],
        'total_absensi': totalAbsensi,
        'total_hadir': totalHadir,
        'persentase': totalAbsensi > 0
            ? (totalHadir / totalAbsensi * 100).toStringAsFixed(1)
            : '0.0',
      };
    }

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik per Mata Kuliah',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...mataKuliahStats.entries.map((entry) {
            final stats = entry.value;
            return _buildMataKuliahItem(
              stats['nama_mk'],
              stats['kode_mk'],
              stats['total_hadir'],
              stats['total_absensi'],
              stats['persentase'],
              isDark,
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMataKuliahItem(
    String namaMk,
    String kodeMk,
    int totalHadir,
    int totalAbsensi,
    String persentase,
    bool isDark,
  ) {
    final persentaseValue = double.tryParse(persentase) ?? 0.0;
    final color = persentaseValue >= 80
        ? const Color(0xFF10B981)
        : persentaseValue >= 60
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      namaMk,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kodeMk,
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$persentase%',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.check_circle,
                size: 16,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
              const SizedBox(width: 4),
              Text(
                '$totalHadir hadir dari $totalAbsensi pertemuan',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: persentaseValue / 100,
              backgroundColor: isDark
                  ? const Color(0xFF374151)
                  : const Color(0xFFE5E7EB),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivities(bool isDark) {
    // Get recent 5 absensi
    final recentAbsensi = _allAbsensi.take(5).toList();

    if (recentAbsensi.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktivitas Terbaru',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...recentAbsensi.map((absensi) {
            final status = absensi['status'] ?? 'unknown';
            final color = status == 'hadir'
                ? const Color(0xFF10B981)
                : status == 'izin'
                ? const Color(0xFFF59E0B)
                : const Color(0xFFEF4444);

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      status == 'hadir'
                          ? Icons.check_circle_rounded
                          : status == 'izin'
                          ? Icons.info_rounded
                          : Icons.cancel_rounded,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Absensi ${status.toUpperCase()}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          absensi['tanggal'] ?? '-',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  void _showExportDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Export Laporan',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.picture_as_pdf_rounded,
                color: Color(0xFFEF4444),
              ),
              title: Text(
                'Export ke PDF',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur export PDF akan segera hadir'),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.table_chart_rounded,
                color: Color(0xFF10B981),
              ),
              title: Text(
                'Export ke Excel',
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur export Excel akan segera hadir'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
