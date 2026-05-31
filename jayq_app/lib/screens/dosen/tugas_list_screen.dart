import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/theme_provider.dart';

class TugasListScreen extends StatefulWidget {
  const TugasListScreen({super.key});

  @override
  State<TugasListScreen> createState() => _TugasListScreenState();
}

class _TugasListScreenState extends State<TugasListScreen> {
  String _filterStatus = 'all'; // all, aktif, selesai, overdue

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua', 'all', isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Aktif', 'aktif', isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Selesai', 'selesai', isDark),
                  const SizedBox(width: 8),
                  _buildFilterChip('Terlambat', 'overdue', isDark),
                ],
              ),
            ),
          ),

          // Tugas List (Placeholder)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_outlined,
                    size: 80,
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manajemen Tugas',
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
                    'Fitur ini akan segera hadir',
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Fitur Buat Tugas akan segera hadir')),
          );
        },
        backgroundColor: const Color(0xFF003d9b),
        icon: const Icon(Icons.add),
        label: const Text('Buat Tugas'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark) {
    final isSelected = _filterStatus == value;
    return InkWell(
      onTap: () => setState(() => _filterStatus = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
}
