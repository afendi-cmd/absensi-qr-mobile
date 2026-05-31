import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../auth/login_screen.dart';
import 'edit_profile_screen.dart';
import 'change_password_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.user;
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildProfileCard(user, isDark),
              const SizedBox(height: 20),
              _buildSettingsSection(themeProvider, isDark),
              const SizedBox(height: 20),
              _buildAccountSection(isDark),
              const SizedBox(height: 20),
              _buildAboutSection(isDark),
              const SizedBox(height: 20),
              _buildLogoutButton(isDark),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(user, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
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
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFE0E7FF),
              ),
              child: Center(
                child: Text(
                  user?.name.substring(0, 1).toUpperCase() ?? 'M',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : const Color(0xFF2563EB),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              user?.name ?? 'Mahasiswa',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              user?.email ?? 'mahasiswa@example.com',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E40AF)
                    : const Color(0xFFDBEAFE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Mahasiswa',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF2563EB),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(ThemeProvider themeProvider, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'PENGATURAN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
          ),
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
                _buildMenuItem(
                  icon: Icons.dark_mode_outlined,
                  title: 'Mode Gelap',
                  isDark: isDark,
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) => themeProvider.toggleTheme(),
                    activeTrackColor: const Color(0xFF2563EB),
                  ),
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifikasi',
                  isDark: isDark,
                  onTap: () {
                    _showNotificationSettings();
                  },
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.language_outlined,
                  title: 'Bahasa',
                  isDark: isDark,
                  subtitle: 'Indonesia',
                  onTap: () {
                    _showLanguageSettings();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'AKUN',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
          ),
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
                _buildMenuItem(
                  icon: Icons.person_outline,
                  title: 'Edit Profil',
                  isDark: isDark,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EditProfileScreen(),
                      ),
                    );

                    // Reload user data if profile was updated
                    if (result == true && mounted) {
                      setState(() {});
                    }
                  },
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.lock_outline,
                  title: 'Ubah Password',
                  isDark: isDark,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );

                    // Show success message if password was changed
                    if (result == true && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Password berhasil diubah'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'TENTANG',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
                letterSpacing: 0.5,
              ),
            ),
          ),
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
                _buildMenuItem(
                  icon: Icons.help_outline,
                  title: 'Bantuan & Dukungan',
                  isDark: isDark,
                  onTap: () {
                    _showHelpDialog();
                  },
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.description_outlined,
                  title: 'Syarat & Ketentuan',
                  isDark: isDark,
                  onTap: () {
                    _showTermsDialog();
                  },
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Kebijakan Privasi',
                  isDark: isDark,
                  onTap: () {
                    _showPrivacyDialog();
                  },
                ),
                _buildDivider(isDark),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  title: 'Tentang Aplikasi',
                  isDark: isDark,
                  subtitle: 'Versi 1.0.0',
                  onTap: () {
                    _showAboutDialog();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _handleLogout,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark
                ? const Color(0xFF991B1B)
                : const Color(0xFFEF4444),
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
                'Keluar dari Akun',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required bool isDark,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: isDark ? Colors.white : const Color(0xFF111827),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
            )
          : null,
      trailing:
          trailing ??
          Icon(
            Icons.chevron_right,
            color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
          ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
      indent: 16,
      endIndent: 16,
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              // Close dialog first
              Navigator.pop(dialogContext);

              // Save context before async operation
              final navigator = Navigator.of(context);

              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );

              try {
                await authProvider.logout();
              } catch (e) {
                // Even if logout fails on server, clear local data
                debugPrint('Logout error (ignored): $e');
              }

              // Navigate to login screen
              if (mounted) {
                navigator.pushAndRemoveUntil(
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

  void _showNotificationSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Pengaturan Notifikasi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: Text(
          'Fitur pengaturan notifikasi akan segera hadir. Anda akan dapat mengatur preferensi notifikasi untuk pengumuman, tugas, dan absensi.',
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

  void _showLanguageSettings() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Pengaturan Bahasa',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: Text(
          'Saat ini aplikasi hanya tersedia dalam Bahasa Indonesia. Dukungan multi-bahasa akan ditambahkan di versi mendatang.',
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

  void _showHelpDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Bantuan & Dukungan',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Butuh bantuan? Hubungi kami melalui:',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
              const SizedBox(height: 16),
              _buildContactItem(
                Icons.email_outlined,
                'Email',
                'support@presensi.ac.id',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                Icons.phone_outlined,
                'Telepon',
                '+62 21 1234 5678',
                isDark,
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                Icons.access_time,
                'Jam Operasional',
                'Senin - Jumat, 08:00 - 17:00',
                isDark,
              ),
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

  void _showTermsDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Syarat & Ketentuan',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            '1. Penggunaan Aplikasi\n'
            'Aplikasi ini hanya untuk keperluan akademik dan absensi mahasiswa.\n\n'
            '2. Akun Pengguna\n'
            'Setiap pengguna bertanggung jawab atas keamanan akun mereka.\n\n'
            '3. Data Pribadi\n'
            'Data pribadi akan dijaga kerahasiaannya sesuai kebijakan privasi.\n\n'
            '4. Larangan\n'
            'Dilarang menyalahgunakan aplikasi untuk tujuan yang melanggar hukum.\n\n'
            '5. Perubahan Ketentuan\n'
            'Kami berhak mengubah syarat dan ketentuan sewaktu-waktu.',
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
              height: 1.5,
            ),
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

  void _showPrivacyDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Kebijakan Privasi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: SingleChildScrollView(
          child: Text(
            '1. Pengumpulan Data\n'
            'Kami mengumpulkan data seperti nama, email, dan data absensi untuk keperluan akademik.\n\n'
            '2. Penggunaan Data\n'
            'Data digunakan untuk sistem absensi, pengumuman, dan manajemen akademik.\n\n'
            '3. Keamanan Data\n'
            'Data disimpan dengan enkripsi dan hanya dapat diakses oleh pihak berwenang.\n\n'
            '4. Berbagi Data\n'
            'Data tidak akan dibagikan kepada pihak ketiga tanpa persetujuan.\n\n'
            '5. Hak Pengguna\n'
            'Anda berhak mengakses, mengubah, atau menghapus data pribadi Anda.',
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
              height: 1.5,
            ),
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

  void _showAboutDialog() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    final isDark = themeProvider.isDarkMode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Tentang Aplikasi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF003d9b),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.school, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 16),
            Text(
              'Presensi Kampus',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF191c1e),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Versi 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF737685),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Aplikasi absensi dan manajemen akademik untuk mahasiswa dan dosen.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF737685),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '© 2026 Presensi Kampus',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? const Color(0xFF6B7280)
                    : const Color(0xFF9CA3AF),
              ),
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

  Widget _buildContactItem(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xFF003d9b)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
