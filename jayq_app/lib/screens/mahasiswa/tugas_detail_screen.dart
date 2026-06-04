import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/theme_provider.dart';
import '../../data/models/tugas_model.dart';
import '../../data/services/tugas_service.dart';

class TugasDetailScreen extends StatefulWidget {
  final Map<String, dynamic>? tugasData;
  final TugasModel? tugas;

  const TugasDetailScreen({super.key, this.tugasData, this.tugas})
    : assert(
        tugasData != null || tugas != null,
        'Either tugasData or tugas must be provided',
      );

  @override
  State<TugasDetailScreen> createState() => _TugasDetailScreenState();
}

class _TugasDetailScreenState extends State<TugasDetailScreen> {
  final _tugasService = TugasService();
  bool _isUploading = false;
  File? _selectedFile;

  // Helper getters to work with both Map and Model
  int get _tugasId => widget.tugasData?['id'] ?? widget.tugas!.id;
  String get _judul => widget.tugasData?['judul'] ?? widget.tugas!.judul;
  String? get _deskripsi =>
      widget.tugasData?['deskripsi'] ?? widget.tugas?.deskripsi;
  String? get _fileTugas =>
      widget.tugasData?['file_tugas'] ?? widget.tugas?.fileTugas;
  DateTime get _deadline => widget.tugasData != null
      ? DateTime.parse(widget.tugasData!['deadline'])
      : widget.tugas!.deadline;
  bool get _sudahDikumpulkan =>
      widget.tugasData?['sudah_dikumpulkan'] ?? widget.tugas!.sudahDikumpulkan;
  bool get _isOverdue => _deadline.isBefore(DateTime.now());
  String get _namaMk =>
      widget.tugasData?['mata_kuliah']?['nama_mk'] ??
      widget.tugas?.mataKuliah?.namaMk ??
      '-';

  String get _statusLabel {
    if (_sudahDikumpulkan) return 'Sudah Dikumpulkan';
    if (_isOverdue) return 'Terlambat';
    return 'Belum Dikumpulkan';
  }

  String get _formattedDeadline {
    final now = DateTime.now();
    final difference = _deadline.difference(now);

    if (difference.isNegative) {
      return 'Terlambat ${difference.inDays.abs()} hari';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lagi';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lagi';
    } else {
      return '${difference.inMinutes} menit lagi';
    }
  }

  Map<String, dynamic>? get _pengumpulanData =>
      widget.tugasData?['pengumpulan'];

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    Color statusColor;

    if (_sudahDikumpulkan) {
      statusColor = const Color(0xFF10B981);
    } else if (_isOverdue) {
      statusColor = const Color(0xFFDC2626);
    } else {
      statusColor = const Color(0xFFF59E0B);
    }

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: Text(
          'Detail Tugas',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF003d9b),
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [statusColor, statusColor.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _statusLabel.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    _judul,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),

