import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/tugas_provider.dart';
import '../../providers/dashboard_dosen_provider.dart';
import 'create_tugas_screen.dart';
import 'tugas_detail_dosen_screen.dart';

class TugasListScreen extends StatefulWidget {
  const TugasListScreen({super.key});

  @override
  State<TugasListScreen> createState() => _TugasListScreenState();
}

class _TugasListScreenState extends State<TugasListScreen> {
  String _filterStatus = 'all';
  int? _selectedMataKuliahId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTugas();
    });
  }

  Future<void> _loadTugas() async {
    final tugasProvider = Provider.of<TugasProvider>(context, listen: false);
    await tugasProvider.loadTugas(mataKuliahId: _selectedMataKuliahId);
  }

  List<Map<String, dynamic>> _getFilteredTugas(
    List<Map<String, dynamic>> tugas,
  ) {
    if (_filterStatus == 'all') return tugas;

    final now = DateTime.now();
    return tugas.where((t) {
      final deadline = DateTime.parse(t['deadline']);
      final isOverdue = deadline.isBefore(now);

      switch (_filterStatus) {
        case 'aktif':
          return !isOverdue;
        case 'selesai':
          return false; // TODO: implement completed status
        case 'overdue':
          return isOverdue;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      body: Column(
        children: [
          // Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            child: Column(
              children: [
                // Mata Kuliah Filter
                Consumer<DashboardDosenProvider>(
                  builder: (context, provider, child) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF111827)
                            : const Color(0xFFF8F9FB),
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
                            'Semua Mata Kuliah',
                            style: TextStyle(
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF737685),
                            ),
                          ),
                          dropdownColor: isDark
                              ? const Color(0xFF1F2937)
                              : Colors.white,
                          items: [
                            DropdownMenuItem<int>(
                              value: null,
                              child: Text(
                                'Semua Mata Kuliah',
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF191c1e),
                                ),
                              ),
                            ),
                            ...provider.mataKuliahList.map((mk) {
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
                            }),
                          ],
                          onChanged: (value) {
                            setState(() => _selectedMataKuliahId = value);
                            _loadTugas();
                          },
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),

                // Status Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('Semua', 'all', isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Aktif', 'aktif', isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Selesai', 'selesai', isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Terlambat', 'overdue', isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Tugas List
          Expanded(
            child: Consumer<TugasProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.error != null) {
                  return Center(
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
                          provider.error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF737685)),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadTugas,
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

                final filteredTugas = _getFilteredTugas(provider.tugasList);

                if (filteredTugas.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 80,
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFE5E7EB),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Belum ada tugas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Buat tugas baru untuk mahasiswa',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFF6B7280)
                                : const Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadTugas,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredTugas.length,
                    itemBuilder: (context, index) {
                      final tugas = filteredTugas[index];
                      return _buildTugasCard(tugas, isDark);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          if (_selectedMataKuliahId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Silakan pilih mata kuliah terlebih dahulu'),
                backgroundColor: Color(0xFFF59E0B),
              ),
            );
            return;
          }
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateTugasScreen(mataKuliahId: _selectedMataKuliahId!),
            ),
          );
          if (result == true) {
            _loadTugas();
          }
        },
        backgroundColor: const Color(0xFF003d9b),
        icon: const Icon(Icons.add),
        label: const Text('Buat Tugas'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, bool isDark) {
    final isSelected = _filterStatus == value;
    return InkWell(
      onTap: () => setState(() => _filterStatus = value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF003d9b)
              : (isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FB)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF003d9b)
                : (isDark ? const Color(0xFF374151) : const Color(0xFFe1e2e4)),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : (isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685)),
          ),
        ),
      ),
    );
  }

  Widget _buildTugasCard(Map<String, dynamic> tugas, bool isDark) {
    final deadline = DateTime.parse(tugas['deadline']);
    final isOverdue = deadline.isBefore(DateTime.now());
    final totalPengumpulan = tugas['total_pengumpulan'] ?? 0;

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
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TugasDetailDosenScreen(tugasId: tugas['id']),
            ),
          );
          if (result == true) {
            _loadTugas();
          }
        },
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
                      tugas['mata_kuliah']?['nama_mk'] ?? 'Mata Kuliah',
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

              // Title
              Text(
                tugas['judul'] ?? '',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF191c1e),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Footer
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
                    'Deadline: ${deadline.day}/${deadline.month}/${deadline.year}',
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.people_outline,
                    size: 16,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF737685),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$totalPengumpulan dikumpulkan',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
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
      ),
    );
  }
}
