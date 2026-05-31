import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/theme_provider.dart';
import '../../data/models/pengumuman_model.dart';
import '../../data/services/pengumuman_service.dart';

class PengumumanDetailScreen extends StatefulWidget {
  final PengumumanModel pengumuman;

  const PengumumanDetailScreen({super.key, required this.pengumuman});

  @override
  State<PengumumanDetailScreen> createState() => _PengumumanDetailScreenState();
}

class _PengumumanDetailScreenState extends State<PengumumanDetailScreen> {
  final _pengumumanService = PengumumanService();
  bool _isMarking = false;

  @override
  void initState() {
    super.initState();
    // Mark as read when opening detail
    if (!widget.pengumuman.isRead) {
      _markAsRead();
    }
  }

  Future<void> _markAsRead() async {
    if (_isMarking) return;

    setState(() => _isMarking = true);

    try {
      await _pengumumanService.markAsRead(widget.pengumuman.id);
      // Don't modify local state - let the parent reload from server
    } catch (e) {
      // Silent fail, not critical
      debugPrint('Error marking as read: $e');
    } finally {
      setState(() => _isMarking = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    Color tipeColor;
    IconData tipeIcon;

    switch (widget.pengumuman.tipe) {
      case 'urgent':
        tipeColor = const Color(0xFFDC2626);
        tipeIcon = Icons.warning;
        break;
      case 'penting':
        tipeColor = const Color(0xFFF59E0B);
        tipeIcon = Icons.priority_high;
        break;
      default:
        tipeColor = const Color(0xFF3B82F6);
        tipeIcon = Icons.info;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _closeScreen();
        }
      },
      child: Scaffold(
        backgroundColor: isDark
            ? const Color(0xFF111827)
            : const Color(0xFFF8F9FB),
        appBar: AppBar(
          title: Text(
            'Detail Pengumuman',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF003d9b),
            ),
          ),
          backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _closeScreen,
          ),
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
                    colors: [tipeColor, tipeColor.withValues(alpha: 0.8)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: tipeColor.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(tipeIcon, size: 16, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            widget.pengumuman.tipeLabel.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title
                    Text(
                      widget.pengumuman.judul,
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
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.2 : 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMetaRow(
                      icon: Icons.person_outline,
                      label: 'Dibuat oleh',
                      value: widget.pengumuman.creator?.nama ?? 'Admin',
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
                      label: 'Tanggal',
                      value: DateFormat(
                        'EEEE, d MMMM yyyy',
                      ).format(widget.pengumuman.createdAt),
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
                      label: 'Waktu',
                      value: DateFormat(
                        'HH:mm',
                      ).format(widget.pengumuman.createdAt),
                      isDark: isDark,
                    ),
                    Divider(
                      height: 24,
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFE5E7EB),
                    ),
                    _buildMetaRow(
                      icon: Icons.group_outlined,
                      label: 'Target',
                      value: widget.pengumuman.targetLabel,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Content Card
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
                      'Isi Pengumuman',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF191c1e),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.pengumuman.isi,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? const Color(0xFFD1D5DB)
                            : const Color(0xFF191c1e),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
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
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _closeScreen() {
    // Return true to indicate pengumuman was read
    Navigator.of(context).pop(true);
  }
}
