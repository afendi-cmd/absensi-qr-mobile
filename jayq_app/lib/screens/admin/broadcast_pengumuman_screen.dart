import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../providers/theme_provider.dart';
import '../../data/services/pengumuman_service.dart';
import '../../data/services/notification_service.dart';

class BroadcastPengumumanScreen extends StatefulWidget {
  const BroadcastPengumumanScreen({super.key});

  @override
  State<BroadcastPengumumanScreen> createState() =>
      _BroadcastPengumumanScreenState();
}

class _BroadcastPengumumanScreenState extends State<BroadcastPengumumanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _isiController = TextEditingController();

  late PengumumanService _pengumumanService;
  final NotificationService _notificationService = NotificationService();

  String _selectedTarget = 'all';
  File? _selectedFile;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    _pengumumanService = PengumumanService();
  }

  @override
  void dispose() {
    _isiController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      );

      if (result != null) {
        final File file = File(result.files.single.path!);
        final int fileSize = await file.length();

        // Check file size (max 10MB)
        if (fileSize > 10 * 1024 * 1024) {
          _showSnackBar('Ukuran file maksimal 10MB', isError: true);
          return;
        }

        setState(() {
          _selectedFile = file;
        });
      }
    } catch (e) {
      _showSnackBar('Gagal memilih file: ${e.toString()}', isError: true);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isiController.text.trim().isEmpty) {
      _showSnackBar('Isi pengumuman tidak boleh kosong', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Create pengumuman
      await _pengumumanService.createPengumuman({
        'judul': 'Broadcast Pengumuman',
        'isi': _isiController.text.trim(),
        'tipe': 'info',
        'target': _selectedTarget,
      });

      // Send push notification
      String targetText = _selectedTarget == 'all'
          ? 'semua pengguna'
          : _selectedTarget == 'dosen'
          ? 'dosen'
          : 'mahasiswa';

      await _notificationService.sendNotificationToUsers(
        title: 'Pengumuman Baru',
        body: _isiController.text.trim(),
        target: _selectedTarget,
      );

      // Show local notification immediately for testing
      await _notificationService.showTestNotification(
        title: '📢 Pengumuman Baru',
        body: _isiController.text.trim().length > 100
            ? '${_isiController.text.trim().substring(0, 100)}...'
            : _isiController.text.trim(),
      );

      _showSnackBar('Pengumuman berhasil dikirim ke $targetText');

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar(
        'Gagal mengirim pengumuman: ${e.toString()}',
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
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
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF191C1E),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Broadcast Pengumuman',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191C1E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSubtitle(isDark),
              const SizedBox(height: 24),
              _buildFormCard(isDark),
              const SizedBox(height: 16),
              _buildInfoCard(isDark),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubtitle(bool isDark) {
    return Text(
      'Kirimkan informasi penting ke seluruh civitas akademika dengan cepat.',
      style: TextStyle(
        fontSize: 14,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
      ),
    );
  }

  Widget _buildFormCard(bool isDark) {
    return Container(
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('TARGET PENERIMA', isDark),
            const SizedBox(height: 12),
            _buildTargetButtons(isDark),
            const SizedBox(height: 20),
            _buildLabel('ISI PENGUMUMAN', isDark),
            const SizedBox(height: 12),
            _buildTextArea(isDark),
            const SizedBox(height: 20),
            _buildLabel('LAMPIRAN FILE ATAU GAMBAR', isDark),
            const SizedBox(height: 12),
            _buildFileUpload(isDark),
            const SizedBox(height: 24),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
      ),
    );
  }

  Widget _buildTargetButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: _buildTargetButton(
            label: 'Semua',
            icon: Icons.groups,
            value: 'all',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTargetButton(
            label: 'Dosen',
            icon: Icons.school,
            value: 'dosen',
            isDark: isDark,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildTargetButton(
            label: 'Mahasiswa',
            icon: Icons.person,
            value: 'mahasiswa',
            isDark: isDark,
          ),
        ),
      ],
    );
  }

  Widget _buildTargetButton({
    required String label,
    required IconData icon,
    required String value,
    required bool isDark,
  }) {
    final isSelected = _selectedTarget == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTarget = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF003D9B)
              : (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF003D9B)
                : (isDark ? const Color(0xFF4B5563) : const Color(0xFFE1E2E4)),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685)),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected
                    ? Colors.white
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

  Widget _buildTextArea(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE1E2E4),
        ),
      ),
      child: TextFormField(
        controller: _isiController,
        maxLines: 8,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : const Color(0xFF191C1E),
        ),
        decoration: InputDecoration(
          hintText: 'Tuliskan isi pengumuman di sini...',
          hintStyle: TextStyle(
            fontSize: 15,
            color: isDark ? const Color(0xFF6B7280) : const Color(0xFFADB5BD),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Isi pengumuman tidak boleh kosong';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildFileUpload(bool isDark) {
    return GestureDetector(
      onTap: _pickFile,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 48,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
            const SizedBox(height: 12),
            Text(
              _selectedFile != null
                  ? _selectedFile!.path.split('/').last
                  : 'Klik untuk unggah atau file ke sini',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : const Color(0xFF191C1E),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Maks. 10MB (JPG, PNG, PDF)',
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
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003D9B),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(
            0xFF003D9B,
          ).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Kirim Pengumuman',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E3A5F).withValues(alpha: 0.5)
            : const Color(0xFFD4E0F8).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF1E3A5F) : const Color(0xFFD4E0F8),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: isDark ? const Color(0xFF93C5FD) : const Color(0xFF003D9B),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Pengumuman yang dikirim akan segera muncul di tab Beranda setiap user dan dikirimkan sebagai notifikasi push ke perangkat mereka.',
              style: TextStyle(
                fontSize: 12,
                height: 1.5,
                color: isDark
                    ? const Color(0xFFD1D5DB)
                    : const Color(0xFF434654),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
