import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../data/models/mata_kuliah.dart';
import 'attendance_detail_screen.dart';

class AdminScheduleScreen extends StatefulWidget {
  const AdminScheduleScreen({super.key});

  @override
  State<AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends State<AdminScheduleScreen> {
  String _searchQuery = '';
  String? _selectedSemester;
  int? _selectedDosenId;
  String _sortBy = 'nama'; // nama, kode, sks

  @override
  void initState() {
    super.initState();
    // Load mata kuliah saat screen dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dashboardProvider = Provider.of<DashboardProvider>(
        context,
        listen: false,
      );
      dashboardProvider.loadAllMataKuliah();
      dashboardProvider.loadAllUsers();
    });
  }

  List<MataKuliah> _filterAndSortMataKuliah(List<MataKuliah> mataKuliahList) {
    var filtered = mataKuliahList.where((mk) {
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchName = mk.namaMk.toLowerCase().contains(query);
        final matchCode = mk.kodeMk.toLowerCase().contains(query);
        final matchDosen =
            mk.dosen?.nama.toLowerCase().contains(query) ?? false;
        if (!matchName && !matchCode && !matchDosen) return false;
      }

      // Filter by semester
      if (_selectedSemester != null && mk.semester != _selectedSemester) {
        return false;
      }

      // Filter by dosen
      if (_selectedDosenId != null && mk.dosenId != _selectedDosenId) {
        return false;
      }

      return true;
    }).toList();

    // Sort
    filtered.sort((a, b) {
      switch (_sortBy) {
        case 'kode':
          return a.kodeMk.compareTo(b.kodeMk);
        case 'sks':
          return b.sks.compareTo(a.sks);
        case 'nama':
        default:
          return a.namaMk.compareTo(b.namaMk);
      }
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            _buildSearchBar(isDark),
            _buildFilterChips(isDark),
            Expanded(
              child: Consumer<DashboardProvider>(
                builder: (context, dashboardProvider, child) {
                  if (dashboardProvider.isLoadingMataKuliah) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final allMataKuliah = dashboardProvider.allMataKuliah;
                  final filteredMataKuliah = _filterAndSortMataKuliah(
                    allMataKuliah,
                  );

                  if (allMataKuliah.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 64,
                            color: isDark
                                ? const Color(0xFF4B5563)
                                : const Color(0xFFD1D5DB),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Belum ada jadwal kuliah',
                            style: TextStyle(
                              fontSize: 16,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (filteredMataKuliah.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: isDark
                                ? const Color(0xFF4B5563)
                                : const Color(0xFFD1D5DB),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Tidak ada hasil',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Coba ubah filter atau kata kunci',
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

                  return _buildScheduleList(filteredMataKuliah, isDark);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Jadwal Kuliah',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              _showAddEditDialog(isDark);
            },
            icon: Icon(
              Icons.add_circle_outline,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
            ),
          ),
          IconButton(
            onPressed: () {
              _showSortDialog(isDark);
            },
            icon: Icon(
              Icons.sort,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
            ),
          ),
          IconButton(
            onPressed: () {
              _showFilterDialog(isDark);
            },
            icon: Icon(
              Icons.filter_list,
              color: isDark ? Colors.white : const Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari mata kuliah, kode, atau dosen...',
          hintStyle: TextStyle(
            color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDark
                        ? const Color(0xFF6B7280)
                        : const Color(0xFF9CA3AF),
                  ),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 2),
          ),
        ),
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF111827),
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (_selectedSemester != null || _selectedDosenId != null) ...[
            Chip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Filter Aktif',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.close, size: 16, color: Colors.white),
                ],
              ),
              backgroundColor: const Color(0xFF2563EB),
              onDeleted: () {
                setState(() {
                  _selectedSemester = null;
                  _selectedDosenId = null;
                });
              },
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  if (_selectedSemester != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        label: Text('Semester $_selectedSemester'),
                        backgroundColor: isDark
                            ? const Color(0xFF1F2937)
                            : const Color(0xFFE0E7FF),
                        labelStyle: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  if (_selectedDosenId != null)
                    Consumer<DashboardProvider>(
                      builder: (context, provider, child) {
                        final dosen = provider.allUsers.firstWhere(
                          (u) => u.id == _selectedDosenId,
                          orElse: () => provider.allUsers.first,
                        );
                        return Chip(
                          label: Text(dosen.name),
                          backgroundColor: isDark
                              ? const Color(0xFF1F2937)
                              : const Color(0xFFE0E7FF),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: const Color(0xFF2563EB),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSortDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Urutkan Berdasarkan',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOption('Nama Mata Kuliah', 'nama', isDark),
            _buildSortOption('Kode Mata Kuliah', 'kode', isDark),
            _buildSortOption('Jumlah SKS', 'sks', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSortOption(String label, String value, bool isDark) {
    return RadioListTile<String>(
      title: Text(
        label,
        style: TextStyle(
          color: isDark ? Colors.white : const Color(0xFF111827),
        ),
      ),
      value: value,
      groupValue: _sortBy,
      activeColor: const Color(0xFF2563EB),
      onChanged: (val) {
        setState(() {
          _sortBy = val!;
        });
        Navigator.pop(context);
      },
    );
  }

  void _showFilterDialog(bool isDark) {
    showDialog(
      context: context,
      builder: (context) => Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          // Get unique semesters from data
          final uniqueSemesters =
              provider.allMataKuliah.map((mk) => mk.semester).toSet().toList()
                ..sort();

          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
            title: Text(
              'Filter Jadwal',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Semester',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (uniqueSemesters.isEmpty)
                    Text(
                      'Belum ada data semester',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? const Color(0xFF6B7280)
                            : const Color(0xFF9CA3AF),
                      ),
                    )
                  else
                    Wrap(
                      spacing: 8,
                      children: uniqueSemesters.map((semester) {
                        final isSelected = _selectedSemester == semester;
                        return FilterChip(
                          label: Text('Sem $semester'),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedSemester = selected ? semester : null;
                            });
                            Navigator.pop(context);
                          },
                          backgroundColor: isDark
                              ? const Color(0xFF374151)
                              : Colors.white,
                          selectedColor: const Color(0xFF2563EB),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? Colors.white
                                      : const Color(0xFF111827)),
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 16),
                  Text(
                    'Dosen Pengajar',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Builder(
                    builder: (context) {
                      final dosenList = provider.allUsers
                          .where((u) => u.role == 'dosen')
                          .toList();

                      if (dosenList.isEmpty) {
                        return Text(
                          'Belum ada dosen',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? const Color(0xFF6B7280)
                                : const Color(0xFF9CA3AF),
                          ),
                        );
                      }

                      return Column(
                        children: dosenList.map((dosen) {
                          final isSelected = _selectedDosenId == dosen.id;
                          return CheckboxListTile(
                            title: Text(
                              dosen.name,
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF111827),
                              ),
                            ),
                            value: isSelected,
                            activeColor: const Color(0xFF2563EB),
                            onChanged: (selected) {
                              setState(() {
                                _selectedDosenId = selected! ? dosen.id : null;
                              });
                              Navigator.pop(context);
                            },
                            contentPadding: EdgeInsets.zero,
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedSemester = null;
                    _selectedDosenId = null;
                  });
                  Navigator.pop(context);
                },
                child: const Text('Reset'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Tutup'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScheduleList(List<MataKuliah> mataKuliahList, bool isDark) {
    return RefreshIndicator(
      onRefresh: () async {
        final dashboardProvider = Provider.of<DashboardProvider>(
          context,
          listen: false,
        );
        await dashboardProvider.loadAllMataKuliah();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: mataKuliahList.length,
        itemBuilder: (context, index) {
          final mataKuliah = mataKuliahList[index];
          return _buildScheduleCard(mataKuliah, isDark);
        },
      ),
    );
  }

  Widget _buildScheduleCard(MataKuliah mataKuliah, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showScheduleDetail(mataKuliah, isDark);
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mataKuliah.namaMk,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF111827),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF065F46)
                            : const Color(0xFFD1FAE5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Aktif',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF10B981),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  mataKuliah.kodeMk,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      mataKuliah.dosen?.nama ?? 'Belum ada dosen',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 16,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '${mataKuliah.sks} SKS • Semester ${mataKuliah.semester}',
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScheduleDetail(MataKuliah mataKuliah, bool isDark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1F2937) : Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              mataKuliah.namaMk,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(Icons.qr_code, 'Kode', mataKuliah.kodeMk, isDark),
            _buildDetailRow(
              Icons.person_outline,
              'Dosen',
              mataKuliah.dosen?.nama ?? 'Belum ada dosen',
              isDark,
            ),
            _buildDetailRow(
              Icons.school_outlined,
              'SKS',
              '${mataKuliah.sks} SKS',
              isDark,
            ),
            _buildDetailRow(
              Icons.calendar_today,
              'Semester',
              'Semester ${mataKuliah.semester}',
              isDark,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _showAddEditDialog(isDark, mataKuliah: mataKuliah);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Color(0xFF2563EB)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigate to attendance detail screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AttendanceDetailScreen(mataKuliah: mataKuliah),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Lihat Presensi'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmDelete(mataKuliah, isDark);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Hapus Mata Kuliah',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showAddEditDialog(bool isDark, {MataKuliah? mataKuliah}) {
    final isEdit = mataKuliah != null;
    final namaMkController = TextEditingController(
      text: mataKuliah?.namaMk ?? '',
    );
    final kodeMkController = TextEditingController(
      text: mataKuliah?.kodeMk ?? '',
    );
    int selectedSks = mataKuliah?.sks ?? 2;
    String selectedSemester = mataKuliah?.semester ?? '1';
    int? selectedDosenId = mataKuliah?.dosenId;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          title: Text(
            isEdit ? 'Edit Mata Kuliah' : 'Tambah Mata Kuliah',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: namaMkController,
                  decoration: InputDecoration(
                    labelText: 'Nama Mata Kuliah',
                    labelStyle: TextStyle(
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: kodeMkController,
                  decoration: InputDecoration(
                    labelText: 'Kode Mata Kuliah',
                    labelStyle: TextStyle(
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: selectedSks,
                  decoration: const InputDecoration(
                    labelText: 'SKS',
                    border: OutlineInputBorder(),
                  ),
                  dropdownColor: isDark
                      ? const Color(0xFF1F2937)
                      : Colors.white,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  items: List.generate(6, (index) {
                    final sks = index + 1;
                    return DropdownMenuItem(
                      value: sks,
                      child: Text('$sks SKS'),
                    );
                  }),
                  onChanged: (value) {
                    setDialogState(() => selectedSks = value!);
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: selectedSemester),
                  decoration: InputDecoration(
                    labelText: 'Semester',
                    hintText: 'Contoh: Ganjil 2024/2025 atau 1',
                    hintStyle: const TextStyle(fontSize: 12),
                    labelStyle: TextStyle(
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  onChanged: (value) {
                    selectedSemester = value;
                  },
                ),
                const SizedBox(height: 16),
                Consumer<DashboardProvider>(
                  builder: (context, provider, child) {
                    final dosenList = provider.allUsers
                        .where((u) => u.role == 'dosen')
                        .toList();

                    return DropdownButtonFormField<int>(
                      value: selectedDosenId,
                      decoration: const InputDecoration(
                        labelText: 'Dosen Pengajar',
                        border: OutlineInputBorder(),
                      ),
                      dropdownColor: isDark
                          ? const Color(0xFF1F2937)
                          : Colors.white,
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                      items: dosenList.map((dosen) {
                        return DropdownMenuItem(
                          value: dosen.id,
                          child: Text(dosen.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setDialogState(() => selectedDosenId = value);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Batal',
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF6B7280),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Validasi input
                if (namaMkController.text.isEmpty ||
                    kodeMkController.text.isEmpty ||
                    selectedSemester.isEmpty ||
                    selectedDosenId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }

                // Simpan context dan navigator sebelum async
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);

                // Tutup dialog
                navigator.pop();

                final dashboardProvider = Provider.of<DashboardProvider>(
                  context,
                  listen: false,
                );

                try {
                  if (isEdit) {
                    await dashboardProvider.updateMataKuliah(
                      mataKuliah.id,
                      namaMkController.text,
                      kodeMkController.text,
                      selectedSks,
                      selectedSemester,
                      selectedDosenId!,
                    );
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Mata kuliah berhasil diupdate'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  } else {
                    await dashboardProvider.createMataKuliah(
                      namaMkController.text,
                      kodeMkController.text,
                      selectedSks,
                      selectedSemester,
                      selectedDosenId!,
                    );
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text('Mata kuliah berhasil ditambahkan'),
                        backgroundColor: Color(0xFF10B981),
                      ),
                    );
                  }
                } catch (e) {
                  // Extract clean error message
                  final errorMessage = e.toString().replaceAll(
                    'Exception: ',
                    '',
                  );
                  scaffoldMessenger.showSnackBar(
                    SnackBar(
                      content: Text(errorMessage),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
              ),
              child: Text(isEdit ? 'Update' : 'Tambah'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(MataKuliah mataKuliah, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Konfirmasi Hapus',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        content: Text(
          'Yakin ingin menghapus mata kuliah "${mataKuliah.namaMk}"?\n\nSemua data terkait akan ikut terhapus.',
          style: TextStyle(
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              // Simpan context sebelum async
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);

              // Tutup dialog
              navigator.pop();

              final dashboardProvider = Provider.of<DashboardProvider>(
                context,
                listen: false,
              );

              try {
                await dashboardProvider.deleteMataKuliah(mataKuliah.id);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Mata kuliah berhasil dihapus'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              } catch (e) {
                // Extract clean error message
                final errorMessage = e.toString().replaceAll('Exception: ', '');
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 4),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
          ),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