            // Meta Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1F2937) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildMetaRow(
                    icon: Icons.book_outlined,
                    label: 'Mata Kuliah',
                    value: _namaMk,
                    isDark: isDark,
                  ),
                  Divider(
                    height: 24,
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                  _buildMetaRow(
                    icon: Icons.calendar_today_outlined,
                    label: 'Deadline',
                    value: DateFormat(
                      'EEEE, d MMMM yyyy HH:mm',
                    ).format(_deadline),
                    isDark: isDark,
                  ),
                  Divider(
                    height: 24,
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                  _buildMetaRow(
                    icon: Icons.access_time_outlined,
                    label: 'Sisa Waktu',
                    value: _formattedDeadline,
                    valueColor: _isOverdue ? const Color(0xFFDC2626) : null,
                    isDark: isDark,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Description Card
            if (_deskripsi != null && _deskripsi!.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Deskripsi Tugas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF191c1e),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _deskripsi!,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF191c1e),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // File Tugas (if exists)
            if (_fileTugas != null) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'File Tugas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF191c1e),
                      ),
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: () => _downloadFile(_fileTugas!),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF111827)
                              : const Color(0xFFF8F9FB),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF374151)
                                : const Color(0xFFe1e2e4),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.description,
                              color: Color(0xFF003d9b),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Download File Tugas',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF191c1e),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.download,
                              color: Color(0xFF003d9b),
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Pengumpulan Section
            if (_sudahDikumpulkan) ...[
              _buildPengumpulanCard(),
            ] else if (!_isOverdue) ...[
              _buildUploadSection(),
            ],

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
    Color? valueColor,
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
                  color:
                      valueColor ??
                      (isDark ? Colors.white : const Color(0xFF191c1e)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPengumpulanCard() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    // Handle both Map and Model
    if (_pengumpulanData == null && widget.tugas?.pengumpulan == null) {
      return const SizedBox();
    }

    final tanggalUpload = _pengumpulanData != null
        ? DateTime.parse(_pengumpulanData!['tanggal_upload'])
        : widget.tugas!.pengumpulan!.tanggalUpload;
    final sudahDinilai = _pengumpulanData != null
        ? (_pengumpulanData!['sudah_dinilai'] ?? false)
        : widget.tugas!.pengumpulan!.sudahDinilai;
    final nilai = _pengumpulanData != null
        ? _pengumpulanData!['nilai']
        : widget.tugas!.pengumpulan!.nilai;
    final catatan = _pengumpulanData != null
        ? _pengumpulanData!['catatan']
        : widget.tugas!.pengumpulan!.catatan;
    final fileJawaban = _pengumpulanData != null
        ? _pengumpulanData!['file_jawaban']
        : widget.tugas!.pengumpulan!.fileJawaban;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: Color(0xFF10B981),
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                'Tugas Sudah Dikumpulkan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Tanggal Upload',
            DateFormat('d MMMM yyyy, HH:mm').format(tanggalUpload),
            isDark,
          ),
          if (sudahDinilai) ...[
            const SizedBox(height: 12),
            _buildInfoRow('Nilai', '$nilai/100', isDark),
            if (catatan != null) ...[
              const SizedBox(height: 12),
              _buildInfoRow('Catatan', catatan, isDark),
            ],
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _downloadFile(fileJawaban),
              icon: const Icon(Icons.download),
              label: const Text('Download File Jawaban'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF003d9b),
                side: const BorderSide(color: Color(0xFF003d9b)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Upload Jawaban',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF191c1e),
            ),
          ),
          const SizedBox(height: 16),

          // File Picker
          InkWell(
            onTap: _isUploading ? null : _pickFile,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF111827)
                    : const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _selectedFile != null
                      ? const Color(0xFF003d9b)
                      : (isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFe1e2e4)),
                  width: _selectedFile != null ? 2 : 1,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    _selectedFile != null
                        ? Icons.check_circle
                        : Icons.upload_file,
                    size: 48,
                    color: _selectedFile != null
                        ? const Color(0xFF10B981)
                        : (isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF737685)),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _selectedFile != null
                        ? _selectedFile!.path.split('/').last
                        : 'Pilih file (PDF, DOC, DOCX)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _selectedFile != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: _selectedFile != null
                          ? (isDark ? Colors.white : const Color(0xFF191c1e))
                          : (isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF737685)),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (_selectedFile != null) ...[
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () => setState(() => _selectedFile = null),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Hapus'),
                      style: TextButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Upload Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedFile != null && !_isUploading
                  ? _uploadTugas
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003d9b),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: _isUploading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text(
                      'Upload Tugas',
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

  Widget _buildInfoRow(String label, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
          ),
        ),
        Text(
          ': ',
          style: TextStyle(
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : const Color(0xFF191c1e),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _selectedFile = File(result.files.single.path!);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error memilih file: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  Future<void> _uploadTugas() async {
    if (_selectedFile == null) return;

    setState(() => _isUploading = true);

    try {
      await _tugasService.uploadTugas(
        tugasId: _tugasId,
        filePath: _selectedFile!.path,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil dikumpulkan'),
            backgroundColor: Color(0xFF10B981),
          ),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  Future<void> _downloadFile(String filePath) async {
    try {
      final url = _tugasService.getDownloadUrl(filePath);
      final uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Tidak dapat membuka file');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFDC2626),
          ),
        );
      }
    }
  }
}
