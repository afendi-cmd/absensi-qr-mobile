import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

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
    _tabController = TabController(length: 2, vsync: this);
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
          tabs: const [
            Tab(text: 'Informasi'),
            Tab(text: 'Mahasiswa'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildInfoTab(isDark), _buildMahasiswaTab(isDark)],
      ),
    );
  }

  Widget _buildInfoTab(bool isDark) {
    final mk = widget.mataKuliah;
    final peserta = mk['peserta'] as List? ?? [];
    final totalMahasiswa = peserta.length;

    // Calculate average attendance
    double avgAttendance = 0;
    if (peserta.isNotEmpty) {
      final total = peserta.fold<double>(
        0,
        (sum, m) => sum + ((m['persentase_kehadiran'] ?? 0) as num).toDouble(),
      );
      avgAttendance = total / peserta.length;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Container(
            padding: const EdgeInsets.all(20),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    mk['kode_mk'] ?? '-',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003d9b),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  mk['nama_mk'] ?? '-',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInfoRow(
                  icon: Icons.school,
                  label: 'SKS',
                  value: '${mk['sks'] ?? '-'}',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  label: 'Jadwal',
                  value:
                      '${mk['hari'] ?? '-'}, ${mk['jam_mulai'] ?? '-'} - ${mk['jam_selesai'] ?? '-'}',
                  isDark: isDark,
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  icon: Icons.room,
                  label: 'Ruangan',
                  value: mk['ruangan'] ?? '-',
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Statistics
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  icon: Icons.people,
                  label: 'Total Mahasiswa',
                  value: '$totalMahasiswa',
                  color: const Color(0xFF003d9b),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  icon: Icons.check_circle,
                  label: 'Rata-rata Kehadiran',
                  value: '${avgAttendance.toStringAsFixed(1)}%',
                  color: avgAttendance >= 75
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
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
                  fontSize: 14,
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

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : const Color(0xFF191c1e),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
          ),
        ],
      ),
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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: const Color(0xFF003d9b).withValues(alpha: 0.1),
            child: Text(
              (mahasiswa['nama'] ?? 'M')
                  .toString()
                  .substring(0, 1)
                  .toUpperCase(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF003d9b),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mahasiswa['nama'] ?? '-',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  mahasiswa['nim'] ?? '-',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isAman
                  ? const Color(0xFF10B981).withValues(alpha: 0.1)
                  : Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${persentase.toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isAman ? const Color(0xFF10B981) : Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
