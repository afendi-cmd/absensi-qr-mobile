import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'create_tugas_screen.dart';
import 'create_materi_screen.dart';

class MataKuliahDetailScreen extends StatefulWidget {
  final Map<String, dynamic> mataKuliah;

  const MataKuliahDetailScreen({super.key, required this.mataKuliah});

  @override
  State<MataKuliahDetailScreen> createState() => _MataKuliahDetailScreenState();
}

class _MataKuliahDetailScreenState extends State<MataKuliahDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _filterStatus = 'all'; // all, aman, bahaya

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredMahasiswa {
    final peserta = widget.mataKuliah['peserta'] as List? ?? [];
    var filtered = peserta.cast<Map<String, dynamic>>();

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((m) {
        final nama = (m['nama'] ?? '').toString().toLowerCase();
        final nim = (m['nim'] ?? '').toString().toLowerCase();
        final query = _searchQuery.toLowerCase();
        return nama.contains(query) || nim.contains(query);
      }).toList();
    }

    // Filter by status
    if (_filterStatus != 'all') {
      filtered = filtered.where((m) {
        final persentase = (m['persentase_kehadiran'] ?? 0) as num;
        if (_filterStatus == 'aman') {
          return persentase >= 75;
        } else {
          return persentase < 75;
        }
      }).toList();
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Detail Mata Kuliah'),
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF003d9b),
          unselectedLabelColor: isDark
              ? const Color(0xFF9CA3AF)
              : const Color(0xFF737685),
          indicatorColor: const Color(0xFF003d9b),
          isScrollable: true,
          tabs: const [
            Tab(text: 'Informasi'),
            Tab(text: 'Mahasiswa'),
            Tab(text: 'Tugas'),
            Tab(text: 'Materi'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildInfoTab(isDark),
          _buildMahasiswaTab(isDark),
          _buildTugasTab(isDark),
          _buildMateriTab(isDark),
        ],
      ),
    );
  }

  Widget _buildInfoTab(bool isDark) {
    final mk = widget.mataKuliah;
    final peserta = mk['peserta'] as List? ?? [];
    final totalMahasiswa = peserta.length;

    // Calculate statistics
    double avgAttendance = 0;
    int totalAman = 0;
    int totalBahaya = 0;

    if (peserta.isNotEmpty) {
      final total = peserta.fold<double>(
        0,
        (sum, m) => sum + ((m['persentase_kehadiran'] ?? 0) as num).toDouble(),
      );
      avgAttendance = total / peserta.length;

      for (var m in peserta) {
        final persentase = (m['persentase_kehadiran'] ?? 0) as num;
        if (persentase >= 75) {
          totalAman++;
        } else {
          totalBahaya++;
        }
      }
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero Header with Gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF003d9b), Color(0xFF0052cc)],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF003d9b).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.bookmark, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        mk['kode_mk'] ?? '-',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Text(
                  mk['nama_mk'] ?? '-',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 20),

                // Quick Stats Row
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickStat(
                        icon: Icons.groups,
                        value: '$totalMahasiswa',
                        label: 'Mahasiswa',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: _buildQuickStat(
                        icon: Icons.school,
                        value: '${mk['sks'] ?? '-'}',
                        label: 'SKS',
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    Expanded(
                      child: _buildQuickStat(
                        icon: Icons.trending_up,
                        value: '${avgAttendance.toStringAsFixed(0)}%',
                        label: 'Kehadiran',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Schedule Info Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFe1e2e4),
                ),
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
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.schedule,
                          color: Color(0xFF003d9b),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Jadwal Perkuliahan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF191c1e),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildScheduleInfoRow(
                    icon: Icons.calendar_today,
                    label: 'Hari',
                    value: mk['hari'] ?? '-',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildScheduleInfoRow(
                    icon: Icons.access_time,
                    label: 'Waktu',
                    value:
                        '${mk['jam_mulai']?.substring(0, 5) ?? '-'} - ${mk['jam_selesai']?.substring(0, 5) ?? '-'}',
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _buildScheduleInfoRow(
                    icon: Icons.meeting_room,
                    label: 'Ruangan',
                    value: mk['ruangan'] ?? '-',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Attendance Distribution
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Distribusi Kehadiran Mahasiswa',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1F2937) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFe1e2e4),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.2 : 0.04,
                        ),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Visual Progress Bar
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: isDark
                              ? const Color(0xFF111827)
                              : const Color(0xFFF8F9FB),
                        ),
                        child: totalMahasiswa > 0
                            ? Row(
                                children: [
                                  if (totalAman > 0)
                                    Expanded(
                                      flex: totalAman,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF10B981),
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                            topRight: Radius.circular(
                                              12,
                                            ), // Will be overridden if there's bahaya
                                            bottomRight: Radius.circular(12),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$totalAman',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (totalBahaya > 0)
                                    Expanded(
                                      flex: totalBahaya,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEF4444),
                                          borderRadius: totalAman > 0
                                              ? const BorderRadius.only(
                                                  topRight: Radius.circular(12),
                                                  bottomRight: Radius.circular(
                                                    12,
                                                  ),
                                                )
                                              : BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$totalBahaya',
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'Tidak ada data',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isDark
                                        ? const Color(0xFF9CA3AF)
                                        : const Color(0xFF737685),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),

                      // Legend
                      Row(
                        children: [
                          Expanded(
                            child: _buildLegendItem(
                              color: const Color(0xFF10B981),
                              label: 'Aman (≥75%)',
                              count: totalAman,
                              percentage: totalMahasiswa > 0
                                  ? (totalAman / totalMahasiswa * 100)
                                        .toStringAsFixed(0)
                                  : '0',
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildLegendItem(
                              color: const Color(0xFFEF4444),
                              label: 'Bahaya (<75%)',
                              count: totalBahaya,
                              percentage: totalMahasiswa > 0
                                  ? (totalBahaya / totalMahasiswa * 100)
                                        .toStringAsFixed(0)
                                  : '0',
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Average Attendance Card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: avgAttendance >= 75
                      ? [
                          const Color(0xFF10B981).withValues(alpha: 0.1),
                          const Color(0xFF10B981).withValues(alpha: 0.05),
                        ]
                      : [
                          const Color(0xFFF59E0B).withValues(alpha: 0.1),
                          const Color(0xFFF59E0B).withValues(alpha: 0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: avgAttendance >= 75
                      ? const Color(0xFF10B981).withValues(alpha: 0.3)
                      : const Color(0xFFF59E0B).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: avgAttendance >= 75
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.analytics,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rata-rata Kehadiran Kelas',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF737685),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              avgAttendance.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: avgAttendance >= 75
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFF59E0B),
                                height: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 4,
                                left: 4,
                              ),
                              child: Text(
                                '%',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: avgAttendance >= 75
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFF59E0B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    avgAttendance >= 75
                        ? Icons.thumb_up
                        : Icons.warning_amber_rounded,
                    color: avgAttendance >= 75
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                    size: 32,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildQuickStat({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildScheduleInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FB),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: const Color(0xFF003d9b)),
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
                      : const Color(0xFF737685),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required int count,
    required String percentage,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          '$count Mahasiswa',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        Text(
          '$percentage%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildMahasiswaTab(bool isDark) {
    final filtered = _filteredMahasiswa;

    return Column(
      children: [
        // Search & Filter
        Container(
          padding: const EdgeInsets.all(16),
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          child: Column(
            children: [
              // Search Bar
              TextField(
                onChanged: (value) => setState(() => _searchQuery = value),
                decoration: InputDecoration(
                  hintText: 'Cari nama atau NIM...',
                  hintStyle: TextStyle(
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF111827)
                      : const Color(0xFFF8F9FB),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: TextStyle(
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
              const SizedBox(height: 12),

              // Filter Chips
              Row(
                children: [
                  _buildFilterChip('Semua', 'all', isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Aman (≥75%)', 'aman', isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Bahaya (<75%)', 'bahaya', isDark),
                ],
              ),
            ],
          ),
        ),

        // Mahasiswa List
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.people_outline,
                        size: 64,
                        color: isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFE5E7EB),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tidak ada mahasiswa',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF737685),
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final mahasiswa = filtered[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMahasiswaCard(mahasiswa, isDark),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark) {
    final isSelected = _filterStatus == value;
    return InkWell(
      onTap: () => setState(() => _filterStatus = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF003d9b)
              : (isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FB)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF003d9b)
                : (isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685)),
          ),
        ),
      ),
    );
  }

  Widget _buildMahasiswaCard(Map<String, dynamic> mahasiswa, bool isDark) {
    final persentase = (mahasiswa['persentase_kehadiran'] ?? 0) as num;
    final isAman = persentase >= 75;
    final nama = mahasiswa['nama'] ?? '-';
    final nim = mahasiswa['nim'] ?? '-';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isAman
                        ? [const Color(0xFF10B981), const Color(0xFF059669)]
                        : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isAman
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444))
                              .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    nama.substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF191c1e),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.badge_outlined,
                          size: 14,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF737685),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          nim,
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF737685),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isAman
                      ? const Color(0xFF10B981).withValues(alpha: 0.1)
                      : const Color(0xFFEF4444).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isAman
                        ? const Color(0xFF10B981).withValues(alpha: 0.3)
                        : const Color(0xFFEF4444).withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isAman ? Icons.check_circle : Icons.warning_amber_rounded,
                      size: 16,
                      color: isAman
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${persentase.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isAman
                            ? const Color(0xFF10B981)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Progress Bar
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tingkat Kehadiran',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  ),
                  Text(
                    isAman ? 'Aman' : 'Perlu Perhatian',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isAman
                          ? const Color(0xFF10B981)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: persentase / 100,
                  minHeight: 8,
                  backgroundColor: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isAman ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTugasTab(bool isDark) {
    return Column(
      children: [
        // Header with Add Button
        Container(
          padding: const EdgeInsets.all(16),
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Daftar Tugas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateTugasScreen(
                        mataKuliahId: widget.mataKuliah['id'],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003d9b),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Tugas List - Placeholder
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  size: 64,
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada tugas',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Klik "Tambah" untuk membuat tugas baru',
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
      ],
    );
  }

  Widget _buildMateriTab(bool isDark) {
    return Column(
      children: [
        // Header with Add Button
        Container(
          padding: const EdgeInsets.all(16),
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Daftar Materi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateMateriScreen(
                        mataKuliahId: widget.mataKuliah['id'],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Tambah'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003d9b),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Materi List - Placeholder
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.folder_outlined,
                  size: 64,
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 16),
                Text(
                  'Belum ada materi',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Klik "Tambah" untuk upload materi pembelajaran',
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
      ],
    );
  }
}
