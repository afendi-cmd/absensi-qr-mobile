import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/dashboard_provider.dart';
import 'manage_dosen_screen.dart';
import 'manage_mahasiswa_screen.dart';
import 'manage_matakuliah_screen.dart';
import 'manage_peserta_screen.dart';
import 'statistics_screen.dart';
import 'admin_profile_screen.dart';
import 'admin_schedule_screen.dart';
import 'admin_history_screen.dart';
import 'advanced_statistics_screen.dart';
import 'broadcast_pengumuman_screen.dart';
import 'notification_center_screen.dart';
import 'audit_log_screen.dart';
import '../../data/services/pengumuman_service.dart';
import '../../data/services/storage_service.dart';
import 'package:dio/dio.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;
  int _notificationCount = 0;
  late PengumumanService _pengumumanService;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    // Load data saat screen pertama kali dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = Provider.of<DashboardProvider>(
        context,
        listen: false,
      );
      dashboardProvider.loadAdminStats();
      dashboardProvider.loadAllUsers();
      dashboardProvider.loadAllMataKuliah();
    });
  }

  Future<void> _initializeServices() async {
    final storageService = StorageService();
    final token = await storageService.getToken();

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Accept'] = 'application/json';

    _pengumumanService = PengumumanService();
    _loadNotificationCount();
  }

  Future<void> _loadNotificationCount() async {
    try {
      final data = await _pengumumanService.getUnreadCount();
      setState(() {
        _notificationCount = data['unread_count'] ?? 0;
      });
    } catch (e) {
      // Silently fail
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // List of screens for bottom navigation
    final List<Widget> screens = [
      _buildDashboardContent(isDark),
      const AdminScheduleScreen(),
      const AdminHistoryScreen(),
      const AdminProfileScreen(),
    ];

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF5F5F5),
      body: screens[_selectedIndex],
      bottomNavigationBar: _buildBottomNav(isDark),
    );
  }

  Widget _buildDashboardContent(bool isDark) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(isDark),
              const SizedBox(height: 20),
              _buildStatisticsCards(isDark),
              const SizedBox(height: 20),
              _buildAksiCepat(isDark),
              const SizedBox(height: 20),
              _buildTrenPresensi(isDark),
              const SizedBox(height: 16),
              _buildPengumumanSistem(isDark),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? const Color(0xFF374151) : Colors.grey[400],
          ),
          child: Icon(
            Icons.person,
            color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[700],
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Admin Panel',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF1E3A8A),
            ),
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            border: Border.all(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.notifications_outlined,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                    size: 20,
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NotificationCenterScreen(),
                      ),
                    );
                    // Reload notification count after returning
                    _loadNotificationCount();
                  },
                ),
              ),
              if (_notificationCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _notificationCount > 9 ? '9+' : '$_notificationCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCards(bool isDark) {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, child) {
        final stats = dashboardProvider.adminStats;
        final isLoading = dashboardProvider.isLoadingAdminStats;

        return Column(
          children: [
            Container(
              width: double.infinity,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'MATA KULIAH AKTIF',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : Colors.grey[600],
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      isLoading
                          ? const CircularProgressIndicator()
                          : Text(
                              '${stats?.totalMataKuliah ?? 0}',
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? const Color(0xFF60A5FA)
                                    : const Color(0xFF1E3A8A),
                              ),
                            ),
                    ],
                  ),
                  Container(
                    width: 56,
                    height: 56,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.menu_book,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2937) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF312E81)
                                : const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.school_outlined,
                            color: isDark
                                ? const Color(0xFF818CF8)
                                : const Color(0xFF4F46E5),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Total Dosen',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        isLoading
                            ? const SizedBox(
                                height: 24,
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                '${stats?.totalDosen ?? 0}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2937) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF312E81)
                                : const Color(0xFFE0E7FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.groups_outlined,
                            color: isDark
                                ? const Color(0xFF818CF8)
                                : const Color(0xFF4F46E5),
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Total Mahasiswa',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        isLoading
                            ? const SizedBox(
                                height: 24,
                                child: CircularProgressIndicator(),
                              )
                            : Text(
                                '${stats?.totalMahasiswa ?? 0}',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF111827),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildTrenPresensi(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tren Presensi Hari Ini',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 16),
        Container(
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
            children: [
              _buildClassItem(
                title: 'Teknik Informatika - A',
                subtitle: '08:00 - Selesai • 42 Mahasiswa',
                status: 'Selesai',
                statusColor: const Color(0xFF10B981),
                statusBgColor: isDark
                    ? const Color(0xFF064E3B)
                    : const Color(0xFFD1FAE5),
                borderColor: const Color(0xFF2563EB),
                isDark: isDark,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFF3F4F6),
              ),
              _buildClassItem(
                title: 'Sistem Informasi - B',
                subtitle: '10:30 - Berlangsung • 38 Mahasiswa',
                status: 'Berjalan',
                statusColor: const Color(0xFF2563EB),
                statusBgColor: isDark
                    ? const Color(0xFF1E3A8A)
                    : const Color(0xFFDBEAFE),
                borderColor: const Color(0xFF2563EB),
                isDark: isDark,
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFF3F4F6),
              ),
              _buildClassItem(
                title: 'Manajemen Bisnis - C',
                subtitle: '13:00 - Mendatang • 45 Mahasiswa',
                status: 'Terjadwal',
                statusColor: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
                statusBgColor: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFF3F4F6),
                borderColor: isDark
                    ? const Color(0xFF4B5563)
                    : const Color(0xFFD1D5DB),
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClassItem({
    required String title,
    required String subtitle,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
    required Color borderColor,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAksiCepat(bool isDark) {
    // Daftar semua aksi cepat
    final List<Map<String, dynamic>> allActions = [
      {
        'icon': Icons.person_add_alt,
        'label': 'Kelola Dosen',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ManageDosenScreen()),
        ),
      },
      {
        'icon': Icons.group_add,
        'label': 'Kelola Mhs',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ManageMahasiswaScreen(),
          ),
        ),
      },
      {
        'icon': Icons.library_books,
        'label': 'Mata Kuliah',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ManageMataKuliahScreen(),
          ),
        ),
      },
      {
        'icon': Icons.groups,
        'label': 'Kelola Peserta',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ManagePesertaScreen()),
        ),
      },
      {
        'icon': Icons.campaign,
        'label': 'Pengumuman',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BroadcastPengumumanScreen(),
          ),
        ),
      },
      {
        'icon': Icons.download,
        'label': 'Export Data',
        'onTap': () => Navigator.pushNamed(context, '/admin/export'),
      },
      {
        'icon': Icons.assessment,
        'label': 'Laporan',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const StatisticsScreen()),
        ),
      },
      {
        'icon': Icons.bar_chart,
        'label': 'Statistik',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AdvancedStatisticsScreen(),
          ),
        ),
      },
      {
        'icon': Icons.history,
        'label': 'Audit Log',
        'onTap': () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AuditLogScreen()),
        ),
      },
    ];

    // Tampilkan maksimal 9 item (grid 4 kolom)
    final displayedActions = allActions.take(9).toList();
    final hasMore = allActions.length > 9;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Aksi Cepat',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            if (hasMore)
              TextButton(
                onPressed: () {
                  // TODO: Navigate to all actions screen
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur Lihat Lainnya akan segera hadir'),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      'Lihat Lainnya',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? const Color(0xFF60A5FA)
                            : const Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: isDark
                          ? const Color(0xFF60A5FA)
                          : const Color(0xFF2563EB),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        // Grid 4 kolom x 2 baris
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.95,
          ),
          itemCount: displayedActions.length,
          itemBuilder: (context, index) {
            final action = displayedActions[index];
            return _buildAksiCepatButton(
              icon: action['icon'],
              label: action['label'],
              isDark: isDark,
              onTap: action['onTap'],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAksiCepatButton({
    required IconData icon,
    required String label,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFF1E40AF),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color:
                      (isDark
                              ? const Color(0xFF1E3A8A)
                              : const Color(0xFF1E40AF))
                          .withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 25),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF111827),
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengumumanSistem(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFF1E40AF),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF1E3A8A) : const Color(0xFF1E40AF))
                .withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengumuman Sistem',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Pemeliharaan server dijadwalkan pada hari Sabtu pukul 22:00 WIB. Harap simpan semua data presensi sebelum waktu tersebut.',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNavItem(
                icon: Icons.home,
                label: 'Beranda',
                isActive: _selectedIndex == 0,
                isDark: isDark,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _buildNavItem(
                icon: Icons.calendar_today,
                label: 'Jadwal',
                isActive: _selectedIndex == 1,
                isDark: isDark,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _buildNavItem(
                icon: Icons.history,
                label: 'Riwayat',
                isActive: _selectedIndex == 2,
                isDark: isDark,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
              _buildNavItem(
                icon: Icons.person,
                label: 'Profil',
                isActive: _selectedIndex == 3,
                isDark: isDark,
                onTap: () => setState(() => _selectedIndex = 3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF2563EB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: isActive
                      ? Colors.white
                      : (isDark
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF9CA3AF)),
                  size: 24,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? const Color(0xFF2563EB)
                      : (isDark
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF9CA3AF)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
