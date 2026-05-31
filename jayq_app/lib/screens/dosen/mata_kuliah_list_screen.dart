import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/dashboard_dosen_provider.dart';
import 'mata_kuliah_detail_screen.dart';

class MataKuliahListScreen extends StatefulWidget {
  const MataKuliahListScreen({super.key});

  @override
  State<MataKuliahListScreen> createState() => _MataKuliahListScreenState();
}

class _MataKuliahListScreenState extends State<MataKuliahListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final provider = Provider.of<DashboardDosenProvider>(
      context,
      listen: false,
    );
    await provider.loadMataKuliah();
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
        title: const Text('Mata Kuliah'),
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
        elevation: 0,
      ),
      body: Consumer<DashboardDosenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingMataKuliah) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.mataKuliahList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book_outlined,
                    size: 80,
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada mata kuliah',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _loadData,
            color: const Color(0xFF003d9b),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: provider.mataKuliahList.length,
              itemBuilder: (context, index) {
                final mk = provider.mataKuliahList[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildMataKuliahCard(mk, isDark),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildMataKuliahCard(Map<String, dynamic> mk, bool isDark) {
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

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MataKuliahDetailScreen(mataKuliah: mk),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
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
                const Spacer(),
                Icon(
                  Icons.chevron_right,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              mk['nama_mk'] ?? '-',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF191c1e),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
                const SizedBox(width: 6),
                Text(
                  '${mk['hari'] ?? '-'}, ${mk['jam_mulai'] ?? '-'} - ${mk['jam_selesai'] ?? '-'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.people,
                  size: 14,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
                const SizedBox(width: 6),
                Text(
                  '$totalMahasiswa mahasiswa',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.check_circle,
                  size: 14,
                  color: avgAttendance >= 75
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                ),
                const SizedBox(width: 6),
                Text(
                  '${avgAttendance.toStringAsFixed(1)}% kehadiran',
                  style: TextStyle(
                    fontSize: 12,
                    color: avgAttendance >= 75
                        ? const Color(0xFF10B981)
                        : const Color(0xFFF59E0B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
