import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/dashboard_provider.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  void _loadStats() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final dashboardProvider = Provider.of<DashboardProvider>(
      context,
      listen: false,
    );

    if (authProvider.user != null) {
      dashboardProvider.loadMahasiswaStats(authProvider.user!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Profil Saya',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003d9b),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => _navigateToEditProfile(),
                      color: const Color(0xFF003d9b),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Profile Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF003d9b).withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF003d9b), Color(0xFF0052cc)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF003d9b,
                            ).withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          user?.name.substring(0, 1).toUpperCase() ?? 'M',
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Name
                    Text(
                      user?.name ?? 'Mahasiswa',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF191c1e),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Role Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user?.role.toUpperCase() ?? 'MAHASISWA',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003d9b),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Info Items
                    _buildInfoItem(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? '-',
                    ),
                    if (user?.nim != null) ...[
                      const SizedBox(height: 12),
                      _buildInfoItem(
                        icon: Icons.badge_outlined,
                        label: 'NIM',
                        value: user?.nim ?? '-',
                      ),
                    ],
                    if (user?.noHp != null && user!.noHp!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoItem(
                        icon: Icons.phone_outlined,
                        label: 'No. HP',
                        value: user.noHp!,
                      ),
                    ],
                    if (user?.alamat != null && user!.alamat!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      _buildInfoItem(
                        icon: Icons.location_on_outlined,
                        label: 'Alamat',
                        value: user.alamat!,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Statistics Card
              _buildStatisticsCard(),

              const SizedBox(height: 16),

              // Menu Items
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF003d9b).withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      icon: Icons.lock_outline,
                      title: 'Ubah Password',
                      onTap: () => _navigateToChangePassword(),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.help_outline,
                      title: 'Bantuan',
                      onTap: () => _showHelp(),
                    ),
                    const Divider(height: 1),
                    _buildMenuItem(
                      icon: Icons.info_outline,
                      title: 'Tentang Aplikasi',
                      onTap: () => _showAbout(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Logout Button
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _handleLogout(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF003d9b).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF003d9b), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Color(0xFF737685)),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF191c1e),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        final stats = provider.mahasiswaStats;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Statistik Akademik',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      label: 'Mata Kuliah',
                      value: '${stats?.totalMataKuliah ?? 0}',
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      label: 'Tugas Selesai',
                      value: '${stats?.tugasSelesai ?? 0}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      label: 'Tugas Pending',
                      value: '${stats?.tugasPending ?? 0}',
                    ),
                  ),
                  Expanded(
                    child: _buildStatItem(
                      label: 'Kehadiran',
                      value:
                          '${stats?.persentaseKehadiran.toStringAsFixed(0) ?? '0'}%',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Persentase Kehadiran',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '${stats?.persentaseKehadiran.toStringAsFixed(1) ?? '0.0'}%',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF003d9b), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF191c1e),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFF737685), size: 20),
          ],
        ),
      ),
    );
  }

  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfileScreen()),
    );

    if (result == true && mounted) {
      // Reload user data
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.checkAuthStatus();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profil berhasil diperbarui'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _navigateToChangePassword() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
    );

    if (result == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password berhasil diubah'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bantuan'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Cara Menggunakan Aplikasi:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 12),
              Text('1. Scan QR Code untuk melakukan absensi'),
              SizedBox(height: 8),
              Text('2. Lihat jadwal kuliah di menu Jadwal'),
              SizedBox(height: 8),
              Text('3. Cek riwayat absensi di menu Riwayat'),
              SizedBox(height: 8),
              Text('4. Update profil di menu Profil'),
              SizedBox(height: 16),
              Text(
                'Butuh bantuan lebih lanjut?',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Text('Hubungi admin atau dosen pengampu.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tentang Aplikasi'),
        content: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Presensi Kampus',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 8),
            Text('Versi 1.0.0'),
            SizedBox(height: 16),
            Text(
              'Aplikasi presensi mahasiswa berbasis QR Code untuk memudahkan proses absensi perkuliahan.',
            ),
            SizedBox(height: 16),
            Text(
              '© 2026 Presensi Kampus',
              style: TextStyle(fontSize: 12, color: Color(0xFF737685)),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );

              await authProvider.logout();

              if (mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFDC2626),
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
