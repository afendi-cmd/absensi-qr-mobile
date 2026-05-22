import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../data/services/export_service.dart';
import '../../data/services/storage_service.dart';
import 'package:open_file/open_file.dart';

class ExportDataScreen extends StatefulWidget {
  const ExportDataScreen({super.key});

  @override
  State<ExportDataScreen> createState() => _ExportDataScreenState();
}

class _ExportDataScreenState extends State<ExportDataScreen> {
  late ExportService _exportService;
  bool _isExporting = false;

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

    _exportService = ExportService(dio);
  }

  Future<void> _export(String type) async {
    setState(() => _isExporting = true);

    try {
      String filePath;

      switch (type) {
        case 'mahasiswa':
          filePath = await _exportService.exportMahasiswa();
          break;
        case 'dosen':
          filePath = await _exportService.exportDosen();
          break;
        case 'mata_kuliah':
          filePath = await _exportService.exportMataKuliah();
          break;
        case 'absensi':
          filePath = await _exportService.exportAbsensi();
          break;
        default:
          throw Exception('Tipe export tidak valid');
      }

      setState(() => _isExporting = false);

      if (mounted) {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Export Berhasil'),
            content: Text('File berhasil disimpan di:\n$filePath'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Tutup'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Buka File'),
              ),
            ],
          ),
        );

        if (result == true) {
          await OpenFile.open(filePath);
        }
      }
    } catch (e) {
      setState(() => _isExporting = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  Widget _buildExportCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: _isExporting ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: color.withValues(alpha: 0.2),
                child: Icon(icon, size: 30, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Export Data'), elevation: 0),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Export Data ke CSV',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pilih data yang ingin di-export',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  children: [
                    _buildExportCard(
                      title: 'Data Mahasiswa',
                      description: 'Export semua data mahasiswa',
                      icon: Icons.school,
                      color: Colors.blue,
                      onTap: () => _export('mahasiswa'),
                    ),
                    _buildExportCard(
                      title: 'Data Dosen',
                      description: 'Export semua data dosen',
                      icon: Icons.person,
                      color: Colors.green,
                      onTap: () => _export('dosen'),
                    ),
                    _buildExportCard(
                      title: 'Mata Kuliah',
                      description: 'Export data mata kuliah',
                      icon: Icons.book,
                      color: Colors.orange,
                      onTap: () => _export('mata_kuliah'),
                    ),
                    _buildExportCard(
                      title: 'Data Absensi',
                      description: 'Export riwayat absensi',
                      icon: Icons.check_circle,
                      color: Colors.purple,
                      onTap: () => _export('absensi'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  color: Colors.blue.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'File akan disimpan di folder JAYQ_Exports pada penyimpanan perangkat Anda',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isExporting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Mengexport data...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
