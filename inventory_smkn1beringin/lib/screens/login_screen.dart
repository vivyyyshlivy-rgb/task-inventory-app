import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/item_model.dart';
import 'register_screen.dart';
import 'user_dashboard.dart';
import 'admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _usernameError;
  String? _passwordError;

  bool _isPasswordObscured = true;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    final usernameInput = _usernameController.text.trim();
    final passwordInput = _passwordController.text;

    setState(() {
      _usernameError = null;
      _passwordError = null;

      if (usernameInput.isEmpty) {
        _usernameError = 'Username wajib diisi';
      }

      if (passwordInput.isEmpty) {
        _passwordError = 'Password wajib diisi';
      } else if (passwordInput.length < 6) {
        _passwordError = 'Password harus 6 karakter';
      }
    });

    if (_usernameError != null || _passwordError != null) {
      return;
    }

    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final user = AppData.registeredUsers
        .where((u) => u.username == usernameInput)
        .firstOrNull;

    if (user == null) {
      setState(() {
        _isLoading = false;
        _usernameError = 'Username tidak terdaftar';
      });
      return;
    }

    if (user.password != passwordInput) {
      setState(() {
        _isLoading = false;
        _passwordError = 'Password salah';
      });
      return;
    }

    if (!user.isApproved) {
      setState(() => _isLoading = false);

      showAppSnack(
        context,
        'Akun Anda belum disetujui admin utama. Silakan tunggu.',
        color: AppColors.warning,
        icon: Icons.hourglass_top_rounded,
      );
      return;
    }

    setState(() => _isLoading = false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => user.isAdmin
            ? AdminDashboardScreen(user: user)
            : UserDashboardScreen(user: user),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: AppBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 32,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.surface.withAlpha(235),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withAlpha(40),
                      blurRadius: 30,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/l.png',
                        height: 96,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.school_rounded,
                          size: 72,
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'SMK NEGERI 1 BERINGIN',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                        color: AppColors.accent,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Task & Inventory System',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Masuk dengan akun Anda',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Username
                    TextField(
                      controller: _usernameController,
                      textInputAction: TextInputAction.next,
                      onChanged: (_) {
                        if (_usernameError != null) {
                          setState(() => _usernameError = null);
                        }
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                      decoration: appInputDecoration(
                        label: 'Username',
                        hint: 'Masukkan username',
                        icon: Icons.person_outline_rounded,
                      ).copyWith(
                        errorText: _usernameError,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // Password maksimal 6 karakter
                    TextField(
                      controller: _passwordController,
                      obscureText: _isPasswordObscured,
                      maxLength: 6,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(6),
                      ],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleLogin(),
                      onChanged: (value) {
                        setState(() {
                          if (value.isEmpty) {
                            _passwordError = null;
                          } else if (value.length < 6) {
                            _passwordError =
                                'Password harus 6 karakter';
                          } else {
                            _passwordError = null;
                          }
                        });
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.text,
                      ),
                      decoration: appInputDecoration(
                        label: 'Password',
                        hint: 'Masukkan password',
                        icon: Icons.lock_outline_rounded,
                        suffix: IconButton(
                          icon: Icon(
                            _isPasswordObscured
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: AppColors.muted,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordObscured =
                                  !_isPasswordObscured;
                            });
                          },
                        ),
                      ).copyWith(
                        errorText: _passwordError,
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 26),

                    SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Masuk ke Sistem',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Belum memiliki akun? ',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.muted,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RegisterScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'Registrasi',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}