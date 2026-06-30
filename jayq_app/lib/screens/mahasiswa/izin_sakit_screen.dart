import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import '../../data/services/izin_sakit_service.dart';
import '../../data/services/matakuliah_service.dart';

/// Pengajuan & daftar izin/sakit untuk mahasiswa.
class IzinSakitScreen extends StatefulWidget {
  const IzinSakitScreen({super.key});

  @override
  State<IzinSakitScreen> createState() => _IzinSakitScreenState();
}

class _IzinSakitScreenState extends State<IzinSakitScreen> {
  static const _primary = Color(0xFF003d9b);
  final _service = IzinSakitService();
  final _mkService = MataKuliahService();

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
      final list = await _service.getMine();
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
        title: const Text('Izin / Sakit'),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openForm,
        backgroundColor: _primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajukan', style: TextStyle(color: Colors.white)),
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
                          child: Text('Belum ada pengajuan.',
                              style: TextStyle(color: Color(0xFF737685))),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                      itemCount: _list.length,
                      itemBuilder: (_, i) => _buildCard(_list[i]),
                    ),
            ),
    );
  }

  Widget _buildCard(Map<String, dynamic> z) {
    final mk = (z['mata_kuliah'] ?? {}) as Map<String, dynamic>;
    final jenis = z['jenis']?.toString() ?? '-';
    final status = z['status']?.toString() ?? 'pending';
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: (jenis == 'sakit'
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF3B82F6))
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(jenis.toUpperCase(),
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: jenis == 'sakit'
                            ? const Color(0xFFEF4444)
                            : const Color(0xFF3B82F6))),
              ),
              const Spacer(),
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
          Text(z['alasan']?.toString() ?? '-',
              style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 6),
          Text('${_fmt(z['tanggal'])} • ${mk['nama_mk'] ?? 'Umum'}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF737685))),
          if (z['catatan'] != null &&
              z['catatan'].toString().isNotEmpty) ...[
            const Divider(height: 18),
            Text('Catatan dosen: ${z['catatan']}',
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFF737685))),
          ],
        ],
      ),
    );
  }

  Future<void> _openForm() async {
    List<Map<String, dynamic>> mkList = [];
    try {
      mkList = await _mkService.getMahasiswaMataKuliah();
    } catch (_) {}

    String jenis = 'izin';
    DateTime tanggal = DateTime.now();
    int? mataKuliahId;
    final alasanC = TextEditingController();
    String? filePath;
    String? fileName;
    bool saving = false;

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Ajukan Izin / Sakit',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: jenis,
                  decoration: const InputDecoration(
                      labelText: 'Jenis', border: OutlineInputBorder()),
                  items: const [
                    DropdownMenuItem(value: 'izin', child: Text('Izin')),
                    DropdownMenuItem(value: 'sakit', child: Text('Sakit')),
                  ],
                  onChanged: (v) => setSheet(() => jenis = v ?? 'izin'),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: tanggal,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setSheet(() => tanggal = picked);
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                        labelText: 'Tanggal', border: OutlineInputBorder()),
                    child: Text(DateFormat('d MMM yyyy').format(tanggal)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int?>(
                  initialValue: mataKuliahId,
                  isExpanded: true,
                  decoration: const InputDecoration(
                      labelText: 'Mata Kuliah (opsional)',
                      border: OutlineInputBorder()),
                  items: [
                    const DropdownMenuItem<int?>(
                        value: null, child: Text('Umum')),
                    ...mkList.map((mk) => DropdownMenuItem<int?>(
                          value: mk['id'] as int?,
                          child: Text(mk['nama_mk']?.toString() ?? '-',
                              overflow: TextOverflow.ellipsis),
                        )),
                  ],
                  onChanged: (v) => setSheet(() => mataKuliahId = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: alasanC,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Alasan', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles(
                      type: FileType.custom,
                      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                    );
                    if (result != null &&
                        result.files.single.path != null) {
                      setSheet(() {
                        filePath = result.files.single.path;
                        fileName = result.files.single.name;
                      });
                    }
                  },
                  icon: const Icon(Icons.attach_file, color: _primary),
                  label: Text(fileName ?? 'Lampirkan Surat (opsional)',
                      style: const TextStyle(color: _primary),
                      overflow: TextOverflow.ellipsis),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: _primary),
                    minimumSize: const Size(double.infinity, 48),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: _primary),
                    onPressed: saving
                        ? null
                        : () async {
                            if (alasanC.text.trim().isEmpty) {
                              _snack('Alasan wajib diisi', isError: true);
                              return;
                            }
                            setSheet(() => saving = true);
                            try {
                              await _service.ajukan(
                                mataKuliahId: mataKuliahId,
                                tanggal: DateFormat('yyyy-MM-dd')
                                    .format(tanggal),
                                jenis: jenis,
                                alasan: alasanC.text.trim(),
                                filePath: filePath,
                              );
                              if (ctx.mounted) Navigator.pop(ctx);
                              _snack('Pengajuan terkirim');
                              _load();
                            } catch (e) {
                              setSheet(() => saving = false);
                              _snack(
                                  e.toString().replaceAll('Exception: ', ''),
                                  isError: true);
                            }
                          },
                    child: saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('Kirim',
                            style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
