import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/storage_service.dart';
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
  List<Pengumuman> _pengumumanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
    timeago.setLocaleMessages('id', timeago.IdMessages());
  }

  Future<void> _initializeService() async {
    final storageService = StorageService();
    final token = await storageService.getToken();

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Accept'] = 'application/json';

    _pengumumanService = PengumumanService(dio);
    await _loadPengumuman();
  }

  Future<void> _loadPengumuman() async {
    setState(() => _isLoading = true);
    try {
      final pengumumans = await _pengumumanService.getPengumuman();
      setState(() {
        _pengumumanList = pengumumans;
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
              onPressed: () {
                // Mark all as read (future feature)
              },
              child: Text(
                'Tandai Semua',
                style: TextStyle(color: const Color(0xFF003D9B), fontSize: 14),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPengumuman,
              child: _pengumumanList.isEmpty
                  ? _buildEmptyState(isDark)
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _pengumumanList.length,
                      itemBuilder: (context, index) {
                        final pengumuman = _pengumumanList[index];
                        return _buildNotificationCard(pengumuman, isDark);
                      },
                    ),
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

  Widget _buildNotificationCard(Pengumuman pengumuman, bool isDark) {
    final isUrgent = pengumuman.tipe == 'urgent';
    final isPenting = pengumuman.tipe == 'penting';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent
              ? Colors.red.withValues(alpha: 0.3)
              : isPenting
              ? Colors.orange.withValues(alpha: 0.3)
              : (isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB)),
          width: 1.5,
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
            await _pengumumanService.markAsRead(pengumuman.id);
            // Show detail
            _showPengumumanDetail(pengumuman, isDark);
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
                                fontWeight: FontWeight.w600,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF191C1E),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
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

  void _showPengumumanDetail(Pengumuman pengumuman, bool isDark) {
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
