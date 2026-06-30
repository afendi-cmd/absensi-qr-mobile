import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/services/audit_log_service.dart';

/// Audit Log aktivitas sistem (admin).
class AuditLogScreen extends StatefulWidget {
  const AuditLogScreen({super.key});

  @override
  State<AuditLogScreen> createState() => _AuditLogScreenState();
}

class _AuditLogScreenState extends State<AuditLogScreen> {
  static const _primary = Color(0xFF003d9b);
  final _service = AuditLogService();

  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _logs = [];

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
      final logs = await _service.getLogs(limit: 200);
      setState(() {
        _logs = logs;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _loading = false;
      });
    }
  }

  Color _roleColor(String? r) {
    switch (r) {
      case 'admin':
        return const Color(0xFFEF4444);
      case 'dosen':
        return const Color(0xFF3B82F6);
      case 'mahasiswa':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF94A3B8);
    }
  }

  Color _actionColor(String a) {
    final x = a.toLowerCase();
    if (x.contains('delete') || x.contains('remove') || x.contains('tolak')) {
      return const Color(0xFFEF4444);
    }
    if (x.contains('login') ||
        x.contains('register') ||
        x.contains('create') ||
        x.contains('add')) {
      return const Color(0xFF10B981);
    }
    if (x.contains('reset') ||
        x.contains('review') ||
        x.contains('input') ||
        x.contains('upload')) {
      return const Color(0xFFF59E0B);
    }
    return const Color(0xFF3B82F6);
  }

  String _fmt(dynamic raw) {
    if (raw == null) return '-';
    try {
      return DateFormat('d MMM yyyy, HH:mm', 'id_ID')
          .format(DateTime.parse(raw.toString()).toLocal());
    } catch (_) {
      return raw.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        title: const Text('Audit Log'),
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
              child: _logs.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 140),
                        Center(
                          child: Text('Belum ada catatan aktivitas.',
                              style: TextStyle(color: Color(0xFF737685))),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _logs.length,
                      itemBuilder: (_, i) => _buildCard(_logs[i]),
                    ),
            ),
    );
  }

  Widget _buildCard(Map<String, dynamic> l) {
    final user = (l['user'] ?? {}) as Map<String, dynamic>;
    final role = user['role']?.toString();
    final action = l['action']?.toString() ?? '-';
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
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
                child: Text(user['nama']?.toString() ?? 'Sistem',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
              ),
              if (role != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: _roleColor(role).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(role,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _roleColor(role))),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (l['module'] != null) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(l['module'].toString(),
                      style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF475569))),
                ),
                const SizedBox(width: 6),
              ],
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _actionColor(action).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(action,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: _actionColor(action))),
              ),
            ],
          ),
          if (l['description'] != null &&
              l['description'].toString().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(l['description'].toString(),
                style: const TextStyle(fontSize: 13)),
          ],
          const SizedBox(height: 6),
          Text(_fmt(l['created_at']),
              style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }
}
