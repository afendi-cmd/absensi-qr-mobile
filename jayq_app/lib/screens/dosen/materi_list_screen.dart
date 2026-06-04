import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../providers/theme_provider.dart';
import '../../providers/materi_provider.dart';
import '../../providers/dashboard_dosen_provider.dart';

class MateriListScreen extends StatefulWidget {
  const MateriListScreen({super.key});

  @override
  State<MateriListScreen> createState() => _MateriListScreenState();
}

class _MateriListScreenState extends State<MateriListScreen> {
  int? _selectedMataKuliahId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMateri();
    });
  }

  Future<void> _loadMateri() async {
    final materiProvider = Provider.of<MateriProvider>(context, listen: false);
    await materiProvider.loadMateri(mataKuliahId: _selectedMataKuliahId);
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
          _buildFilterSection(isDark),
          Expanded(child: _buildMateriList(isDark)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showUploadDialog(isDark),
        backgroundColor: const Color(0xFF003d9b),
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload Materi'),
      ),
    );
  }

  Widget _buildFilterSection(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      child: Consumer<DashboardDosenProvider>(
        builder: (context, provider, child) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FB),
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
                dropdownColor: isDark ? const Color(0xFF1F2937) : Colors.white,
                items: [
                  DropdownMenuItem<int>(
                    value: null,
                    child: Text(
                      'Semua Mata Kuliah',
                      style: TextStyle(
                        color: isDark ? Colors.white : const Color(0xFF191c1e),
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
                  _loadMateri();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMateriList(bool isDark) {
    return Consumer<MateriProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.error != null) {
          return _buildErrorState(provider.error!, isDark);
        }

        if (provider.materiList.isEmpty) {
          return _buildEmptyState(isDark);
        }

        return RefreshIndicator(
          onRefresh: _loadMateri,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.materiList.length,
            itemBuilder: (context, index) {
              return _buildMateriCard(provider.materiList[index], isDark);
            },
          ),
        );
      },
    );
  }

  Widget _buildErrorState(String error, bool isDark) {
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
            onPressed: _loadMateri,
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

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.folder_outlined,
            size: 80,
            color: isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB),
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada materi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload materi untuk mahasiswa',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF6B7280) : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMateriCard(Map<String, dynamic> materi, bool isDark) {
    final createdAt = DateTime.parse(materi['created_at']);

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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    materi['mata_kuliah']?['nama_mk'] ?? 'Mata Kuliah',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003d9b),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    materi['judul'] ?? '',
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
                    '${createdAt.day}/${createdAt.month}/${createdAt.year}',
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
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.download, size: 20),
                  color: const Color(0xFF003d9b),
                  onPressed: () => _downloadMateri(materi),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, size: 20),
                  color: const Color(0xFFDC2626),
                  onPressed: () => _deleteMateri(materi['id'], isDark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _downloadMateri(Map<String, dynamic> materi) async {
    final materiProvider = Provider.of<MateriProvider>(context, listen: false);
    final url = await materiProvider.getDownloadUrl(materi['file_materi']);
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

  Future<void> _deleteMateri(int materiId, bool isDark) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Hapus Materi',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus materi ini?',
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
      final materiProvider = Provider.of<MateriProvider>(
        context,
        listen: false,
      );
      final success = await materiProvider.deleteMateri(materiId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Materi berhasil dihapus'
                  : (materiProvider.error ?? 'Gagal menghapus materi'),
            ),
            backgroundColor: success
                ? const Color(0xFF10B981)
                : const Color(0xFFDC2626),
          ),
        );
      }
    }
  }

  Future<void> _showUploadDialog(bool isDark) async {
    final formKey = GlobalKey<FormState>();
    final judulController = TextEditingController();
    final deskripsiController = TextEditingController();
    int? selectedMataKuliahId;
    File? selectedFile;
    bool isSubmitting = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
            title: Text(
              'Upload Materi',
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF191c1e),
              ),
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMataKuliahDropdown(
                      isDark,
                      selectedMataKuliahId,
                      (value) =>
                          setDialogState(() => selectedMataKuliahId = value),
                    ),
                    const SizedBox(height: 16),
                    _buildJudulField(isDark, judulController),
                    const SizedBox(height: 16),
                    _buildDeskripsiField(isDark, deskripsiController),
                    const SizedBox(height: 16),
                    _buildFilePicker(
                      isDark,
                      selectedFile,
                      (file) => setDialogState(() => selectedFile = file),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSubmitting ? null : () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              TextButton(
                onPressed: isSubmitting
                    ? null
                    : () => _submitUpload(
                        formKey,
                        selectedMataKuliahId,
                        judulController,
                        deskripsiController,
                        selectedFile,
                        setDialogState,
                        () => isSubmitting = true,
                      ),
                child: isSubmitting
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Upload'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMataKuliahDropdown(
    bool isDark,
    int? value,
    Function(int?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mata Kuliah *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        const SizedBox(height: 8),
        Consumer<DashboardDosenProvider>(
          builder: (context, provider, child) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF111827)
                    : const Color(0xFFF8F9FB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFe1e2e4),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: value,
                  hint: Text(
                    'Pilih Mata Kuliah',
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  ),
                  dropdownColor: isDark
                      ? const Color(0xFF1F2937)
                      : Colors.white,
                  items: provider.mataKuliahList.map((mk) {
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
                  }).toList(),
                  onChanged: onChanged,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildJudulField(bool isDark, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Judul Materi *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
          decoration: InputDecoration(
            hintText: 'Masukkan judul materi',
            hintStyle: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF111827)
                : const Color(0xFFF8F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFe1e2e4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFe1e2e4),
              ),
            ),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Judul harus diisi' : null,
        ),
      ],
    );
  }

  Widget _buildDeskripsiField(bool isDark, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deskripsi',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Masukkan deskripsi (opsional)',
            hintStyle: TextStyle(
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
            filled: true,
            fillColor: isDark
                ? const Color(0xFF111827)
                : const Color(0xFFF8F9FB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFe1e2e4),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFe1e2e4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker(bool isDark, File? file, Function(File?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'File Materi *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF191c1e),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            try {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
              );
              if (result != null && result.files.single.path != null) {
                onChanged(File(result.files.single.path!));
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error memilih file: $e'),
                  backgroundColor: const Color(0xFFDC2626),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF111827) : const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: file != null
                    ? const Color(0xFF003d9b)
                    : (isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFe1e2e4)),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  file != null ? Icons.check_circle : Icons.upload_file,
                  color: file != null
                      ? const Color(0xFF10B981)
                      : (isDark
                            ? const Color(0xFF9CA3AF)
                            : const Color(0xFF737685)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    file != null
                        ? file.path.split('\\').last
                        : 'Pilih file (PDF, DOC, PPT)',
                    style: TextStyle(
                      fontSize: 13,
                      color: file != null
                          ? (isDark ? Colors.white : const Color(0xFF191c1e))
                          : (isDark
                                ? const Color(0xFF9CA3AF)
                                : const Color(0xFF737685)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _submitUpload(
    GlobalKey<FormState> formKey,
    int? mataKuliahId,
    TextEditingController judulController,
    TextEditingController deskripsiController,
    File? file,
    Function setDialogState,
    Function setSubmitting,
  ) async {
    if (!formKey.currentState!.validate()) return;

    if (mataKuliahId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih mata kuliah terlebih dahulu'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    if (file == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih file terlebih dahulu'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    setSubmitting();

    try {
      final materiProvider = Provider.of<MateriProvider>(
        context,
        listen: false,
      );
      await materiProvider.uploadMateri(
        mataKuliahId: mataKuliahId,
        judul: judulController.text,
        deskripsi: deskripsiController.text.isEmpty
            ? null
            : deskripsiController.text,
        filePath: file.path,
      );

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Materi berhasil diupload'),
            backgroundColor: Color(0xFF10B981),
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
}
