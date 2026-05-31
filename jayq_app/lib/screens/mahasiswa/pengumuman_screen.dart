import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/models/pengumuman_model.dart';
import '../../data/services/pengumuman_service.dart';
import 'pengumuman_detail_screen.dart';

class PengumumanScreen extends StatefulWidget {
  const PengumumanScreen({super.key});

  @override
  State<PengumumanScreen> createState() => _PengumumanScreenState();
}

class _PengumumanScreenState extends State<PengumumanScreen> {
  final _pengumumanService = PengumumanService();

  List<PengumumanModel> _pengumumanList = [];
  List<PengumumanModel> _filteredList = [];
  bool _isLoading = false;
  String? _error;
  String _selectedFilter = 'all'; // all, unread, info, penting, urgent
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final pengumuman = await _pengumumanService.getPengumuman();
      final unreadData = await _pengumumanService.getUnreadCount();

      setState(() {
        _pengumumanList = pengumuman;
        _filteredList = pengumuman;
        _unreadCount = unreadData['unread_count'] ?? 0;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;

      if (filter == 'all') {
        _filteredList = _pengumumanList;
      } else if (filter == 'unread') {
        _filteredList = _pengumumanList.where((p) => !p.isRead).toList();
      } else {
        _filteredList = _pengumumanList.where((p) => p.tipe == filter).toList();
      }
    });
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
            'Tandai Semua Sudah Dibaca?',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF191c1e),
            ),
          ),
          content: Text(
            'Semua pengumuman yang belum dibaca akan ditandai sebagai sudah dibaca.',
            style: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
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
                      : const Color(0xFF737685),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003d9b),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Tandai Semua'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      // Mark all as read
      await _pengumumanService.markAllAsRead();

      // Reload data
      await _loadData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$_unreadCount pengumuman ditandai sudah dibaca'),
            backgroundColor: const Color(0xFF10B981),
          ),
        );
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
        title: Text(
          'Pengumuman',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF003d9b),
          ),
        ),
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF003d9b),
        elevation: 0,
        actions: [
          if (_unreadCount > 0) ...[
            // Badge Unread Count
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$_unreadCount Baru',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Mark All as Read Button
            IconButton(
              icon: const Icon(Icons.done_all),
              tooltip: 'Tandai Semua Sudah Dibaca',
              onPressed: _markAllAsRead,
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          // Filter Chips Container
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('Semua', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Belum Dibaca', 'unread'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Info', 'info'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Penting', 'penting'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Urgent', 'urgent'),
                ],
              ),
            ),
          ),

          // Content
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    final isSelected = _selectedFilter == value;

    return InkWell(
      onTap: () => _applyFilter(value),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF003d9b)
              : (isDark ? const Color(0xFF374151) : const Color(0xFFF8F9FB)),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF003d9b)
                : (isDark ? const Color(0xFF4B5563) : const Color(0xFFe1e2e4)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685)),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF003d9b),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Color(0xFFDC2626),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF003d9b),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    if (_filteredList.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadData,
        color: const Color(0xFF003d9b),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 300,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none,
                    size: 64,
                    color: isDark ? const Color(0xFF374151) : Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _selectedFilter == 'unread'
                        ? 'Tidak ada pengumuman baru'
                        : 'Tidak ada pengumuman',
                    style: TextStyle(
                      fontSize: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      color: const Color(0xFF003d9b),
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: _filteredList.length,
        itemBuilder: (context, index) {
          final pengumuman = _filteredList[index];
          return _buildPengumumanCard(pengumuman);
        },
      ),
    );
  }

  Widget _buildPengumumanCard(PengumumanModel pengumuman) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    Color tipeColor;
    Color tipeBgColor;
    IconData tipeIcon;

    switch (pengumuman.tipe) {
      case 'urgent':
        tipeColor = const Color(0xFFDC2626);
        tipeBgColor = const Color(0xFFFEE2E2);
        tipeIcon = Icons.warning;
        break;
      case 'penting':
        tipeColor = const Color(0xFFF59E0B);
        tipeBgColor = const Color(0xFFFEF3C7);
        tipeIcon = Icons.priority_high;
        break;
      default:
        tipeColor = const Color(0xFF3B82F6);
        tipeBgColor = const Color(0xFFDBEAFE);
        tipeIcon = Icons.info;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: pengumuman.isRead
              ? (isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4))
              : const Color(0xFF003d9b),
          width: pengumuman.isRead ? 1 : 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _navigateToDetail(pengumuman),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: tipeBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(tipeIcon, size: 14, color: tipeColor),
                        const SizedBox(width: 4),
                        Text(
                          pengumuman.tipeLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: tipeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (!pengumuman.isRead)
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
              const SizedBox(height: 12),

              // Title
              Text(
                pengumuman.judul,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: pengumuman.isRead
                      ? FontWeight.w500
                      : FontWeight.w700,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Content Preview
              Text(
                pengumuman.isi,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: isDark ? const Color(0xFF6B7280) : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    pengumuman.creator?.nama ?? 'Admin',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF6B7280)
                          : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.access_time,
                    size: 14,
                    color: isDark ? const Color(0xFF6B7280) : Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    pengumuman.formattedDate,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? const Color(0xFF6B7280)
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToDetail(PengumumanModel pengumuman) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PengumumanDetailScreen(pengumuman: pengumuman),
      ),
    );

    // Reload if marked as read
    if (result == true) {
      _loadData();
    }
  }
}
