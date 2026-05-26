import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../providers/theme_provider.dart';
import '../../data/services/user_service.dart';

class AddMahasiswaScreen extends StatefulWidget {
  final Map<String, dynamic>? mahasiswa;

  const AddMahasiswaScreen({super.key, this.mahasiswa});

  @override
  State<AddMahasiswaScreen> createState() => _AddMahasiswaScreenState();
}

class _AddMahasiswaScreenState extends State<AddMahasiswaScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();
  final ImagePicker _picker = ImagePicker();

  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _angkatanController = TextEditingController();

  String? _selectedProgramStudi;
  File? _selectedImage;

  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final List<String> _programStudiList = [
    'Teknik Informatika',
    'Sistem Informasi',
    'Teknik Elektro',
    'Teknik Komputer',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.mahasiswa != null) {
      _namaController.text = widget.mahasiswa!['nama'] ?? '';
      _emailController.text = widget.mahasiswa!['email'] ?? '';
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _angkatanController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final File imageFile = File(image.path);
        final int fileSize = await imageFile.length();

        // Check file size (max 2MB)
        if (fileSize > 2 * 1024 * 1024) {
          _showSnackBar('Ukuran file maksimal 2MB', isError: true);
          return;
        }

        setState(() {
          _selectedImage = imageFile;
        });
      }
    } catch (e) {
      _showSnackBar('Gagal memilih gambar: ${e.toString()}', isError: true);
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedProgramStudi == null) {
      _showSnackBar('Pilih Program Studi terlebih dahulu', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final data = {
        'nama': _namaController.text.trim(),
        'email': _emailController.text.trim(),
        'role': 'mahasiswa',
      };

      if (widget.mahasiswa == null) {
        if (_passwordController.text.isEmpty) {
          _showSnackBar('Password tidak boleh kosong', isError: true);
          setState(() => _isLoading = false);
          return;
        }
        data['password'] = _passwordController.text;
        await _userService.createUser(data);
        _showSnackBar('Mahasiswa berhasil ditambahkan');
      } else {
        if (_passwordController.text.isNotEmpty) {
          data['password'] = _passwordController.text;
        }
        await _userService.updateUser(widget.mahasiswa!['id'], data);
        _showSnackBar('Mahasiswa berhasil diupdate');
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar('Gagal menyimpan data: ${e.toString()}', isError: true);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF111827)
          : const Color(0xFFF8F9FB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildFormCard(isDark),
                    _buildInfoCards(isDark),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    final isEditMode = widget.mahasiswa != null;

    return Container(
      color: isDark ? const Color(0xFF1F2937) : Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF374151) : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark
                    ? const Color(0xFF4B5563)
                    : const Color(0xFFE1E2E4),
              ),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: Icon(
                Icons.arrow_back,
                size: 20,
                color: isDark ? Colors.white : const Color(0xFF191C1E),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              isEditMode ? 'Edit Mahasiswa' : 'Tambah Mahasiswa',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF191C1E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormCard(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photo Upload Section
            Center(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF4B5563)
                              : const Color(0xFFD1D5DB),
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignInside,
                        ),
                        color: isDark
                            ? const Color(0xFF374151)
                            : const Color(0xFFF3F4F6),
                      ),
                      child: _selectedImage != null
                          ? ClipOval(
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                                width: 120,
                                height: 120,
                              ),
                            )
                          : Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: isDark
                                  ? const Color(0xFF9CA3AF)
                                  : const Color(0xFF737685),
                            ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Upload Foto Profil',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF003D9B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Maksimal 2MB, format JPG atau PNG',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? const Color(0xFF9CA3AF)
                          : const Color(0xFF737685),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildLabel('Nama Lengkap', isDark),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _namaController,
              hint: 'Contoh: Budi Santoso',
              icon: Icons.person_outline,
              isDark: isDark,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Nama tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildLabel('NIM', isDark),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _nimController,
              hint: 'Nomor Induk Mahasiswa',
              icon: Icons.badge_outlined,
              isDark: isDark,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(15),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'NIM tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildLabel('Email Mahasiswa', isDark),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _emailController,
              hint: 'nama@student.univ.ac.id',
              icon: Icons.email_outlined,
              isDark: isDark,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!value.contains('@')) {
                  return 'Format email tidak valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildLabel('Program Studi', isDark),
            const SizedBox(height: 8),
            _buildDropdown(
              value: _selectedProgramStudi,
              hint: 'Pilih Program Studi',
              icon: Icons.school_outlined,
              items: _programStudiList,
              isDark: isDark,
              onChanged: (value) {
                setState(() => _selectedProgramStudi = value);
              },
            ),
            const SizedBox(height: 16),
            _buildLabel('Angkatan', isDark),
            const SizedBox(height: 8),
            _buildTextField(
              controller: _angkatanController,
              hint: '2024',
              icon: Icons.calendar_today_outlined,
              isDark: isDark,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(4),
              ],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Angkatan tidak boleh kosong';
                }
                if (value.length != 4) {
                  return 'Angkatan harus 4 digit (contoh: 2024)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildLabel('Password', isDark),
            const SizedBox(height: 8),
            _buildPasswordField(isDark),
            const SizedBox(height: 24),
            _buildSubmitButton(),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Pastikan seluruh data yang dimasukkan sudah benar sebelum melakukan pendaftaran.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? const Color(0xFF9CA3AF)
                      : const Color(0xFF737685),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text, bool isDark) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required bool isDark,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE1E2E4),
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : const Color(0xFF191C1E),
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 15,
            color: isDark ? const Color(0xFF6B7280) : const Color(0xFFADB5BD),
          ),
          prefixIcon: Icon(
            icon,
            size: 20,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required bool isDark,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE1E2E4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(
              icon,
              size: 20,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
          hint: Text(
            hint,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? const Color(0xFF6B7280) : const Color(0xFFADB5BD),
            ),
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
          ),
          dropdownColor: isDark ? const Color(0xFF374151) : Colors.white,
          style: TextStyle(
            fontSize: 15,
            color: isDark ? Colors.white : const Color(0xFF191C1E),
          ),
          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPasswordField(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF374151) : const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? const Color(0xFF4B5563) : const Color(0xFFE1E2E4),
        ),
      ),
      child: TextFormField(
        controller: _passwordController,
        obscureText: !_isPasswordVisible,
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white : const Color(0xFF191C1E),
        ),
        decoration: InputDecoration(
          hintText: 'Minimal 6 karakter',
          hintStyle: TextStyle(
            fontSize: 15,
            color: isDark ? const Color(0xFF6B7280) : const Color(0xFFADB5BD),
          ),
          prefixIcon: Icon(
            Icons.lock_outline,
            size: 20,
            color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
              size: 20,
              color: isDark ? const Color(0xFF9CA3AF) : const Color(0xFF737685),
            ),
            onPressed: () {
              setState(() => _isPasswordVisible = !_isPasswordVisible);
            },
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        validator: (value) {
          if (widget.mahasiswa == null && (value == null || value.isEmpty)) {
            return 'Password tidak boleh kosong';
          }
          if (value != null && value.isNotEmpty && value.length < 6) {
            return 'Password minimal 6 karakter';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF003D9B),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(
            0xFF003D9B,
          ).withValues(alpha: 0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_add, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Daftarkan Mahasiswa',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildInfoCards(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF1E3A5F)
                    : const Color(0xFFD4E0F8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF003D9B),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.shield_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Privasi Data',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF191C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Data mahasiswa akan dienkripsi secara otomatis.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: isDark
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFF434654),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF374151)
                    : const Color(0xFFE7E8EA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFF737685),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Email Institusi',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF191C1E),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kredensial login akan dikirimkan via email terdaftar.',
                    style: TextStyle(
                      fontSize: 11,
                      height: 1.4,
                      color: isDark
                          ? const Color(0xFFD1D5DB)
                          : const Color(0xFF434654),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
