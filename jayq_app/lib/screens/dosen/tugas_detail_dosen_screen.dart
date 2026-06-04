import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/theme_provider.dart';
import '../../providers/tugas_provider.dart';
import '../../data/services/tugas_service.dart';

class TugasDetailDosenScreen extends StatefulWidget {
  final int tugasId;

  const TugasDetailDosenScreen({super.key, required this.tugasId});

  @override
  State<TugasDetailDosenScreen> createState() => _TugasDetailDosenScreenState();
}

class _TugasDetailDosenScreenState extends State<TugasDetailDosenScreen> {
  final _tugasService = TugasService();
  Map<String, dynamic>? _tugasDetail;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTugasDetail();
  }

  Future<void> _loadTugasDetail() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final detail = await _tugasService.getTugasDetail(widget.tugasId);
      setState(() {
        _tugasDetail = detail;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
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
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteConfirmation(context, isDark),
          ),
        ],
      ),
      body: _buildBody(isDark),
    );
  }

  Widget _buildBody(bool isDark) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Color(0xFFDC2626)),
            const SizedBox(height: 16),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF737685)),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadTugasDetail,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003d9b),
                foregroundColor: Colors.white,
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_tugasDetail == null) {
      return const Center(child: Text('Data tidak ditemukan'));
    }

    return RefreshIndicator(
      onRefresh: _loadTugasDetail,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildTugasInfo(isDark),
          const SizedBox(height: 16),
          _buildStatistik(isDark),
          const SizedBox(height: 16),
          _buildPengumpulanList(isDark),
        ],
      ),
    );
  }

  Widget _buildTugasInfo(bool isDark) {
    final deadline = DateTime.parse(_tugasDetail!['deadline']);
    final isOverdue = deadline.isBefore(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _tugasDetail!['mata_kuliah']?['nama_mk'] ?? 'Mata Kuliah',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF003d9b),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isOverdue
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isOverdue ? 'Terlambat' : 'Aktif',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isOverdue
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _tugasDetail!['judul'] ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF191c1e),
            ),
          ),
          if (_tugasDetail!['deskripsi'] != null &&
              _tugasDetail!['deskripsi'].toString().isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              _tugasDetail!['deskripsi'],
              style: TextStyle(
                fontSize: 14,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF737685),
              ),
            ),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF737685),
              ),
              const SizedBox(width: 6),
              Text(
                'Deadline: ${deadline.day}/${deadline.month}/${deadline.year} ${deadline.hour.toString().padLeft(2, '0')}:${deadline.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 13,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
            ],
          ),
          if (_tugasDetail!['file_tugas'] != null) ...[
            const SizedBox(height: 12),
            InkWell(
              onTap: () => _downloadFile(_tugasDetail!['file_tugas']),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF003d9b)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_file,
                      size: 20,
                      color: Color(0xFF003d9b),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _tugasDetail!['file_tugas'].split('/').last,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003d9b),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.download,
                      size: 20,
                      color: Color(0xFF003d9b),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatistik(bool isDark) {
    final totalPengumpulan = _tugasDetail!['pengumpulan']?.length ?? 0;
    final totalMahasiswa = _tugasDetail!['mata_kuliah']?['total_peserta'] ?? 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik Pengumpulan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF191c1e),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Sudah Mengumpulkan',
                  totalPengumpulan.toString(),
                  const Color(0xFF10B981),
                  isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Belum Mengumpulkan',
                  (totalMahasiswa - totalPengumpulan).toString(),
                  const Color(0xFFF59E0B),
                  isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPengumpulanList(bool isDark) {
    final pengumpulan = _tugasDetail!['pengumpulan'] as List? ?? [];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daftar Pengumpulan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF191c1e),
            ),
          ),
          const SizedBox(height: 12),
          if (pengumpulan.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Belum ada mahasiswa yang mengumpulkan',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
              ),
            )
          else
            ...pengumpulan.map((p) => _buildPengumpulanCard(p, isDark)),
        ],
      ),
    );
  }

  Widget _buildPengumpulanCard(Map<String, dynamic> pengumpulan, bool isDark) {
    final submittedAt = DateTime.parse(pengumpulan['created_at']);
    final deadline = DateTime.parse(_tugasDetail!['deadline']);
    final isLate = submittedAt.isAfter(deadline);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  pengumpulan['mahasiswa']?['nama'] ?? 'Mahasiswa',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF191c1e),
                  ),
                ),
              ),
              if (isLate)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Terlambat',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'NIM: ${pengumpulan['mahasiswa']?['nim'] ?? '-'}',
            style: TextStyle(
              fontSize: 12,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 14,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF737685),
              ),
              const SizedBox(width: 4),
              Text(
                'Dikumpulkan: ${submittedAt.day}/${submittedAt.month}/${submittedAt.year} ${submittedAt.hour.toString().padLeft(2, '0')}:${submittedAt.minute.toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
            ],
          ),
          if (pengumpulan['file_pengumpulan'] != null) ...[
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _downloadFile(pengumpulan['file_pengumpulan']),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFF003d9b)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.attach_file,
                      size: 16,
                      color: Color(0xFF003d9b),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        pengumpulan['file_pengumpulan'].split('/').last,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF003d9b),
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.download,
                      size: 16,
                      color: Color(0xFF003d9b),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _downloadFile(String filePath) async {
    final url = await _tugasService.getDownloadUrl(filePath);
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak dapat membuka file'),
            backgroundColor: Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  Future<void> _showDeleteConfirmation(
    BuildContext context,
    bool isDark,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Hapus Tugas',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus tugas ini? Semua pengumpulan mahasiswa juga akan dihapus.',
          style: TextStyle(
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hapus',
              style: TextStyle(color: Color(0xFFDC2626)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
      final success = await tugasProvider.deleteTugas(widget.tugasId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tugas berhasil dihapus'),
              backgroundColor: Color(0xFF10B981),
            ),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(tugasProvider.error ?? 'Gagal menghapus tugas'),
              backgroundColor: const Color(0xFFDC2626),
            ),
          );
        }
      }
    }
  }
}
