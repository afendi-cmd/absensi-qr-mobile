import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/dashboard_dosen_provider.dart';

class MateriListScreen extends StatefulWidget {
  const MateriListScreen({super.key});

  @override
  State<MateriListScreen> createState() => _MateriListScreenState();
}

class _MateriListScreenState extends State<MateriListScreen> {
  int? _selectedMataKuliahId;

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Manajemen Materi'),
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter by Mata Kuliah
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            child: Consumer<DashboardDosenProvider>(
              builder: (context, provider, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF111827)
                        : const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFe1e2e4),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: _selectedMataKuliahId,
                      hint: Text(
                        'Filter by Mata Kuliah',
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF737685),
                        ),
                      ),
                      dropdownColor: isDark
                          ? const Color(0xFF1F2937)
                          : Colors.white,
                      items: [
                        DropdownMenuItem<int>(
                          value: null,
                          child: Text(
                            'Semua Mata Kuliah',
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF191c1e),
                            ),
                          ),
                        ),
                        ...provider.mataKuliahList.map((mk) {
                          return DropdownMenuItem<int>(
                            value: mk['id'],
                            child: Text(
                              '${mk['kode_mk']} - ${mk['nama_mk']}',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF191c1e),
                              ),
                            ),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedMataKuliahId = value);
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Materi List (Placeholder)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.folder_outlined,
                    size: 80,
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada materi',
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
                    'Upload materi untuk mahasiswa',
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
          _showUploadMateriDialog(context, isDark);
        },
        backgroundColor: const Color(0xFF003d9b),
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Materi'),
      ),
    );
  }

  void _showUploadMateriDialog(BuildContext context, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Upload Materi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: Text(
          'Fitur Upload Materi akan segera hadir',
          style: TextStyle(
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
