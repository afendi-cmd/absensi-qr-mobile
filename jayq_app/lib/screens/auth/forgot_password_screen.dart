import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart';

/// Layar lupa password: minta token lalu reset password.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static const _primary = Color(0xFF0052CC);
  final _auth = AuthService();

  final _emailC = TextEditingController();
  final _tokenC = TextEditingController();
  final _passC = TextEditingController();

  bool _step2 = false;
  bool _loading = false;

  @override
  void dispose() {
    _emailC.dispose();
    _tokenC.dispose();
    _passC.dispose();
    super.dispose();
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor:
          isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
    ));
  }

  Future<void> _requestToken() async {
    if (_emailC.text.trim().isEmpty) {
      _snack('Masukkan email', isError: true);
      return;
    }
    setState(() => _loading = true);
    final res = await _auth.forgotPassword(_emailC.text.trim());
    setState(() => _loading = false);
    if (res['success'] == true) {
      setState(() {
        _step2 = true;
        // Mode demo: token otomatis terisi dari response backend.
        if (res['reset_token'] != null) {
          _tokenC.text = res['reset_token'].toString();
        }
      });
      _snack('Token reset dibuat. Lanjutkan reset password.');
    } else {
      _snack(res['message']?.toString() ?? 'Gagal', isError: true);
    }
  }

  Future<void> _resetPassword() async {
    if (_tokenC.text.trim().isEmpty || _passC.text.length < 6) {
      _snack('Token & password (min 6 karakter) wajib diisi', isError: true);
      return;
    }
    setState(() => _loading = true);
    final res = await _auth.resetPassword(
      email: _emailC.text.trim(),
      token: _tokenC.text.trim(),
      password: _passC.text,
    );
    setState(() => _loading = false);
    if (res['success'] == true) {
      _snack('Password berhasil direset. Silakan login.');
      if (mounted) Navigator.pop(context);
    } else {
      _snack(res['message']?.toString() ?? 'Gagal', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        title: const Text('Lupa Password'),
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 6),
              const Text(
                'Masukkan email terdaftar untuk mendapatkan token reset.',
                style: TextStyle(color: Color(0xFF6B6B6B)),
              ),
              const SizedBox(height: 24),
              _field(_emailC, 'Email', Icons.mail_outline,
                  keyboard: TextInputType.emailAddress, enabled: !_step2),
              if (!_step2) ...[
                const SizedBox(height: 20),
                _button('Kirim Token', _requestToken),
              ],
              if (_step2) ...[
                const SizedBox(height: 16),
                _field(_tokenC, 'Token Reset', Icons.vpn_key_outlined),
                const SizedBox(height: 16),
                _field(_passC, 'Password Baru', Icons.lock_outline,
                    obscure: true),
                const SizedBox(height: 20),
                _button('Reset Password', _resetPassword),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    TextEditingController c,
    String label,
    IconData icon, {
    bool obscure = false,
    bool enabled = true,
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: c,
      obscureText: obscure,
      enabled: enabled,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFF6B6B6B)),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
      ),
    );
  }

  Widget _button(String label, VoidCallback onTap) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: _loading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: _loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : Text(label,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}
