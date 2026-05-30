import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/models/tugas_model.dart';
import '../../data/models/materi_model.dart';
import '../../data/services/tugas_service.dart';
import '../../data/services/materi_service.dart';
import 'tugas_detail_screen.dart';
import 'materi_detail_screen.dart';

class TugasMateriScreen extends StatefulWidget {
  const TugasMateriScreen({super.key});

  @override
  State<TugasMateriScreen> createState() => _TugasMateriScreenState();
}

class _TugasMateriScreenState extends State<TugasMateriScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _tugasService = TugasService();
  final _materiService = MateriService();

  List<TugasModel> _tugasList = [];
  List<MateriModel> _materiList = [];
  bool _isLoadingTugas = false;
  bool _isLoadingMateri = false;
  String? _errorTugas;
  String? _errorMateri;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    _loadTugas();
    _loadMateri();
  }

  Future<void> _loadTugas() async {
    setState(() {
      _isLoadingTugas = true;
      _errorTugas = null;
    });

    try {
      final tugas = await _tugasService.getTugasMahasiswa();
      setState(() {
        _tugasList = tugas;
        _isLoadingTugas = false;
      });
    } catch (e) {
      setState(() {
        _errorTugas = e.toString();
        _isLoadingTugas = false;
      });
    }
  }

  Future<void> _loadMateri() async {
    setState(() {
      _isLoadingMateri = true;
      _errorMateri = null;
    });

    try {
      final materi = await _materiService.getMateriMahasiswa();
      setState(() {
        _materiList = materi;
        _isLoadingMateri = false;
      });
    } catch (e) {
      setState(() {
        _errorMateri = e.toString();
        _isLoadingMateri = false;
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
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              color: isDark ? const Color(0xFF1F2937) : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tugas & Materi',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF003d9b),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tab Bar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFF8F9FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFF003d9b),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Tugas'),
                        Tab(text: 'Materi'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Tab View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [_buildTugasTab(), _buildMateriTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTugasTab() {
    if (_isLoadingTugas) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorTugas != null) {
      return _buildErrorState(_errorTugas!, _loadTugas);
    }

    if (_tugasList.isEmpty) {
      return _buildEmptyState(
        icon: Icons.assignment_outlined,
        message: 'Tidak ada tugas',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadTugas,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tugasList.length,
        itemBuilder: (context, index) {
          final tugas = _tugasList[index];
          return _buildTugasCard(tugas);
        },
      ),
    );
  }

  Widget _buildMateriTab() {
    if (_isLoadingMateri) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMateri != null) {
      return _buildErrorState(_errorMateri!, _loadMateri);
    }

    if (_materiList.isEmpty) {
      return _buildEmptyState(
        icon: Icons.book_outlined,
        message: 'Tidak ada materi',
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMateri,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _materiList.length,
        itemBuilder: (context, index) {
          final materi = _materiList[index];
          return _buildMateriCard(materi);
        },
      ),
    );
  }

  Widget _buildTugasCard(TugasModel tugas) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    Color statusColor;
    Color statusBgColor;

    if (tugas.sudahDikumpulkan) {
      statusColor = const Color(0xFF10B981);
      statusBgColor = const Color(0xFFD1FAE5);
    } else if (tugas.isOverdue) {
      statusColor = const Color(0xFFDC2626);
      statusBgColor = const Color(0xFFFEE2E2);
    } else {
      statusColor = const Color(0xFFF59E0B);
      statusBgColor = const Color(0xFFFEF3C7);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
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
        onTap: () => _navigateToTugasDetail(tugas),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Text(
                      tugas.mataKuliah?.namaMk ?? 'Mata Kuliah',
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
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tugas.statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              Text(
                tugas.judul,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (tugas.deskripsi != null) ...[
                const SizedBox(height: 8),
                Text(
                  tugas.deskripsi!,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),

              // Footer
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: tugas.isOverdue
                        ? const Color(0xFFDC2626)
                        : (isDark
                              ? const Color(0xFF9CA3AF)
                              : const Color(0xFF737685)),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Deadline: ${tugas.formattedDeadline}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: tugas.isOverdue
                          ? const Color(0xFFDC2626)
                          : (isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF737685)),
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

  Widget _buildMateriCard(MateriModel materi) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4),
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
        onTap: () => _navigateToMateriDetail(materi),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // File Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF003d9b).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.description,
                  color: Color(0xFF003d9b),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      materi.mataKuliah?.namaMk ?? 'Mata Kuliah',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF003d9b),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      materi.judul,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF191c1e),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      materi.formattedDate,
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

              // File Type Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFF8F9FB),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF4B5563)
                        : const Color(0xFFe1e2e4),
                  ),
                ),
                child: Text(
                  materi.fileExtension,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, VoidCallback onRetry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Color(0xFFDC2626)),
          const SizedBox(height: 16),
          Text(
            error,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF737685)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onRetry,
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

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Color(0xFF737685)),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToTugasDetail(TugasModel tugas) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TugasDetailScreen(tugas: tugas)),
    );

    // Reload if tugas was submitted
    if (result == true) {
      _loadTugas();
    }
  }

  Future<void> _navigateToMateriDetail(MateriModel materi) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MateriDetailScreen(materi: materi),
      ),
    );
  }
}
