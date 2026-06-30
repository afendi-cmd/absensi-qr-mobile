import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/services/izin_sakit_service.dart';

/// Daftar & tinjauan pengajuan izin/sakit untuk dosen.
class IzinSakitDosenScreen extends StatefulWidget {
  const IzinSakitDosenScreen({super.key});

  @override
  State<IzinSakitDosenScreen> createState() => _IzinSakitDosenScreenState();
}

class _IzinSakitDosenScreenState extends State<IzinSakitDosenScreen> {
  static const _primary = Color(0xFF003d9b);
  final _service = IzinSakitService();

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _list = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final list = await _service.getForDosen();
      setState(() {
        _list = list;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
    ));
  }

  Color _statusColor(String? s) {
    switch (s) {
      case 'disetujui':
        return const Color(0xFF10B981);
      case 'ditolak':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  String _fmt(dynamic raw) {
    if (raw == null) return '-';
    try {
      return DateFormat('d MMM yyyy', 'id_ID')
          .format(DateTime.parse(raw.toString()));
    } catch (_) {
      return raw.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Izin / Sakit Mahasiswa'),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : RefreshIndicator(
              onRefresh: _load,
              color: _primary,
              child: _list.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 140),
                        Center(
                          child: Text(
                              'Belum ada pengajuan untuk mata kuliah Anda.',
                              style: TextStyle(color: Color(0xFF737685))),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _list.length,
                      itemBuilder: (_, i) => _buildCard(_list[i]),
                    ),
            ),
    );
  }

  Widget _buildCard(Map<String, dynamic> z) {
    final mhs = (z['mahasiswa'] ?? {}) as Map<String, dynamic>;
    final mk = (z['mata_kuliah'] ?? {}) as Map<String, dynamic>;
    final jenis = z['jenis']?.toString() ?? '-';
    final status = z['status']?.toString() ?? 'pending';
    final isPending = status == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFe1e2e4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: _primary,
                child: Text(
                  (mhs['nama']?.toString() ?? '?')
                      .substring(0, 1)
                      .toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(mhs['nama']?.toString() ?? '-',
                        style: const TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w600)),
                    Text(
                        '${mhs['nim'] ?? ''} • ${mk['nama_mk'] ?? '-'}',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF737685))),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor(status).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(status,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _statusColor(status))),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(jenis.toUpperCase(),
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: jenis == 'sakit'
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF3B82F6))),
              const SizedBox(width: 8),
              Text(_fmt(z['tanggal']),
                  style: const TextStyle(
                      fontSize: 12, color: Color(0xFF737685))),
            ],
          ),
          const SizedBox(height: 6),
          Text(z['alasan']?.toString() ?? '-',
              style: const TextStyle(fontSize: 14)),
          if (isPending) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _review(z['id'], 'disetujui'),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Setujui'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF10B981),
                        foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _review(z['id'], 'ditolak'),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Tolak'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444))),
                  ),
                ),
              ],
            ),
          ] else if (z['catatan'] != null &&
              z['catatan'].toString().isNotEmpty) ...[
            const Divider(height: 18),
            Text('Catatan: ${z['catatan']}',
                style:
                    const TextStyle(fontSize: 12, color: Color(0xFF737685))),
          ],
        ],
      ),
    );
  }

  Future<void> _review(int id, String status) async {
    final catatanC = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(status == 'disetujui'
            ? 'Setujui Pengajuan'
            : 'Tolak Pengajuan'),
        content: TextField(
          controller: catatanC,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: status == 'ditolak'
                ? 'Alasan penolakan'
                : 'Catatan (opsional)',
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
                backgroundColor: status == 'disetujui'
                    ? const Color(0xFF10B981)
                    : const Color(0xFFEF4444),
                foregroundColor: Colors.white),
            child: const Text('Konfirmasi'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    try {
      await _service.review(
        id: id,
        status: status,
        catatan: catatanC.text.trim().isEmpty ? null : catatanC.text.trim(),
      );
      _snack('Pengajuan ditinjau');
      _load();
    } catch (e) {
      _snack(e.toString().replaceAll('Exception: ', ''), isError: true);
    }
  }
}
