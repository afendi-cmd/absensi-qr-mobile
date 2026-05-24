import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';

class MahasiswaDashboardScreen extends StatefulWidget {
  const MahasiswaDashboardScreen({super.key});

  @override
  State<MahasiswaDashboardScreen> createState() =>
      _MahasiswaDashboardScreenState();
}

class _MahasiswaDashboardScreenState extends State<MahasiswaDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final dashboardProvider = Provider.of<DashboardProvider>(
        context,
        listen: false,
      );

      if (authProvider.user != null) {
        dashboardProvider.loadMahasiswaStats(authProvider.user!.id);
        dashboardProvider.loadMahasiswaMataKuliah(authProvider.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: _selectedIndex == 0
            ? _buildHomeContent()
            : _selectedIndex == 1
            ? _buildScheduleContent()
            : _selectedIndex == 2
            ? _buildHistoryContent()
            : _buildProfileContent(),
      ),
      bottomNavigationBar: _buildBottomNav(),
      floatingActionButton: _buildScanQrFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHomeContent() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final now = DateTime.now();
    final dateFormat = DateFormat('EEEE, d MMMM yyyy');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF003d9b),
                  child: Text(
                    user?.name.substring(0, 1).toUpperCase() ?? 'M',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Presensi Kampus',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003d9b),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
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
                // Greeting
                Text(
                  'Halo, ${user?.name ?? 'Mahasiswa'}!',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF191c1e),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateFormat.format(now),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF737685),
                  ),
                ),
                const SizedBox(height: 20),

                // Attendance Card
                _buildAttendanceCard(),
                const SizedBox(height: 24),

                // Schedule Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Jadwal Hari Ini',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF191c1e),
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

                // Schedule Cards
                _buildScheduleList(),
                const SizedBox(height: 24),

                // Quick Actions
                Row(
                  children: [
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.event_note,
                        label: 'Kalender\nAkademik',
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildQuickActionCard(
                        icon: Icons.assignment_turned_in,
                        label: 'Tugas &\nUjian',
                        onTap: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceCard() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final stats = provider.mahasiswaStats;
        final attendance = stats?.persentaseKehadiran ?? 0.0;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF003d9b), Color(0xFF0052cc)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF003d9b).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Kehadiran',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFc4d2ff),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${attendance.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Status: Aman',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.analytics_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildScheduleList() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        if (provider.isLoadingMataKuliah) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final mataKuliahList = provider.mataKuliahList;

        if (mataKuliahList.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFe1e2e4)),
            ),
            child: const Center(
              child: Text(
                'Tidak ada jadwal hari ini',
                style: TextStyle(fontSize: 14, color: Color(0xFF737685)),
              ),
            ),
          );
        }

        return Column(
          children: mataKuliahList.take(3).map((mk) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _buildScheduleCard(
                time: '08:00 - 10:30',
                title: mk.namaMk,
                location: 'Lab Komputer 3',
                lecturer: mk.dosen?.nama ?? 'Dosen',
                status: 'Hadir',
                statusColor: const Color(0xFF10B981),
                statusBgColor: const Color(0xFFD1FAE5),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildScheduleCard({
    required String time,
    required String title,
    required String location,
    required String lecturer,
    required String status,
    required Color statusColor,
    required Color statusBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFe1e2e4)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF003d9b).withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF003d9b),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF191c1e),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: Color(0xFF737685),
              ),
              const SizedBox(width: 6),
              Text(
                location,
                style: const TextStyle(fontSize: 14, color: Color(0xFF737685)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: Color(0xFF737685),
              ),
              const SizedBox(width: 6),
              Text(
                lecturer,
                style: const TextStyle(fontSize: 14, color: Color(0xFF737685)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFe1e2e4)),
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
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF191c1e),
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleContent() {
    return const Center(child: Text('Jadwal Screen'));
  }

  Widget _buildHistoryContent() {
    return const Center(child: Text('Riwayat Screen'));
  }

  Widget _buildProfileContent() {
    return const Center(child: Text('Profil Screen'));
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(icon: Icons.home, label: 'Beranda', index: 0),
              _buildNavItem(
                icon: Icons.calendar_today,
                label: 'Jadwal',
                index: 1,
              ),
              _buildNavItem(icon: Icons.history, label: 'Riwayat', index: 2),
              _buildNavItem(icon: Icons.person, label: 'Profil', index: 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isActive = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF003d9b).withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive
                  ? const Color(0xFF003d9b)
                  : const Color(0xFF737685),
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
                    : const Color(0xFF737685),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanQrFab() {
    return FloatingActionButton(
      onPressed: () {
        // TODO: Navigate to QR Scanner
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Scan QR akan segera hadir')),
        );
      },
      backgroundColor: const Color(0xFF003d9b),
      child: const Icon(Icons.qr_code_scanner, color: Colors.white),
    );
  }
}
