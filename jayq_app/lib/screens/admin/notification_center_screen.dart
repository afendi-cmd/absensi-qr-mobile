import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/pengumuman_service.dart';
import '../../data/models/pengumuman_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  late PengumumanService _pengumumanService;
  List<PengumumanModel> _pengumumanList = [];
  List<PengumumanModel> _filteredList = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, mahasiswa, dosen

  @override
  void initState() {
    super.initState();
    _initializeService();
    timeago.setLocaleMessages('id', timeago.IdMessages());
  }

  Future<void> _initializeService() async {
    _pengumumanService = PengumumanService();
    await _loadPengumuman();
  }

  Future<void> _loadPengumuman() async {
    setState(() => _isLoading = true);
    try {
      final pengumumans = await _pengumumanService.getPengumuman();
      setState(() {
        _pengumumanList = pengumumans;
        _applyFilter();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat pengumuman: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyFilter() {
    if (_selectedFilter == 'all') {
      _filteredList = _pengumumanList;
    } else if (_selectedFilter == 'mahasiswa') {
      // Hanya tampilkan pengumuman dengan target 'mahasiswa' saja
      _filteredList = _pengumumanList
          .where((p) => p.target == 'mahasiswa')
          .toList();
    } else if (_selectedFilter == 'dosen') {
      // Hanya tampilkan pengumuman dengan target 'dosen' saja
      _filteredList = _pengumumanList
          .where((p) => p.target == 'dosen')
          .toList();
    }

    // Debug log
    debugPrint('Filter: $_selectedFilter');
    debugPrint('Total pengumuman: ${_pengumumanList.length}');
    debugPrint('Filtered pengumuman: ${_filteredList.length}');
    for (var p in _pengumumanList) {
      debugPrint('Pengumuman: ${p.judul} - Target: ${p.target}');
    }
  }

  Future<void> _markAllAsRead() async {
    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        final isDark = themeProvider.isDarkMode;

        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text(
            'Tandai Semua Sebagai Dibaca',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF191C1E),
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'Apakah Anda yakin ingin menandai semua pengumuman sebagai sudah dibaca?',
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text(
                'Tandai Semua',
                style: TextStyle(color: Color(0xFF003D9B)),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      // Show loading
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Menandai semua pengumuman...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // Mark all unread pengumuman as read
      final unreadPengumuman = _pengumumanList.where((p) => !p.isRead).toList();

      try {
        for (final pengumuman in unreadPengumuman) {
          await _pengumumanService.markAsRead(pengumuman.id);
        }

        // Reload list
        await _loadPengumuman();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Berhasil menandai ${unreadPengumuman.length} pengumuman sebagai dibaca',
              ),
              backgroundColor: const Color(0xFF10B981),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal menandai pengumuman: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
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
          'Notifikasi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191C1E),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          if (_pengumumanList.isNotEmpty)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Tandai Semua',
                style: TextStyle(color: Color(0xFF003D9B), fontSize: 14),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter Chips
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  color: isDark ? const Color(0xFF1F2937) : Colors.white,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua', 'all', isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Mahasiswa', 'mahasiswa', isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Dosen', 'dosen', isDark),
                    ],
                  ),
                ),
                // List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _loadPengumuman,
                    child: _filteredList.isEmpty
                        ? _buildEmptyState(isDark)
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _filteredList.length,
                            itemBuilder: (context, index) {
                              final pengumuman = _filteredList[index];
                              return _buildNotificationCard(pengumuman, isDark);
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: isDark ? const Color(0xFF4B5563) : const Color(0xFFD1D5DB),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum Ada Notifikasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Notifikasi pengumuman akan muncul di sini',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark) {
    final isSelected = _selectedFilter == value;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = value;
          _applyFilter();
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF003D9B)
              : (isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF003D9B)
                : (isDark ? const Color(0xFF4B5563) : const Color(0xFFE5E7EB)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280)),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationCard(PengumumanModel pengumuman, bool isDark) {
    final isUrgent = pengumuman.tipe == 'urgent';
    final isPenting = pengumuman.tipe == 'penting';
    final isUnread = !pengumuman.isRead;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnread
              ? const Color(0xFF003D9B)
              : isUrgent
              ? Colors.red.withValues(alpha: 0.3)
              : isPenting
              ? Colors.orange.withValues(alpha: 0.3)
              : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
          width: isUnread ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () async {
            // Mark as read
            try {
              await _pengumumanService.markAsRead(pengumuman.id);
              // Reload list to update read status
              await _loadPengumuman();
            } catch (e) {
              debugPrint('Error marking as read: $e');
            }
            // Show detail
            if (mounted) {
              _showPengumumanDetail(pengumuman, isDark);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isUrgent
                        ? Colors.red.withValues(alpha: 0.1)
                        : isPenting
                        ? Colors.orange.withValues(alpha: 0.1)
                        : const Color(0xFF003D9B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isUrgent
                        ? Icons.warning
                        : isPenting
                        ? Icons.priority_high
                        : Icons.campaign,
                    color: isUrgent
                        ? Colors.red
                        : isPenting
                        ? Colors.orange
                        : const Color(0xFF003D9B),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              pengumuman.judul,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF191C1E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC2626),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isUrgent
                                  ? Colors.red.withValues(alpha: 0.1)
                                  : isPenting
                                  ? Colors.orange.withValues(alpha: 0.1)
                                  : const Color(
                                      0xFF003D9B,
                                    ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              pengumuman.tipe.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: isUrgent
                                    ? Colors.red
                                    : isPenting
                                    ? Colors.orange
                                    : const Color(0xFF003D9B),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: pengumuman.target == 'mahasiswa'
                                  ? const Color(
                                      0xFF3B82F6,
                                    ).withValues(alpha: 0.1)
                                  : pengumuman.target == 'dosen'
                                  ? const Color(
                                      0xFF8B5CF6,
                                    ).withValues(alpha: 0.1)
                                  : const Color(
                                      0xFF10B981,
                                    ).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  pengumuman.target == 'mahasiswa'
                                      ? Icons.school
                                      : pengumuman.target == 'dosen'
                                      ? Icons.person
                                      : Icons.groups,
                                  size: 10,
                                  color: pengumuman.target == 'mahasiswa'
                                      ? const Color(0xFF3B82F6)
                                      : pengumuman.target == 'dosen'
                                      ? const Color(0xFF8B5CF6)
                                      : const Color(0xFF10B981),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  pengumuman.targetLabel,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: pengumuman.target == 'mahasiswa'
                                        ? const Color(0xFF3B82F6)
                                        : pengumuman.target == 'dosen'
                                        ? const Color(0xFF8B5CF6)
                                        : const Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pengumuman.isi,
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280),
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 14,
                            color: isDark
                                ? const Color(0xFF6B7280)
                                : const Color(0xFF9CA3AF),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            timeago.format(pengumuman.createdAt, locale: 'id'),
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFF9CA3AF),
                            ),
                          ),
                          if (pengumuman.creator != null) ...[
                            const SizedBox(width: 12),
                            Icon(
                              Icons.person_outline,
                              size: 14,
                              color: isDark
                                  ? const Color(0xFF6B7280)
                                  : const Color(0xFF9CA3AF),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                pengumuman.creator!.nama,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? const Color(0xFF6B7280)
                                      : const Color(0xFF9CA3AF),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPengumumanDetail(PengumumanModel pengumuman, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF4B5563)
                    : const Color(0xFFD1D5DB),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            pengumuman.judul,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF191C1E),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: pengumuman.tipe == 'urgent'
                                ? Colors.red.withValues(alpha: 0.1)
                                : pengumuman.tipe == 'penting'
                                ? Colors.orange.withValues(alpha: 0.1)
                                : const Color(
                                    0xFF003D9B,
                                  ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            pengumuman.tipe.toUpperCase(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: pengumuman.tipe == 'urgent'
                                  ? Colors.red
                                  : pengumuman.tipe == 'penting'
                                  ? Colors.orange
                                  : const Color(0xFF003D9B),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF6B7280),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          timeago.format(pengumuman.createdAt, locale: 'id'),
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        if (pengumuman.creator != null) ...[
                          const SizedBox(width: 16),
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            pengumuman.creator!.nama,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      pengumuman.isi,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: isDark
                            ? const Color(0xFFD1D5DB)
                            : const Color(0xFF374151),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
