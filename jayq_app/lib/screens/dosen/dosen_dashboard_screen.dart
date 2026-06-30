import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_dosen_provider.dart';
import '../../providers/theme_provider.dart';
import 'profile_screen.dart';
import 'generate_qr_screen.dart';
import 'mata_kuliah_detail_screen.dart';
import 'rekap_kehadiran_screen.dart';
import 'pengumuman_dosen_screen.dart';
import 'nilai_dosen_screen.dart';
import 'izin_sakit_dosen_screen.dart';

class DosenDashboardScreen extends StatefulWidget {
  const DosenDashboardScreen({super.key});

  @override
  State<DosenDashboardScreen> createState() => _DosenDashboardScreenState();
}

class _DosenDashboardScreenState extends State<DosenDashboardScreen> {
  int _selectedIndex = 0;
  String _selectedScheduleDay = 'Semua Hari';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardDosenProvider>(
      context,
      listen: false,
    );

    if (authProvider.user != null) {
      await dashboardProvider.refreshAll(authProvider.user!.id);
    }
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
        child: _selectedIndex == 0
            ? _buildHomeContent()
            : _selectedIndex == 1
            ? _buildJadwalContent()
            : _selectedIndex == 2
            ? _buildRiwayatContent()
            : _buildProfileContent(),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const GenerateQrScreen(),
                  ),
                ).then((_) => _loadData());
              },
              backgroundColor: const Color(0xFF003d9b),
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildHomeContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF003d9b),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? const Color(0xFF1F2937) : Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(0xFF003d9b),
                    child: Text(
                      user?.name.substring(0, 1).toUpperCase() ?? 'D',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Presensi Kampus',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF191c1e),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PengumumanDosenScreen(),
                        ),
                      );
                    },
                    color: const Color(0xFF003d9b),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting Card
                  _buildGreetingCard(user),
                  const SizedBox(height: 16),

                  // Statistics Cards
                  _buildStatisticsCards(),
                  const SizedBox(height: 16),

                  // Generate QR Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GenerateQrScreen(),
                          ),
                        ).then((_) => _loadData());
                      },
                      icon: const Icon(Icons.qr_code, size: 20),
                      label: const Text(
                        'Generate QR Absensi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003d9b),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Jadwal Mengajar Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Jadwal Mengajar Hari Ini',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF191c1e),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() => _selectedIndex = 1);
                        },
                        child: const Text(
                          'Lihat Semua',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF003d9b),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Mata Kuliah List (Today Only)
                  _buildTodayMataKuliahList(),
                  const SizedBox(height: 24),

                  // Aksi Cepat Header
                  Text(
                    'Aksi Cepat',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : const Color(0xFF191c1e),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick Actions
                  _buildQuickActionsGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingCard(user) {
    return Consumer<DashboardDosenProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF003d9b), Color(0xFF0052cc)],
            ),
            borderRadius: BorderRadius.circular(12),
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
              const Text(
                'Selamat Pagi,',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              const SizedBox(height: 4),
              Text(
                'Halo, ${user?.name ?? 'Dosen'}!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Anda memiliki ${provider.mataKuliahList.where((mk) => (mk['hari'] ?? '').toString().toLowerCase() == ['senin', 'selasa', 'rabu', 'kamis', 'jumat', 'sabtu', 'minggu'][DateTime.now().weekday - 1]).length} kelas untuk diajar hari ini. Tetap semangat menginspirasi!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildQuickActionsGrid() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Row(
      children: [
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.upload_file,
            label: 'Upload\nMateri',
            onTap: () {
              setState(() => _selectedIndex = 1);
            },
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.edit_document,
            label: 'Input Nilai',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NilaiDosenScreen(),
                ),
              );
            },
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickActionCard(
            icon: Icons.event_busy_outlined,
            label: 'Izin /\nSakit',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const IzinSakitDosenScreen(),
                ),
              );
            },
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF003d9b), size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF191c1e),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayMataKuliahList() {
    return Consumer<DashboardDosenProvider>(
      builder: (context, provider, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDark = themeProvider.isDarkMode;

        if (provider.isLoadingMataKuliah) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final now = DateTime.now();
        final todayName = [
          'senin',
          'selasa',
          'rabu',
          'kamis',
          'jumat',
          'sabtu',
          'minggu',
        ][now.weekday - 1];

        final todayClasses = provider.mataKuliahList
            .where(
              (mk) => (mk['hari'] ?? '').toString().toLowerCase() == todayName,
            )
            .toList();

        if (todayClasses.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1F2937) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFe1e2e4),
              ),
            ),
            child: Center(
              child: Text(
                'Tidak ada kelas hari ini',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
            ),
          );
        }

        return Column(
          children: todayClasses.map((mk) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildMataKuliahCard(mk, isDark, true),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildMataKuliahCard(
    Map<String, dynamic> mk,
    bool isDark, [
    bool? forceIsToday,
  ]) {
    final now = DateTime.now();
    final isToday =
        forceIsToday ??
        ((mk['hari'] ?? '').toString().toLowerCase() ==
            [
              'senin',
              'selasa',
              'rabu',
              'kamis',
              'jumat',
              'sabtu',
              'minggu',
            ][now.weekday - 1]);
    final statusText = isToday ? 'Berlangsung' : 'Mendatang';
    final statusColor = isToday
        ? const Color(0xFF10B981)
        : const Color(0xFFF59E0B);
    final statusBgColor = isToday
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFFEF3C7);

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
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title and Status Badge
          Row(
            children: [
              Expanded(
                child: Text(
                  mk['nama_mk'] ?? '-',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Location
          Row(
            children: [
              Icon(
                Icons.meeting_room,
                size: 16,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF737685),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  mk['ruangan'] ?? '-',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Schedule and Attendance Info
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waktu Perkuliahan',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF737685),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${mk['hari'] ?? '-'}, ${mk['jam_mulai']?.substring(0, 5) ?? '-'} - ${mk['jam_selesai']?.substring(0, 5) ?? '-'}',
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
          ),
          const SizedBox(height: 12),

          // Attendance Statistics
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFe1e2e4),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.groups,
                            size: 16,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF737685),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Peserta Terdaftar',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF737685),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${mk['peserta']?.length ?? 0} Mahasiswa',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF191c1e),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 16,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF737685),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Kehadiran Hari Ini',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF737685),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${mk['jumlah_hadir_hari_ini'] ?? 0}/${mk['peserta']?.length ?? 0} Hadir',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              (mk['jumlah_hadir_hari_ini'] ?? 0) >=
                                  (mk['peserta']?.length ?? 0) / 2
                              ? const Color(0xFF10B981)
                              : const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GenerateQrScreen(),
                      ),
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('Kelola Presensi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003d9b),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MataKuliahDetailScreen(mataKuliah: mk),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Detail'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF003d9b),
                    side: const BorderSide(color: Color(0xFF003d9b)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards() {
    return Consumer<DashboardDosenProvider>(
      builder: (context, provider, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDark = themeProvider.isDarkMode;

        if (provider.isLoadingStats) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Row(
          children: [
            // Total Mata Kuliah
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFe1e2e4),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu_book,
                        color: Color(0xFF003d9b),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${provider.mataKuliahList.length}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF003d9b),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Mata Kuliah',
                      textAlign: TextAlign.center,
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
            ),
            const SizedBox(width: 12),
            // Rata-rata Kehadiran
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFe1e2e4),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.bar_chart,
                        color: Color(0xFF003d9b),
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${provider.mataKuliahList.fold<Set<int>>({}, (set, mk) {
                        final peserta = mk['peserta'] as List? ?? [];
                        for (var p in peserta) {
                          if (p['id'] != null) set.add(p['id'] as int);
                        }
                        return set;
                      }).length}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF003d9b),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Total Mahasiswa',
                      textAlign: TextAlign.center,
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildJadwalContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Daftar Kelas Anda',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Cards
              _buildStatisticsCards(),
              const SizedBox(height: 16),

              // Day Filter
              _buildDayFilterSimple(isDark),
            ],
          ),
        ),

        // Schedule List
        Expanded(child: _buildScheduleListSimple(isDark)),
      ],
    );
  }

  Widget _buildDayFilterSimple(bool isDark) {
    final days = [
      'Semua Hari',
      'Senin',
      'Selasa',
      'Rabu',
      'Kamis',
      'Jumat',
      'Sabtu',
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final day = days[index];
          final isSelected = _selectedScheduleDay == day;
          return InkWell(
            onTap: () => setState(() => _selectedScheduleDay = day),
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF003d9b)
                    : (isDark ? const Color(0xFF1F2937) : Colors.white),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF003d9b)
                      : (isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFe1e2e4)),
                ),
              ),
              child: Text(
                day,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF191c1e)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScheduleListSimple(bool isDark) {
    return Consumer<DashboardDosenProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingMataKuliah) {
          return const Center(child: CircularProgressIndicator());
        }

        List<Map<String, dynamic>> filteredSchedules;

        if (_selectedScheduleDay == 'Semua Hari') {
          filteredSchedules = provider.mataKuliahList;
        } else {
          filteredSchedules = provider.mataKuliahList
              .where(
                (mk) =>
                    (mk['hari'] ?? '').toString().toLowerCase() ==
                    _selectedScheduleDay.toLowerCase(),
              )
              .toList();
        }

        if (filteredSchedules.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 64,
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedScheduleDay == 'Semua Hari'
                      ? 'Belum ada jadwal'
                      : 'Tidak ada jadwal pada hari $_selectedScheduleDay',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: _loadData,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredSchedules.length,
            itemBuilder: (context, index) {
              final schedule = filteredSchedules[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildScheduleCardSimple(schedule, isDark),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildScheduleCardSimple(Map<String, dynamic> schedule, bool isDark) {
    final now = DateTime.now();
    final isToday =
        (schedule['hari'] ?? '').toString().toLowerCase() ==
        [
          'senin',
          'selasa',
          'rabu',
          'kamis',
          'jumat',
          'sabtu',
          'minggu',
        ][now.weekday - 1];
    final statusText = isToday ? 'Aktif' : 'Terjadwal';
    final statusColor = isToday
        ? const Color(0xFF10B981)
        : const Color(0xFF737685);
    final statusBgColor = isToday
        ? const Color(0xFFD1FAE5)
        : const Color(0xFFE5E7EB);

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
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Title and Status Badge
          Row(
            children: [
              Expanded(
                child: Text(
                  schedule['nama_mk'] ?? '-',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Location
          Row(
            children: [
              Icon(
                Icons.meeting_room,
                size: 16,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF737685),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  schedule['ruangan'] ?? '-',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Schedule
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Waktu Perkuliahan',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${schedule['hari'] ?? '-'}, ${schedule['jam_mulai']?.substring(0, 5) ?? '-'} - ${schedule['jam_selesai']?.substring(0, 5) ?? '-'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Attendance Info
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF111827)
                        : const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.groups,
                        size: 14,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF737685),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${schedule['peserta']?.length ?? 0} Peserta',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF737685),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (schedule['jumlah_hadir_hari_ini'] ?? 0) > 0
                        ? const Color(0xFF10B981).withValues(alpha: 0.1)
                        : isDark
                        ? const Color(0xFF111827)
                        : const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 14,
                        color: (schedule['jumlah_hadir_hari_ini'] ?? 0) > 0
                            ? const Color(0xFF10B981)
                            : (isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF737685)),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${schedule['jumlah_hadir_hari_ini'] ?? 0}/${schedule['peserta']?.length ?? 0} Hadir',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: (schedule['jumlah_hadir_hari_ini'] ?? 0) > 0
                              ? const Color(0xFF10B981)
                              : (isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF737685)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const GenerateQrScreen(),
                      ),
                    ).then((_) => _loadData());
                  },
                  icon: const Icon(Icons.qr_code_scanner, size: 18),
                  label: const Text('Kelola Presensi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003d9b),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MataKuliahDetailScreen(mataKuliah: schedule),
                      ),
                    );
                  },
                  icon: const Icon(Icons.info_outline, size: 18),
                  label: const Text('Detail'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF003d9b),
                    side: const BorderSide(color: Color(0xFF003d9b)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatContent() {
    return const RekapKehadiranScreen();
  }

  Widget _buildProfileContent() {
    return const DosenProfileScreen();
  }

  Widget _buildBottomNav() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Beranda',
                index: 0,
              ),
              _buildNavItem(
                icon: Icons.calendar_month_outlined,
                activeIcon: Icons.calendar_month,
                label: 'Jadwal',
                index: 1,
              ),
              _buildNavItem(
                icon: Icons.history_outlined,
                activeIcon: Icons.history,
                label: 'Riwayat',
                index: 2,
              ),
              _buildNavItem(
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: 'Profil',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isActive = _selectedIndex == index;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive
                  ? const Color(0xFF003d9b)
                  : (isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685)),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive
                    ? const Color(0xFF003d9b)
                    : (isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
