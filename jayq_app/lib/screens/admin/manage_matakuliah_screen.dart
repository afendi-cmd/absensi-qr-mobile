import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/matakuliah_service.dart';
import '../../data/services/user_service.dart';

class ManageMataKuliahScreen extends StatefulWidget {
  const ManageMataKuliahScreen({super.key});

  @override
  State<ManageMataKuliahScreen> createState() => _ManageMataKuliahScreenState();
}

class _ManageMataKuliahScreenState extends State<ManageMataKuliahScreen> {
  final MataKuliahService _mataKuliahService = MataKuliahService();
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allMataKuliah = [];
  List<Map<String, dynamic>> _filteredMataKuliah = [];
  List<Map<String, dynamic>> _allDosen = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterMataKuliah);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final mataKuliah = await _mataKuliahService.getMataKuliah();
      final dosen = await _userService.getUsers(role: 'dosen');
      setState(() {
        _allMataKuliah = mataKuliah;
        _filteredMataKuliah = mataKuliah;
        _allDosen = dosen;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterMataKuliah() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMataKuliah = _allMataKuliah.where((mk) {
        final nama = (mk['nama_mk'] ?? '').toString().toLowerCase();
        final kode = (mk['kode_mk'] ?? '').toString().toLowerCase();
        return nama.contains(query) || kode.contains(query);
      }).toList();
    });
  }

  void _showAddDialog(bool isDark) {
    final namaMkController = TextEditingController();
    final kodeMkController = TextEditingController();
    int? selectedDosenId;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          title: Text(
            'Tambah Mata Kuliah',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaMkController,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nama Mata Kuliah',
                      labelStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF59E0B)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama mata kuliah tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: kodeMkController,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Kode Mata Kuliah',
                      labelStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF59E0B)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kode mata kuliah tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedDosenId,
                    dropdownColor: isDark
                        ? const Color(0xFF374151)
                        : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Dosen Pengampu',
                      labelStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF59E0B)),
                      ),
                    ),
                    items: _allDosen.map((dosen) {
                      return DropdownMenuItem<int>(
                        value: dosen['id'],
                        child: Text(dosen['nama'] ?? '-'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDosenId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih dosen pengampu';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  try {
                    await _mataKuliahService.createMataKuliah({
                      'nama_mk': namaMkController.text,
                      'kode_mk': kodeMkController.text,
                      'dosen_id': selectedDosenId,
                    });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mata kuliah berhasil ditambahkan'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    }
                    _loadData();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal menambahkan mata kuliah: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> mataKuliah, bool isDark) {
    final namaMkController = TextEditingController(text: mataKuliah['nama_mk']);
    final kodeMkController = TextEditingController(text: mataKuliah['kode_mk']);
    int? selectedDosenId = mataKuliah['dosen_id'];
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
          title: Text(
            'Edit Mata Kuliah',
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaMkController,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Nama Mata Kuliah',
                      labelStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF59E0B)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama mata kuliah tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: kodeMkController,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Kode Mata Kuliah',
                      labelStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF59E0B)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Kode mata kuliah tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedDosenId,
                    dropdownColor: isDark
                        ? const Color(0xFF374151)
                        : Colors.white,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      labelText: 'Dosen Pengampu',
                      labelStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: isDark
                              ? const Color(0xFF374151)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF59E0B)),
                      ),
                    ),
                    items: _allDosen.map((dosen) {
                      return DropdownMenuItem<int>(
                        value: dosen['id'],
                        child: Text(dosen['nama'] ?? '-'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDosenId = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Pilih dosen pengampu';
                      }
                      return null;
                    },
                  ),
                ],
              ),
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
                if (formKey.currentState!.validate()) {
                  Navigator.pop(context);
                  try {
                    await _mataKuliahService
                        .updateMataKuliah(mataKuliah['id'], {
                          'nama_mk': namaMkController.text,
                          'kode_mk': kodeMkController.text,
                          'dosen_id': selectedDosenId,
                        });
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mata kuliah berhasil diupdate'),
                          backgroundColor: Color(0xFF10B981),
                        ),
                      );
                    }
                    _loadData();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Gagal mengupdate mata kuliah: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF59E0B),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> mataKuliah, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Hapus Mata Kuliah',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${mataKuliah['nama_mk']}?',
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
              Navigator.pop(context);
              try {
                await _mataKuliahService.deleteMataKuliah(mataKuliah['id']);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Mata kuliah berhasil dihapus'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                }
                _loadData();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menghapus mata kuliah: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDetailBottomSheet(Map<String, dynamic> mataKuliah, bool isDark) {
    final dosen = _allDosen.firstWhere(
      (d) => d['id'] == mataKuliah['dosen_id'],
      orElse: () => {'nama': 'Tidak ditemukan'},
    );

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Mata Kuliah',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('ID', mataKuliah['id'].toString(), isDark),
            _buildDetailRow('Nama', mataKuliah['nama_mk'] ?? '-', isDark),
            _buildDetailRow('Kode', mataKuliah['kode_mk'] ?? '-', isDark),
            _buildDetailRow('Dosen', dosen['nama'] ?? '-', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark
                    ? const Color(0xFF9CA3AF)
                    : const Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    final totalMataKuliah = _allMataKuliah.length;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kelola Mata Kuliah',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: isDark ? Colors.white : const Color(0xFF1F2937),
            ),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: isDark
                        ? const Color(0xFF9CA3AF)
                        : const Color(0xFF6B7280),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage,
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                    ),
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1F2937) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Mata Kuliah',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$totalMataKuliah',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF1F2937),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari mata kuliah...',
                      hintStyle: TextStyle(
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF6B7280),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? const Color(0xFF1F2937)
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // List
                  _filteredMataKuliah.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Tidak ada data mata kuliah',
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFF9CA3AF)
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredMataKuliah.length,
                          itemBuilder: (context, index) {
                            final mataKuliah = _filteredMataKuliah[index];
                            final dosen = _allDosen.firstWhere(
                              (d) => d['id'] == mataKuliah['dosen_id'],
                              orElse: () => {'nama': 'Tidak ditemukan'},
                            );

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF1F2937)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFFF59E0B,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.book,
                                    color: Color(0xFFF59E0B),
                                  ),
                                ),
                                title: Text(
                                  mataKuliah['nama_mk'] ?? '-',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1F2937),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 4),
                                    Text(
                                      'Kode: ${mataKuliah['kode_mk'] ?? '-'}',
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFF9CA3AF)
                                            : const Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Dosen: ${dosen['nama'] ?? '-'}',
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFF9CA3AF)
                                            : const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  icon: Icon(
                                    Icons.more_vert,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1F2937),
                                  ),
                                  color: isDark
                                      ? const Color(0xFF374151)
                                      : Colors.white,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.visibility,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Text(
                                            'Detail',
                                            style: TextStyle(
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF1F2937),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () => _showDetailBottomSheet(
                                            mataKuliah,
                                            isDark,
                                          ),
                                        );
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Color(0xFFF59E0B),
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Edit',
                                            style: TextStyle(
                                              color: Color(0xFFF59E0B),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () => _showEditDialog(
                                            mataKuliah,
                                            isDark,
                                          ),
                                        );
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 12),
                                          Text(
                                            'Hapus',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () => _showDeleteDialog(
                                            mataKuliah,
                                            isDark,
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(isDark),
        backgroundColor: const Color(0xFFF59E0B),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
