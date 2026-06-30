import 'package:flutter/material.dart';
import '../../data/services/nilai_service.dart';

/// Transkrip nilai mahasiswa (IPK, total SKS, daftar nilai per mata kuliah).
class NilaiScreen extends StatefulWidget {
  const NilaiScreen({super.key});

  @override
  State<NilaiScreen> createState() => _NilaiScreenState();
}

class _NilaiScreenState extends State<NilaiScreen> {
  static const _primary = Color(0xFF003d9b);
  final _service = NilaiService();

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _nilai = [];
  dynamic _ipk;
  int _totalSks = 0;

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
      final data = await _service.getMine();
      setState(() {
        _nilai = List<Map<String, dynamic>>.from(data['nilai'] ?? []);
        _ipk = data['ipk'];
        _totalSks = (data['total_sks'] ?? 0) as int;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  String _v(dynamic x) => (x == null || x.toString().isEmpty) ? '-' : x.toString();

  Color _gradeColor(String? g) {
    switch (g) {
      case 'A':
        return const Color(0xFF10B981);
      case 'B':
        return const Color(0xFF3B82F6);
      case 'C':
        return const Color(0xFFF59E0B);
      case 'D':
        return const Color(0xFFF97316);
      default:
        return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Nilai & Transkrip'),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? _buildError()
          : RefreshIndicator(
              onRefresh: _load,
              color: _primary,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                children: [
                  _buildSummary(),
                  const SizedBox(height: 20),
                  if (_nilai.isEmpty)
                    _buildEmpty()
                  else
                    ..._nilai.map(_buildNilaiCard),
                ],
              ),
            ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF003d9b), Color(0xFF0052cc)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('IPK',
                    style: TextStyle(color: Color(0xFFc4d2ff), fontSize: 14)),
                const SizedBox(height: 6),
                Text(
                  _ipk == null ? '-' : _ipk.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$_totalSks SKS',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('${_nilai.length} mata kuliah dinilai',
                  style: const TextStyle(color: Color(0xFFc4d2ff), fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNilaiCard(Map<String, dynamic> n) {
    final mk = (n['mata_kuliah'] ?? {}) as Map<String, dynamic>;
    final grade = n['grade'] as String?;
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
                    Text(_v(mk['nama_mk']),
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${_v(mk['kode_mk'])} • ${_v(mk['sks'])} SKS',
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF737685))),
                  ],
                ),
              ),
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _gradeColor(grade).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(grade ?? '-',
                    style: TextStyle(
                        color: _gradeColor(grade),
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _miniScore('Tugas', n['nilai_tugas']),
              _miniScore('UTS', n['nilai_uts']),
              _miniScore('UAS', n['nilai_uas']),
              _miniScore('Akhir', n['nilai_akhir'], highlight: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _miniScore(String label, dynamic value, {bool highlight = false}) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF737685))),
        const SizedBox(height: 4),
        Text(_v(value),
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: highlight ? _primary : const Color(0xFF191c1e))),
      ],
    );
  }

  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.all(40),
      alignment: Alignment.center,
      child: Column(
        children: const [
          Icon(Icons.grade_outlined, size: 56, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text('Belum ada nilai yang diinput dosen.',
              style: TextStyle(color: Color(0xFF737685))),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 56, color: Color(0xFFEF4444)),
            const SizedBox(height: 12),
            Text(_error ?? 'Terjadi kesalahan',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF737685))),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _load,
              style: ElevatedButton.styleFrom(backgroundColor: _primary),
              child: const Text('Coba Lagi',
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
