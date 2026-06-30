import 'package:flutter/material.dart';
import '../../data/services/nilai_service.dart';
import '../../data/services/matakuliah_service.dart';

/// Layar input & rekap nilai untuk dosen.
class NilaiDosenScreen extends StatefulWidget {
  const NilaiDosenScreen({super.key});

  @override
  State<NilaiDosenScreen> createState() => _NilaiDosenScreenState();
}

class _NilaiDosenScreenState extends State<NilaiDosenScreen> {
  static const _primary = Color(0xFF003d9b);
  final _nilaiService = NilaiService();
  final _mkService = MataKuliahService();

  bool _loadingMk = true;
  bool _loadingNilai = false;
  String? _error;
  List<Map<String, dynamic>> _mkList = [];
  Map<String, dynamic>? _selectedMk;
  List<Map<String, dynamic>> _nilai = [];

  @override
  void initState() {
    super.initState();
    _loadMk();
  }

  Future<void> _loadMk() async {
    setState(() {
      _loadingMk = true;
      _error = null;
    });
    try {
      final list = await _mkService.getDosenMataKuliah();
      setState(() {
        _mkList = list;
        _selectedMk = list.isNotEmpty ? list.first : null;
        _loadingMk = false;
      });
      if (_selectedMk != null) _loadNilai();
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loadingMk = false;
      });
    }
  }

  Future<void> _loadNilai() async {
    if (_selectedMk == null) return;
    setState(() => _loadingNilai = true);
    try {
      final list = await _nilaiService.getByMataKuliah(_selectedMk!['id']);
      setState(() {
        _nilai = list;
        _loadingNilai = false;
      });
    } catch (e) {
      setState(() => _loadingNilai = false);
      _snack(e.toString().replaceAll('Exception: ', ''), isError: true);
    }
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
    ));
  }

  String _v(dynamic x) => (x == null || x.toString().isEmpty) ? '-' : x.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Input Nilai'),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      floatingActionButton: _selectedMk == null
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _openForm(),
              backgroundColor: _primary,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Input Nilai',
                  style: TextStyle(color: Colors.white)),
            ),
      body: _loadingMk
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _mkList.isEmpty
          ? const Center(child: Text('Anda belum mengampu mata kuliah.'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: _buildMkDropdown(),
                ),
                Expanded(child: _buildNilaiList()),
              ],
            ),
    );
  }

  Widget _buildMkDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFe1e2e4)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Map<String, dynamic>>(
          isExpanded: true,
          value: _selectedMk,
          items: _mkList
              .map((mk) => DropdownMenuItem(
                    value: mk,
                    child: Text('${mk['nama_mk']} (${mk['kode_mk']})',
                        overflow: TextOverflow.ellipsis),
                  ))
              .toList(),
          onChanged: (mk) {
            setState(() => _selectedMk = mk);
            _loadNilai();
          },
        ),
      ),
    );
  }

  Widget _buildNilaiList() {
    if (_loadingNilai) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_nilai.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadNilai,
        color: _primary,
        child: ListView(
          children: const [
            SizedBox(height: 120),
            Center(
              child: Text('Belum ada nilai untuk mata kuliah ini.',
                  style: TextStyle(color: Color(0xFF737685))),
            ),
          ],
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _loadNilai,
      color: _primary,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 90),
        itemCount: _nilai.length,
        itemBuilder: (_, i) => _buildCard(_nilai[i]),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> n) {
    final mhs = (n['mahasiswa'] ?? {}) as Map<String, dynamic>;
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_v(mhs['nama']),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
                    Text(_v(mhs['nim']),
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF737685))),
                  ],
                ),
              ),
              if (n['grade'] != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: _primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text('${n['nilai_akhir']} (${n['grade']})',
                      style: const TextStyle(
                          color: _primary, fontWeight: FontWeight.w700)),
                ),
              IconButton(
                icon: const Icon(Icons.edit, size: 20, color: _primary),
                onPressed: () => _openForm(existing: n),
              ),
            ],
          ),
          Row(
            children: [
              _mini('Tugas', n['nilai_tugas']),
              _mini('UTS', n['nilai_uts']),
              _mini('UAS', n['nilai_uas']),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mini(String label, dynamic v) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 11, color: Color(0xFF737685))),
          Text(_v(v),
              style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  void _openForm({Map<String, dynamic>? existing}) {
    final peserta = List<Map<String, dynamic>>.from(
        (_selectedMk?['peserta'] ?? []) as List);
    if (peserta.isEmpty) {
      _snack('Mata kuliah ini belum memiliki peserta.', isError: true);
      return;
    }

    int? selectedMhsId = existing != null
        ? (existing['mahasiswa_id'] as int?)
        : (peserta.first['id'] as int?);
    final tugasC = TextEditingController(
        text: existing?['nilai_tugas']?.toString() ?? '');
    final utsC =
        TextEditingController(text: existing?['nilai_uts']?.toString() ?? '');
    final uasC =
        TextEditingController(text: existing?['nilai_uas']?.toString() ?? '');
    final catatanC =
        TextEditingController(text: existing?['catatan']?.toString() ?? '');
    bool saving = false;

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(existing != null ? 'Edit Nilai' : 'Input Nilai',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                initialValue: selectedMhsId,
                decoration: const InputDecoration(
                  labelText: 'Mahasiswa',
                  border: OutlineInputBorder(),
                ),
                items: peserta
                    .map((p) => DropdownMenuItem<int>(
                          value: p['id'] as int?,
                          child: Text(p['nama']?.toString() ?? '-',
                              overflow: TextOverflow.ellipsis),
                        ))
                    .toList(),
                onChanged: existing != null
                    ? null
                    : (v) => setSheet(() => selectedMhsId = v),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _numField(tugasC, 'Tugas')),
                  const SizedBox(width: 8),
                  Expanded(child: _numField(utsC, 'UTS')),
                  const SizedBox(width: 8),
                  Expanded(child: _numField(uasC, 'UAS')),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: catatanC,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Catatan (opsional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nilai akhir otomatis: Tugas 30% • UTS 30% • UAS 40%',
                style: TextStyle(fontSize: 11, color: Color(0xFF737685)),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _primary),
                  onPressed: saving
                      ? null
                      : () async {
                          if (selectedMhsId == null) return;
                          setSheet(() => saving = true);
                          try {
                            await _nilaiService.inputNilai(
                              mahasiswaId: selectedMhsId!,
                              mataKuliahId: _selectedMk!['id'],
                              nilaiTugas: num.tryParse(tugasC.text),
                              nilaiUts: num.tryParse(utsC.text),
                              nilaiUas: num.tryParse(uasC.text),
                              catatan: catatanC.text.trim().isEmpty
                                  ? null
                                  : catatanC.text.trim(),
                            );
                            if (ctx.mounted) Navigator.pop(ctx);
                            _snack('Nilai berhasil disimpan');
                            _loadNilai();
                          } catch (e) {
                            setSheet(() => saving = false);
                            _snack(e.toString().replaceAll('Exception: ', ''),
                                isError: true);
                          }
                        },
                  child: saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white))
                      : const Text('Simpan',
                          style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numField(TextEditingController c, String label) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
    );
  }
}
