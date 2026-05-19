import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/services/user_service.dart';

class ManageDosenScreen extends StatefulWidget {
  const ManageDosenScreen({super.key});

  @override
  State<ManageDosenScreen> createState() => _ManageDosenScreenState();
}

class _ManageDosenScreenState extends State<ManageDosenScreen> {
  final UserService _userService = UserService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _allDosen = [];
  List<Map<String, dynamic>> _filteredDosen = [];
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterDosen);
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
      final dosen = await _userService.getUsers(role: 'dosen');
      setState(() {
        _allDosen = dosen;
        _filteredDosen = dosen;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterDosen() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDosen = _allDosen.where((dosen) {
        final nama = (dosen['nama'] ?? '').toString().toLowerCase();
        final email = (dosen['email'] ?? '').toString().toLowerCase();
        return nama.contains(query) || email.contains(query);
      }).toList();
    });
  }

  void _showAddDialog(bool isDark) {
    final namaController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Tambah Dosen',
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
                  controller: namaController,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nama',
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
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
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
                  await _userService.createUser({
                    'nama': namaController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                    'role': 'dosen',
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dosen berhasil ditambahkan'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                  _loadData();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal menambahkan dosen: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(Map<String, dynamic> dosen, bool isDark) {
    final namaController = TextEditingController(text: dosen['nama']);
    final emailController = TextEditingController(text: dosen['email']);
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Edit Dosen',
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
                  controller: namaController,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Nama',
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
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  style: TextStyle(
                    color: isDark ? Colors.white : const Color(0xFF1F2937),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password (kosongkan jika tidak diubah)',
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
                      borderSide: BorderSide(color: Color(0xFF2563EB)),
                    ),
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 6) {
                      return 'Password minimal 6 karakter';
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
                  final updateData = {
                    'nama': namaController.text,
                    'email': emailController.text,
                    'role': 'dosen',
                  };
                  if (passwordController.text.isNotEmpty) {
                    updateData['password'] = passwordController.text;
                  }
                  await _userService.updateUser(dosen['id'], updateData);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dosen berhasil diupdate'),
                      backgroundColor: Color(0xFF10B981),
                    ),
                  );
                  _loadData();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Gagal mengupdate dosen: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
            ),
            child: const Text('Simpan', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> dosen, bool isDark) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Hapus Dosen',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1F2937),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${dosen['nama']}?',
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
                await _userService.deleteUser(dosen['id']);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dosen berhasil dihapus'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
                _loadData();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal menghapus dosen: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDetailBottomSheet(Map<String, dynamic> dosen, bool isDark) {
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
              'Detail Dosen',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 20),
            _buildDetailRow('ID', dosen['id'].toString(), isDark),
            _buildDetailRow('Nama', dosen['nama'] ?? '-', isDark),
            _buildDetailRow('Email', dosen['email'] ?? '-', isDark),
            _buildDetailRow('Role', dosen['role'] ?? '-', isDark),
            _buildDetailRow(
              'Status',
              dosen['is_active'] == 1 ? 'Aktif' : 'Tidak Aktif',
              isDark,
            ),
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

    final totalDosen = _allDosen.length;
    final aktiveDosen = _allDosen.where((d) => d['is_active'] == 1).length;

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
          'Kelola Dosen',
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
                      backgroundColor: const Color(0xFF2563EB),
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
                  // Stats Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1F2937)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Dosen',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$totalDosen',
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
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1F2937)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Aktif',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? const Color(0xFF9CA3AF)
                                      : const Color(0xFF6B7280),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$aktiveDosen',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2563EB),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: isDark ? Colors.white : const Color(0xFF1F2937),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Cari dosen...',
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
                  _filteredDosen.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Text(
                              'Tidak ada data dosen',
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
                          itemCount: _filteredDosen.length,
                          itemBuilder: (context, index) {
                            final dosen = _filteredDosen[index];
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
                                      0xFF2563EB,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                                title: Text(
                                  dosen['nama'] ?? '-',
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
                                      dosen['email'] ?? '-',
                                      style: TextStyle(
                                        color: isDark
                                            ? const Color(0xFF9CA3AF)
                                            : const Color(0xFF6B7280),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: dosen['is_active'] == 1
                                            ? const Color(
                                                0xFF10B981,
                                              ).withValues(alpha: 0.1)
                                            : Colors.grey.withValues(
                                                alpha: 0.1,
                                              ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        dosen['is_active'] == 1
                                            ? 'Aktif'
                                            : 'Tidak Aktif',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: dosen['is_active'] == 1
                                              ? const Color(0xFF10B981)
                                              : Colors.grey,
                                        ),
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
                                            dosen,
                                            isDark,
                                          ),
                                        );
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Color(0xFF2563EB),
                                          ),
                                          const SizedBox(width: 12),
                                          const Text(
                                            'Edit',
                                            style: TextStyle(
                                              color: Color(0xFF2563EB),
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        Future.delayed(
                                          const Duration(milliseconds: 100),
                                          () => _showEditDialog(dosen, isDark),
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
                                          () =>
                                              _showDeleteDialog(dosen, isDark),
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
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
