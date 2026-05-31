import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../providers/theme_provider.dart';
import '../../providers/dashboard_dosen_provider.dart';

class RekapKehadiranScreen extends StatefulWidget {
  const RekapKehadiranScreen({super.key});

  @override
  State<RekapKehadiranScreen> createState() => _RekapKehadiranScreenState();
}

class _RekapKehadiranScreenState extends State<RekapKehadiranScreen> {
  int? _selectedMataKuliahId;
  String _selectedPeriode = 'semester'; // minggu, bulan, semester, custom

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Rekap Kehadiran'),
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mata Kuliah Selector
            Text(
              'Pilih Mata Kuliah',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF191c1e),
              ),
            ),
            const SizedBox(height: 12),
            _buildMataKuliahDropdown(isDark),
            const SizedBox(height: 24),

            // Periode Selector
            Text(
              'Periode',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF191c1e),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildPeriodeChip('Minggu Ini', 'minggu', isDark),
                _buildPeriodeChip('Bulan Ini', 'bulan', isDark),
                _buildPeriodeChip('Semester Ini', 'semester', isDark),
              ],
            ),
            const SizedBox(height: 24),

            // Summary Stats
            if (_selectedMataKuliahId != null) ...[
              _buildSummaryStats(isDark),
              const SizedBox(height: 24),

              // Chart
              Text(
                'Grafik Kehadiran',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
              const SizedBox(height: 12),
              _buildChart(isDark),
              const SizedBox(height: 24),

              // Export Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Fitur Export akan segera hadir'),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.download),
                  label: const Text(
                    'Export ke Excel',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ] else
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Text(
                    'Pilih mata kuliah untuk melihat rekap',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMataKuliahDropdown(bool isDark) {
    return Consumer<DashboardDosenProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: _selectedMataKuliahId,
              hint: Text(
                'Pilih mata kuliah',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
              dropdownColor: isDark ? const Color(0xFF1F2937) : Colors.white,
              items: provider.mataKuliahList.map((mk) {
                return DropdownMenuItem<int>(
                  value: mk['id'],
                  child: Text(
                    '${mk['kode_mk']} - ${mk['nama_mk']}',
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF191c1e),
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedMataKuliahId = value);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodeChip(String label, String value, bool isDark) {
    final isSelected = _selectedPeriode == value;
    return InkWell(
      onTap: () => setState(() => _selectedPeriode = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF003d9b)
              : (isDark ? const Color(0xFF1F2937) : Colors.white),
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685)),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryStats(bool isDark) {
    return Container(
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
          Text(
            'Ringkasan',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF191c1e),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Pertemuan',
                  '12',
                  Icons.calendar_today,
                  const Color(0xFF003d9b),
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Rata-rata Hadir',
                  '85%',
                  Icons.check_circle,
                  const Color(0xFF10B981),
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(bool isDark) {
    return Container(
      height: 250,
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
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100,
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Text(
                    'P${value.toInt() + 1}',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}%',
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 25,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFE5E7EB),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(8, (index) {
            final value = 70 + (index * 3.0);
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: value,
                  color: value >= 75
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  width: 16,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
