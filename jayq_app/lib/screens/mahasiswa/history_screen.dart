import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/absensi_service.dart';
import '../../data/services/storage_service.dart';
import '../../data/services/matakuliah_service.dart';
import '../../data/models/absensi_model.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late AbsensiService _absensiService;
  late MataKuliahService _mataKuliahService;

  bool _isLoading = false;
  String _errorMessage = '';
  List<AbsensiModel> _allAbsensi = [];
  List<Map<String, dynamic>> _allMataKuliah = [];

  int? _selectedMataKuliahId;
  String? _selectedMonth;

  @override
  void initState() {
    super.initState();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    final storageService = StorageService();
    final token = await storageService.getToken();

    final dio = Dio();
    dio.options.baseUrl = 'http://10.0.2.2:8000/api';
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
      // Load mata kuliah mahasiswa for filter
      final mataKuliah = await _mataKuliahService.getMahasiswaMataKuliah();

      // Load absensi with filters
      final absensiData = await _absensiService.getRiwayatAbsensi(
        mataKuliahId: _selectedMataKuliahId,
        tanggalMulai: _selectedMonth != null ? '$_selectedMonth-01' : null,
        tanggalSelesai: _selectedMonth != null
            ? _getLastDayOfMonth(_selectedMonth!)
            : null,
      );

      final absensiList = absensiData
          .map((json) => AbsensiModel.fromJson(json))
          .toList();

      setState(() {
        _allMataKuliah = mataKuliah;
        _allAbsensi = absensiList;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  String _getLastDayOfMonth(String yearMonth) {
    final parts = yearMonth.split('-');
    final year = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final lastDay = DateTime(year, month + 1, 0).day;
    return '$yearMonth-${lastDay.toString().padLeft(2, '0')}';
  }

  void _showFilterDialog(bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Riwayat',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF1F2937),
                ),
              ),
              const SizedBox(height: 20),

              // Filter Mata Kuliah
              Text(
                'Mata Kuliah',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                value: _selectedMataKuliahId,
                dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
                decoration: InputDecoration(
                  hintText: 'Semua Mata Kuliah',
                  hintStyle: TextStyle(
                    color: isDark
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF9CA3AF),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
                items: [
                  DropdownMenuItem<int?>(
                    value: null,
                    child: Text(
                      'Semua Mata Kuliah',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  ..._allMataKuliah.map((mk) {
                    return DropdownMenuItem<int?>(
                      value: mk['id'],
                      child: Text(
                        mk['nama_mk'] ?? '',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1F2937),
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  setModalState(() {
                    _selectedMataKuliahId = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Filter Bulan
              Text(
                'Bulan',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String?>(
                value: _selectedMonth,
                dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
                decoration: InputDecoration(
                  hintText: 'Semua Bulan',
                  hintStyle: TextStyle(
                    color: isDark
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF9CA3AF),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      'Semua Bulan',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  ..._getMonthOptions().map((month) {
                    return DropdownMenuItem<String?>(
                      value: month['value'],
                      child: Text(
                        month['label']!,
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1F2937),
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  setModalState(() {
                    _selectedMonth = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        setState(() {
                          _selectedMataKuliahId = null;
                          _selectedMonth = null;
                        });
                        Navigator.pop(context);
                        _loadData();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFE5E7EB),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Reset',
                        style: TextStyle(
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF1F2937),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedMataKuliahId = _selectedMataKuliahId;
                          _selectedMonth = _selectedMonth;
                        });
                        Navigator.pop(context);
                        _loadData();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003d9b),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Terapkan',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getMonthOptions() {
    final now = DateTime.now();
    final months = <Map<String, String>>[];

    for (int i = 0; i < 6; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthNames = [
        '',
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
      months.add({
        'value': DateFormat('yyyy-MM').format(date),
        'label': '${monthNames[date.month]} ${date.year}',
      });
    }

    return months;
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
            _buildFilterChips(isDark),
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage.isNotEmpty
                  ? _buildErrorState(isDark)
                  : _allAbsensi.isEmpty
                  ? _buildEmptyState(isDark)
                  : _buildHistoryList(isDark),
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
          const Icon(Icons.history_rounded, color: Color(0xFF003d9b), size: 24),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Riwayat Absensi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF003d9b),
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.filter_list_rounded,
              color: isDark ? Colors.white : const Color(0xFF003d9b),
            ),
            onPressed: () => _showFilterDialog(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    if (_selectedMataKuliahId == null && _selectedMonth == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (_selectedMataKuliahId != null)
            _buildFilterChip(
              label:
                  _allMataKuliah.firstWhere(
                    (mk) => mk['id'] == _selectedMataKuliahId,
                    orElse: () => {'nama_mk': 'Unknown'},
                  )['nama_mk'] ??
                  'Unknown',
              onRemove: () {
                setState(() {
                  _selectedMataKuliahId = null;
                });
                _loadData();
              },
              isDark: isDark,
            ),
          if (_selectedMonth != null)
            _buildFilterChip(
              label:
                  _getMonthOptions().firstWhere(
                    (m) => m['value'] == _selectedMonth,
                    orElse: () => {'label': 'Unknown'},
                  )['label'] ??
                  'Unknown',
              onRemove: () {
                setState(() {
                  _selectedMonth = null;
                });
                _loadData();
              },
              isDark: isDark,
            ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
    required bool isDark,
  }) {
    return Chip(
      label: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFF003d9b),
          fontWeight: FontWeight.w600,
        ),
      ),
      deleteIcon: const Icon(Icons.close, size: 16, color: Color(0xFF003d9b)),
      onDeleted: onRemove,
      backgroundColor: const Color(0xFF003d9b).withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xFF003d9b)),
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
              onPressed: _loadData,
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

  Widget _buildEmptyState(bool isDark) {
    return RefreshIndicator(
      onRefresh: _loadData,
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
                  Icons.event_busy_rounded,
                  size: 80,
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada riwayat',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Riwayat absensi Anda akan muncul di sini',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryList(bool isDark) {
    // Group by date
    final groupedAbsensi = <String, List<AbsensiModel>>{};
    for (final absensi in _allAbsensi) {
      if (!groupedAbsensi.containsKey(absensi.tanggal)) {
        groupedAbsensi[absensi.tanggal] = [];
      }
      groupedAbsensi[absensi.tanggal]!.add(absensi);
    }

    final sortedDates = groupedAbsensi.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF003d9b),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedDates.length,
        itemBuilder: (context, index) {
          final date = sortedDates[index];
          final absensiList = groupedAbsensi[date]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 12, top: index == 0 ? 0 : 8),
                child: Text(
                  _formatDateHeader(date),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
              ...absensiList.map(
                (absensi) => _buildHistoryCard(absensi, isDark),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatDateHeader(String date) {
    try {
      final dateTime = DateTime.parse(date);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final targetDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

      if (targetDate == today) {
        return 'Hari Ini';
      } else if (targetDate == yesterday) {
        return 'Kemarin';
      } else {
        final months = [
          '',
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
        return '${dateTime.day} ${months[dateTime.month]} ${dateTime.year}';
      }
    } catch (e) {
      return date;
    }
  }

  Widget _buildHistoryCard(AbsensiModel absensi, bool isDark) {
    final statusColor = _getStatusColor(absensi.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status Icon
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getStatusIcon(absensi.status),
                color: statusColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    absensi.mataKuliah?.namaMk ?? 'Unknown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    absensi.mataKuliah?.kodeMk ?? '',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 14,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        absensi.formattedTime,
                        style: TextStyle(
                          fontSize: 12,
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

            // Status Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                absensi.statusLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return const Color(0xFF10B981);
      case 'izin':
        return const Color(0xFFF59E0B);
      case 'sakit':
        return const Color(0xFF3B82F6);
      case 'alpha':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'hadir':
        return Icons.check_circle_rounded;
      case 'izin':
        return Icons.info_rounded;
      case 'sakit':
        return Icons.local_hospital_rounded;
      case 'alpha':
        return Icons.cancel_rounded;
      default:
        return Icons.help_rounded;
    }
  }
}
