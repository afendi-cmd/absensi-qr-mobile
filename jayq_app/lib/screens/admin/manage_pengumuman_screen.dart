import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/models/pengumuman_model.dart';
import '../../data/services/pengumuman_service.dart';
import '../../data/services/storage_service.dart';
import 'broadcast_pengumuman_screen.dart';

class ManagePengumumanScreen extends StatefulWidget {
  const ManagePengumumanScreen({super.key});

  @override
  State<ManagePengumumanScreen> createState() => _ManagePengumumanScreenState();
}

class _ManagePengumumanScreenState extends State<ManagePengumumanScreen> {
  late PengumumanService _pengumumanService;
  List<Pengumuman> _pengumumanList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    final storageService = StorageService();
    final token = await storageService.getToken();

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';
    dio.options.headers['Accept'] = 'application/json';

    _pengumumanService = PengumumanService(dio);
    _loadPengumuman();
  }

  Future<void> _loadPengumuman() async {
    setState(() => _isLoading = true);
    try {
      final pengumuman = await _pengumumanService.getAdminPengumuman();
      setState(() {
        _pengumumanList = pengumuman;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Future<void> _showFormDialog({Pengumuman? pengumuman}) async {
    final judulController = TextEditingController(
      text: pengumuman?.judul ?? '',
    );
    final isiController = TextEditingController(text: pengumuman?.isi ?? '');
    String selectedTipe = pengumuman?.tipe ?? 'info';
    String selectedTarget = pengumuman?.target ?? 'all';

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(
            pengumuman == null ? 'Tambah Pengumuman' : 'Edit Pengumuman',
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: isiController,
                  decoration: const InputDecoration(
                    labelText: 'Isi Pengumuman',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 5,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTipe,
                  decoration: const InputDecoration(
                    labelText: 'Tipe',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'info', child: Text('Info')),
                    DropdownMenuItem(value: 'penting', child: Text('Penting')),
                    DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedTipe = value!);
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedTarget,
                  decoration: const InputDecoration(
                    labelText: 'Target',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('Semua')),
                    DropdownMenuItem(value: 'dosen', child: Text('Dosen')),
                    DropdownMenuItem(
                      value: 'mahasiswa',
                      child: Text('Mahasiswa'),
                    ),
                  ],
                  onChanged: (value) {
                    setDialogState(() => selectedTarget = value!);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (judulController.text.isEmpty ||
                    isiController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua field harus diisi')),
                  );
                  return;
                }

                try {
                  if (pengumuman == null) {
                    await _pengumumanService.createPengumuman(
                      judul: judulController.text,
                      isi: isiController.text,
                      tipe: selectedTipe,
                      target: selectedTarget,
                    );
                  } else {
                    await _pengumumanService.updatePengumuman(
                      id: pengumuman.id,
                      judul: judulController.text,
                      isi: isiController.text,
                      tipe: selectedTipe,
                      target: selectedTarget,
                    );
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          pengumuman == null
                              ? 'Pengumuman berhasil ditambahkan'
                              : 'Pengumuman berhasil diupdate',
                        ),
                      ),
                    );
                    _loadPengumuman();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('Error: $e')));
                  }
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deletePengumuman(int id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus pengumuman ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _pengumumanService.deletePengumuman(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pengumuman berhasil dihapus')),
          );
          _loadPengumuman();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  Future<void> _toggleActive(int id) async {
    try {
      await _pengumumanService.toggleActive(id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Status berhasil diubah')));
        _loadPengumuman();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Color _getTipeColor(String tipe) {
    switch (tipe) {
      case 'urgent':
        return Colors.red;
      case 'penting':
        return Colors.orange;
      default:
        return Colors.blue;
    }
  }

  IconData _getTipeIcon(String tipe) {
    switch (tipe) {
      case 'urgent':
        return Icons.warning;
      case 'penting':
        return Icons.priority_high;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pengumuman'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.campaign),
            tooltip: 'Broadcast Pengumuman',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BroadcastPengumumanScreen(),
                ),
              );
              if (result == true) {
                _loadPengumuman();
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadPengumuman,
              child: _pengumumanList.isEmpty
                  ? const Center(child: Text('Belum ada pengumuman'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _pengumumanList.length,
                      itemBuilder: (context, index) {
                        final pengumuman = _pengumumanList[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: _getTipeColor(pengumuman.tipe),
                              child: Icon(
                                _getTipeIcon(pengumuman.tipe),
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              pengumuman.judul,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  pengumuman.isi,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Chip(
                                      label: Text(
                                        pengumuman.target.toUpperCase(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      padding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    const SizedBox(width: 8),
                                    Chip(
                                      label: Text(
                                        pengumuman.isActive
                                            ? 'Aktif'
                                            : 'Nonaktif',
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                      backgroundColor: pengumuman.isActive
                                          ? Colors.green.shade100
                                          : Colors.grey.shade300,
                                      padding: EdgeInsets.zero,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton(
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 20),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'toggle',
                                  child: Row(
                                    children: [
                                      Icon(
                                        pengumuman.isActive
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        pengumuman.isActive
                                            ? 'Nonaktifkan'
                                            : 'Aktifkan',
                                      ),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete,
                                        size: 20,
                                        color: Colors.red,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Hapus',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              onSelected: (value) {
                                switch (value) {
                                  case 'edit':
                                    _showFormDialog(pengumuman: pengumuman);
                                    break;
                                  case 'toggle':
                                    _toggleActive(pengumuman.id);
                                    break;
                                  case 'delete':
                                    _deletePengumuman(pengumuman.id);
                                    break;
                                }
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Tambah'),
      ),
    );
  }
}
