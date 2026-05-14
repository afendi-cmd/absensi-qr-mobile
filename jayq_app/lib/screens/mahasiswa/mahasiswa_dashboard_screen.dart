import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/stat_card.dart';

class MahasiswaDashboardScreen extends StatefulWidget {
  const MahasiswaDashboardScreen({super.key});

  @override
  State<MahasiswaDashboardScreen> createState() =>
      _MahasiswaDashboardScreenState();
}

class _MahasiswaDashboardScreenState extends State<MahasiswaDashboardScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(),
            const SizedBox(height: 30),

            // Scan QR Button
            _buildScanQrButton(),
            const SizedBox(height: 30),

            Text(
              'Statistik Saya',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildStatisticsGrid(),
            const SizedBox(height: 30),

            Text(
              'Mata Kuliah Saya',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildMataKuliahList(),
            const SizedBox(height: 30),

            Text(
              'Tugas Mendatang',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            _buildTugasList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildWelcomeSection() {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.mahasiswaColor,
            AppColors.mahasiswaColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.mahasiswaColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              user?.name.substring(0, 1).toUpperCase() ?? 'M',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.mahasiswaColor,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Halo,',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.name ?? 'Mahasiswa',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (user?.nim != null)
                  Text(
                    'NIM: ${user!.nim}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.white70),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanQrButton() {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to Scan QR
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.qr_code_scanner, size: 48, color: Colors.white),
              const SizedBox(height: 8),
              Text(
                'Scan QR Code',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Tap untuk absen',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.3,
      children: [
        StatCard(
          title: 'Mata Kuliah',
          value: '6',
          icon: Icons.book,
          color: AppColors.info,
        ),
        StatCard(
          title: 'Kehadiran',
          value: '85%',
          icon: Icons.check_circle,
          color: AppColors.success,
        ),
        StatCard(
          title: 'Tugas Selesai',
          value: '12/15',
          icon: Icons.assignment_turned_in,
          color: AppColors.mahasiswaColor,
        ),
        StatCard(
          title: 'Tugas Pending',
          value: '3',
          icon: Icons.pending_actions,
          color: AppColors.warning,
        ),
      ],
    );
  }

  Widget _buildMataKuliahList() {
    return Column(
      children: [
        _buildMataKuliahCard(
          kodeMk: 'IF101',
          namaMk: 'Pemrograman Mobile',
          dosen: 'Dr. Ahmad',
          kehadiran: 90,
        ),
        const SizedBox(height: 12),
        _buildMataKuliahCard(
          kodeMk: 'IF102',
          namaMk: 'Basis Data',
          dosen: 'Dr. Budi',
          kehadiran: 85,
        ),
        const SizedBox(height: 12),
        _buildMataKuliahCard(
          kodeMk: 'IF103',
          namaMk: 'Algoritma & Struktur Data',
          dosen: 'Dr. Citra',
          kehadiran: 80,
        ),
      ],
    );
  }

  Widget _buildMataKuliahCard({
    required String kodeMk,
    required String namaMk,
    required String dosen,
    required int kehadiran,
  }) {
    return Card(
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
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
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    kodeMk,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: kehadiran >= 80
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$kehadiran%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: kehadiran >= 80
                          ? AppColors.success
                          : AppColors.warning,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(namaMk, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: AppColors.textLight),
                const SizedBox(width: 4),
                Text(dosen, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTugasList() {
    return Column(
      children: [
        _buildTugasCard(
          judul: 'Tugas UTS - Mobile Programming',
          mataKuliah: 'Pemrograman Mobile',
          deadline: DateTime.now().add(const Duration(days: 2)),
          isUrgent: true,
        ),
        const SizedBox(height: 12),
        _buildTugasCard(
          judul: 'Laporan Praktikum Database',
          mataKuliah: 'Basis Data',
          deadline: DateTime.now().add(const Duration(days: 5)),
          isUrgent: false,
        ),
      ],
    );
  }

  Widget _buildTugasCard({
    required String judul,
    required String mataKuliah,
    required DateTime deadline,
    required bool isUrgent,
  }) {
    final daysLeft = deadline.difference(DateTime.now()).inDays;

    return Card(
      elevation: 2,
      shadowColor: AppColors.shadow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    judul,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (isUrgent)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Urgent',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.error,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(mataKuliah, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: isUrgent ? AppColors.error : AppColors.textLight,
                ),
                const SizedBox(width: 4),
                Text(
                  '$daysLeft hari lagi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isUrgent ? AppColors.error : AppColors.textLight,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textLight,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Mata Kuliah'),
        BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tugas'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
