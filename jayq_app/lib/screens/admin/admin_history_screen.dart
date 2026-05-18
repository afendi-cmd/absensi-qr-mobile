import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class AdminHistoryScreen extends StatefulWidget {
  const AdminHistoryScreen({super.key});

  @override
  State<AdminHistoryScreen> createState() => _AdminHistoryScreenState();
}

class _AdminHistoryScreenState extends State<AdminHistoryScreen> {
  String _selectedFilter = 'Semua';

  // Dummy data - nanti bisa diganti dengan data dari API
  final List<Map<String, dynamic>> _histories = [
    {
      'id': 1,
      'action': 'Tambah Dosen',
      'description': 'Menambahkan dosen baru: Dr. Ahmad Fauzi',
      'user': 'Admin Utama',
      'timestamp': '2 jam yang lalu',
      'date': '17 Mei 2026, 14:30',
      'type': 'create',
      'icon': Icons.person_add,
    },
    {
      'id': 2,
      'action': 'Update Jadwal',
      'description': 'Mengubah jadwal Pemrograman Mobile - TI-3A',
      'user': 'Admin Utama',
      'timestamp': '3 jam yang lalu',
      'date': '17 Mei 2026, 13:15',
      'type': 'update',
      'icon': Icons.edit_calendar,
    },
    {
      'id': 3,
      'action': 'Hapus Mahasiswa',
      'description': 'Menghapus mahasiswa: John Doe (202301001)',
      'user': 'Admin Utama',
      'timestamp': '5 jam yang lalu',
      'date': '17 Mei 2026, 11:00',
      'type': 'delete',
      'icon': Icons.person_remove,
    },
    {
      'id': 4,
      'action': 'Generate QR',
      'description': 'Generate QR Code untuk Basis Data Lanjut',
      'user': 'Admin Utama',
      'timestamp': '1 hari yang lalu',
      'date': '16 Mei 2026, 10:30',
      'type': 'generate',
      'icon': Icons.qr_code,
    },
    {
      'id': 5,
      'action': 'Export Laporan',
      'description': 'Export laporan presensi bulan April 2026',
      'user': 'Admin Utama',
      'timestamp': '2 hari yang lalu',
      'date': '15 Mei 2026, 15:45',
      'type': 'export',
      'icon': Icons.download,
    },
    {
      'id': 6,
      'action': 'Tambah Mata Kuliah',
      'description': 'Menambahkan mata kuliah: Kecerdasan Buatan',
      'user': 'Admin Utama',
      'timestamp': '3 hari yang lalu',
      'date': '14 Mei 2026, 09:20',
      'type': 'create',
      'icon': Icons.library_add,
    },
    {
      'id': 7,
      'action': 'Reset Password',
      'description': 'Reset password untuk mahasiswa: Jane Smith',
      'user': 'Admin Utama',
      'timestamp': '4 hari yang lalu',
      'date': '13 Mei 2026, 14:10',
      'type': 'update',
      'icon': Icons.lock_reset,
    },
    {
      'id': 8,
      'action': 'Backup Data',
      'description': 'Backup database sistem presensi',
      'user': 'System',
      'timestamp': '5 hari yang lalu',
      'date': '12 Mei 2026, 22:00',
      'type': 'system',
      'icon': Icons.backup,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildFilterChips(isDark),
            Expanded(child: _buildHistoryList(isDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Riwayat Aktivitas',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _showFilterDialog(isDark);
            },
            icon: Icon(
              Icons.filter_list,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
            ),
          ),
          IconButton(
            onPressed: () {
              // TODO: Export history
            },
            icon: Icon(
              Icons.download,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = ['Semua', 'Hari Ini', 'Minggu Ini', 'Bulan Ini'];

    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
              selectedColor: const Color(0xFF2563EB),
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : const Color(0xFF111827)),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryList(bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _histories.length,
      itemBuilder: (context, index) {
        final history = _histories[index];
        return _buildHistoryCard(history, isDark);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> history, bool isDark) {
    Color getTypeColor(String type) {
      switch (type) {
        case 'create':
          return const Color(0xFF10B981);
        case 'update':
          return const Color(0xFF3B82F6);
        case 'delete':
          return const Color(0xFFEF4444);
        case 'generate':
          return const Color(0xFF8B5CF6);
        case 'export':
          return const Color(0xFFF59E0B);
        case 'system':
          return const Color(0xFF6B7280);
        default:
          return const Color(0xFF6B7280);
      }
    }

    Color getTypeBgColor(String type, bool isDark) {
      if (isDark) {
        switch (type) {
          case 'create':
            return const Color(0xFF065F46);
          case 'update':
            return const Color(0xFF1E3A8A);
          case 'delete':
            return const Color(0xFF991B1B);
          case 'generate':
            return const Color(0xFF5B21B6);
          case 'export':
            return const Color(0xFF92400E);
          case 'system':
            return const Color(0xFF374151);
          default:
            return const Color(0xFF374151);
        }
      } else {
        switch (type) {
          case 'create':
            return const Color(0xFFD1FAE5);
          case 'update':
            return const Color(0xFFDBEAFE);
          case 'delete':
            return const Color(0xFFFEE2E2);
          case 'generate':
            return const Color(0xFFEDE9FE);
          case 'export':
            return const Color(0xFFFEF3C7);
          case 'system':
            return const Color(0xFFF3F4F6);
          default:
            return const Color(0xFFF3F4F6);
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showHistoryDetail(history, isDark);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: getTypeBgColor(history['type'], isDark),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    history['icon'],
                    color: getTypeColor(history['type']),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        history['action'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        history['description'],
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        history['timestamp'],
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? const Color(0xFF6B7280)
                              : const Color(0xFF9CA3AF),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: isDark
                      ? const Color(0xFF6B7280)
                      : const Color(0xFF9CA3AF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHistoryDetail(Map<String, dynamic> history, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            Text(
              'Detail Aktivitas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow('Aksi', history['action'], isDark),
            _buildDetailRow('Deskripsi', history['description'], isDark),
            _buildDetailRow('User', history['user'], isDark),
            _buildDetailRow('Waktu', history['date'], isDark),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Tutup'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Filter Riwayat',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('Semua Aktivitas', isDark),
            _buildFilterOption('Tambah Data', isDark),
            _buildFilterOption('Update Data', isDark),
            _buildFilterOption('Hapus Data', isDark),
            _buildFilterOption('Generate QR', isDark),
            _buildFilterOption('Export Laporan', isDark),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Terapkan'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String label, bool isDark) {
    return CheckboxListTile(
      title: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF111827),
        ),
      ),
      value: false,
      onChanged: (value) {},
      activeColor: const Color(0xFF2563EB),
    );
  }
}
