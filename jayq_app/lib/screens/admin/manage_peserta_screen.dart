import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/peserta_mk_provider.dart';
import '../../providers/theme_provider.dart';
import '../../data/models/peserta_mk_model.dart';
import '../../data/models/user_model.dart';
import '../../data/models/mata_kuliah_model.dart';

class ManagePesertaScreen extends StatefulWidget {
  const ManagePesertaScreen({super.key});

  @override
  State<ManagePesertaScreen> createState() => _ManagePesertaScreenState();
}

class _ManagePesertaScreenState extends State<ManagePesertaScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PesertaMkProvider>(context, listen: false);
      provider.loadMataKuliah();
      provider.loadMahasiswa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kelola Peserta Mata Kuliah',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Consumer<PesertaMkProvider>(
            builder: (context, provider, child) {
              if (provider.selectedMataKuliah != null) {
                return IconButton(
                  icon: Icon(
                    Icons.person_add,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  onPressed: () => _showAddPesertaDialog(context, isDark),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<PesertaMkProvider>(
        builder: (context, provider, child) {
          if (provider.error != null) {
            return _buildErrorState(provider.error!, isDark);
          }

          return Column(
            children: [
              _buildMataKuliahSelector(provider, isDark),
              Expanded(
                child: provider.selectedMataKuliah == null
                    ? _buildEmptyState(isDark)
                    : _buildPesertaList(provider, isDark),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMataKuliahSelector(PesertaMkProvider provider, bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pilih Mata Kuliah',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 12),
          if (provider.isLoadingMataKuliah)
            const Center(child: CircularProgressIndicator())
          else if (provider.mataKuliahList.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFE5E7EB),
                ),
              ),
              child: Text(
                'Tidak ada mata kuliah tersedia',
                style: TextStyle(
                  color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
                ),
              ),
            )
          else
            DropdownButtonFormField<MataKuliahModel>(
              value:
                  provider.selectedMataKuliah != null &&
                      provider.mataKuliahList.contains(
                        provider.selectedMataKuliah,
                      )
                  ? provider.selectedMataKuliah
                  : null,
              decoration: InputDecoration(
                hintText: 'Pilih mata kuliah...',
                hintStyle: TextStyle(
                  color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: isDark
                        ? const Color(0xFF374151)
                        : const Color(0xFFE5E7EB),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2563EB)),
                ),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFF9FAFB),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
                isDense: true,
              ),
              dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
              style: TextStyle(
                color: isDark ? Colors.white : const Color(0xFF111827),
                fontSize: 14,
              ),
              isExpanded: true,
              items: provider.mataKuliahList.map((mataKuliah) {
                return DropdownMenuItem<MataKuliahModel>(
                  value: mataKuliah,
                  child: Text(
                    '${mataKuliah.namaMk} (${mataKuliah.kodeMk} • ${mataKuliah.sks} SKS)',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                );
              }).toList(),
              onChanged: (mataKuliah) {
                if (mataKuliah != null) {
                  provider.selectMataKuliah(mataKuliah);
                }
              },
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
            Icons.school_outlined,
            size: 64,
            color: isDark ? const Color(0xFF6B7280) : Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Pilih Mata Kuliah',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih mata kuliah untuk melihat\ndan mengelola peserta',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? const Color(0xFF6B7280) : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPesertaList(PesertaMkProvider provider, bool isDark) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.pesertaList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.groups_outlined,
              size: 64,
              color: isDark ? const Color(0xFF6B7280) : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Peserta',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan mahasiswa ke mata kuliah ini',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFF6B7280) : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddPesertaDialog(context, isDark),
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                'Tambah Peserta',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1F2937) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.groups, color: const Color(0xFF2563EB), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.selectedMataKuliah!.namaMk,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    Text(
                      '${provider.pesertaList.length} Peserta Terdaftar',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? const Color(0xFF9CA3AF)
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${provider.selectedMataKuliah!.sks} SKS',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: provider.pesertaList.length,
            itemBuilder: (context, index) {
              final peserta = provider.pesertaList[index];
              return _buildPesertaCard(peserta, provider, isDark);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPesertaCard(
    PesertaMk peserta,
    PesertaMkProvider provider,
    bool isDark,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.person, color: Color(0xFF2563EB), size: 24),
        ),
        title: Text(
          peserta.mahasiswa?.name ?? 'Unknown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              peserta.mahasiswa?.email ?? '',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Bergabung: ${_formatDate(peserta.createdAt)}',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? const Color(0xFF6B7280) : Colors.grey[500],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.remove_circle_outline, color: Colors.red[400]),
          onPressed: () =>
              _showRemovePesertaDialog(context, peserta, provider, isDark),
        ),
      ),
    );
  }

  Widget _buildErrorState(String error, bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
          const SizedBox(height: 16),
          Text(
            'Terjadi Kesalahan',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final provider = Provider.of<PesertaMkProvider>(
                context,
                listen: false,
              );
              provider.clearError();
              provider.loadMataKuliah();
              provider.loadMahasiswa();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Coba Lagi',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddPesertaDialog(BuildContext context, bool isDark) {
    final provider = Provider.of<PesertaMkProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) =>
          _AddPesertaDialog(provider: provider, isDark: isDark),
    );
  }

  void _showRemovePesertaDialog(
    BuildContext context,
    PesertaMk peserta,
    PesertaMkProvider provider,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1F2937) : Colors.white,
        title: Text(
          'Hapus Peserta',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF111827),
          ),
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${peserta.mahasiswa?.name} dari mata kuliah ini?',
          style: TextStyle(
            color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(
                color: isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await provider.removePeserta(peserta);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${peserta.mahasiswa?.name} berhasil dihapus',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } else if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(provider.error ?? 'Gagal menghapus peserta'),
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _AddPesertaDialog extends StatefulWidget {
  final PesertaMkProvider provider;
  final bool isDark;

  const _AddPesertaDialog({required this.provider, required this.isDark});

  @override
  State<_AddPesertaDialog> createState() => _AddPesertaDialogState();
}

class _AddPesertaDialogState extends State<_AddPesertaDialog> {
  UserModel? selectedMahasiswa;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final availableMahasiswa = widget.provider.availableMahasiswa;

    return AlertDialog(
      backgroundColor: widget.isDark ? const Color(0xFF1F2937) : Colors.white,
      title: Text(
        'Tambah Peserta',
        style: TextStyle(
          color: widget.isDark ? Colors.white : const Color(0xFF111827),
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Mahasiswa:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: widget.isDark ? Colors.white : const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 8),
            if (availableMahasiswa.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.orange[700],
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Semua mahasiswa sudah terdaftar di mata kuliah ini',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange[700],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              DropdownButtonFormField<UserModel>(
                value:
                    selectedMahasiswa != null &&
                        availableMahasiswa.contains(selectedMahasiswa)
                    ? selectedMahasiswa
                    : null,
                decoration: InputDecoration(
                  hintText: 'Pilih mahasiswa...',
                  hintStyle: TextStyle(
                    color: widget.isDark
                        ? const Color(0xFF9CA3AF)
                        : Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: widget.isDark
                          ? const Color(0xFF374151)
                          : const Color(0xFFE5E7EB),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2563EB)),
                  ),
                  filled: true,
                  fillColor: widget.isDark
                      ? const Color(0xFF374151)
                      : const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  isDense: true,
                ),
                dropdownColor: widget.isDark
                    ? const Color(0xFF374151)
                    : Colors.white,
                style: TextStyle(
                  color: widget.isDark ? Colors.white : const Color(0xFF111827),
                  fontSize: 14,
                ),
                isExpanded: true,
                items: availableMahasiswa.map((mahasiswa) {
                  return DropdownMenuItem<UserModel>(
                    value: mahasiswa,
                    child: Text(
                      '${mahasiswa.name} (${mahasiswa.email})',
                      style: TextStyle(
                        fontSize: 14,
                        color: widget.isDark
                            ? Colors.white
                            : const Color(0xFF111827),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  );
                }).toList(),
                onChanged: (mahasiswa) {
                  setState(() {
                    selectedMahasiswa = mahasiswa;
                  });
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'Batal',
            style: TextStyle(
              color: widget.isDark ? const Color(0xFF9CA3AF) : Colors.grey[600],
            ),
          ),
        ),
        ElevatedButton(
          onPressed:
              (isLoading ||
                  selectedMahasiswa == null ||
                  availableMahasiswa.isEmpty)
              ? null
              : () async {
                  setState(() {
                    isLoading = true;
                  });

                  final success = await widget.provider.addPeserta(
                    selectedMahasiswa!,
                  );

                  if (context.mounted) {
                    Navigator.pop(context);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${selectedMahasiswa!.name} berhasil ditambahkan',
                          ),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            widget.provider.error ??
                                'Gagal menambahkan peserta',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Tambah', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
