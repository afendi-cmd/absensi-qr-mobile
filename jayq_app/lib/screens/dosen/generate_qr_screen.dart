import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
import '../../providers/qr_provider.dart';
import '../../providers/dashboard_dosen_provider.dart';
import '../../providers/theme_provider.dart';

class GenerateQrScreen extends StatefulWidget {
  const GenerateQrScreen({super.key});

  @override
  State<GenerateQrScreen> createState() => _GenerateQrScreenState();
}

class _GenerateQrScreenState extends State<GenerateQrScreen> {
  int? _selectedMataKuliahId;
  int _selectedDuration = 15;
  Timer? _countdownTimer;
  int _remainingSeconds = 0;

  final List<int> _durationOptions = [15, 30, 45, 60];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMataKuliah();
    });
  }

  Future<void> _loadMataKuliah() async {
    final provider = Provider.of<DashboardDosenProvider>(
      context,
      listen: false,
    );
    await provider.loadMataKuliah();
  }

  void _startCountdown(String expiredAt) {
    _countdownTimer?.cancel();

    final expiredTime = DateTime.parse(expiredAt);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = expiredTime.difference(now);

      if (difference.isNegative) {
        setState(() => _remainingSeconds = 0);
        timer.cancel();
        _handleSessionExpired();
      } else {
        setState(() => _remainingSeconds = difference.inSeconds);
      }
    });
  }

  void _handleSessionExpired() {
    final qrProvider = Provider.of<QrProvider>(context, listen: false);
    qrProvider.clearSession();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR Session telah berakhir'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Generate QR Code'),
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
        elevation: 0,
      ),
      body: Consumer<QrProvider>(
        builder: (context, qrProvider, child) {
          if (qrProvider.isSessionActive) {
            return _buildActiveSession(qrProvider, isDark);
          } else {
            return _buildGenerateForm(qrProvider, isDark);
          }
        },
      ),
    );
  }

  Widget _buildGenerateForm(QrProvider qrProvider, bool isDark) {
    return Consumer<DashboardDosenProvider>(
      builder: (context, dashboardProvider, child) {
        if (dashboardProvider.isLoadingMataKuliah) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih Mata Kuliah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
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
                      'Pilih mata kuliah',
                      style: TextStyle(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF737685),
                      ),
                    ),
                    dropdownColor: isDark
                        ? const Color(0xFF1F2937)
                        : Colors.white,
                    items: dashboardProvider.mataKuliahList.map((mk) {
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
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedMataKuliahId = value);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Durasi QR Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: _durationOptions.map((duration) {
                  final isSelected = _selectedDuration == duration;
                  return InkWell(
                    onTap: () => setState(() => _selectedDuration = duration),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF003d9b)
                            : (isDark ? const Color(0xFF1F2937) : Colors.white),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF003d9b)
                              : (isDark
                                    ? const Color(0xFF374151)
                                    : const Color(0xFFe1e2e4)),
                        ),
                      ),
                      child: Text(
                        '$duration menit',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? Colors.white
                                    : const Color(0xFF191c1e)),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 32),
              if (qrProvider.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          qrProvider.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      qrProvider.isLoading || _selectedMataKuliahId == null
                      ? null
                      : () => _handleGenerate(qrProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF003d9b),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: qrProvider.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Generate QR Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActiveSession(QrProvider qrProvider, bool isDark) {
    final session = qrProvider.currentSession!;

    // Start countdown jika belum dimulai
    if (_remainingSeconds == 0 && session['expired_at'] != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startCountdown(session['expired_at']);
      });
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // QR Code Card
          Container(
            padding: const EdgeInsets.all(24),
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
                Text(
                  session['mata_kuliah']['nama_mk'] ?? '',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  session['mata_kuliah']['kode_mk'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: QrImageView(
                    data: session['kode_qr'] ?? '',
                    version: QrVersions.auto,
                    size: 250,
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: _remainingSeconds > 300
                        ? const Color(0xFF10B981).withValues(alpha: 0.1)
                        : (_remainingSeconds > 60
                              ? const Color(0xFFF59E0B).withValues(alpha: 0.1)
                              : Colors.red.withValues(alpha: 0.1)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.timer,
                        color: _remainingSeconds > 300
                            ? const Color(0xFF10B981)
                            : (_remainingSeconds > 60
                                  ? const Color(0xFFF59E0B)
                                  : Colors.red),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: _remainingSeconds > 300
                              ? const Color(0xFF10B981)
                              : (_remainingSeconds > 60
                                    ? const Color(0xFFF59E0B)
                                    : Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Attendance Stats
          Container(
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people, color: const Color(0xFF003d9b), size: 32),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${qrProvider.totalHadir}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF191c1e),
                      ),
                    ),
                    Text(
                      'Mahasiswa Hadir',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF737685),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Attendance List
          if (qrProvider.attendances.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
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
                    'Daftar Kehadiran',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF191c1e),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...qrProvider.attendances.map((attendance) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: const Color(
                              0xFF003d9b,
                            ).withValues(alpha: 0.1),
                            child: Text(
                              attendance['mahasiswa']['nama']
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFF003d9b),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  attendance['mahasiswa']['nama'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF191c1e),
                                  ),
                                ),
                                Text(
                                  attendance['mahasiswa']['nim'],
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
                          Icon(
                            Icons.check_circle,
                            color: const Color(0xFF10B981),
                            size: 20,
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Close Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: qrProvider.isLoading
                  ? null
                  : () => _handleCloseSession(qrProvider),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: qrProvider.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Tutup Session',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleGenerate(QrProvider qrProvider) async {
    await qrProvider.generateQr(
      mataKuliahId: _selectedMataKuliahId!,
      duration: _selectedDuration,
    );

    if (qrProvider.error == null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR Code berhasil digenerate'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  Future<void> _handleCloseSession(QrProvider qrProvider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tutup Session'),
        content: const Text('Apakah Anda yakin ingin menutup session QR ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await qrProvider.closeSession();

      if (qrProvider.error == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session berhasil ditutup'),
            backgroundColor: Color(0xFF10B981),
          ),
        );
      }
    }
  }
}
