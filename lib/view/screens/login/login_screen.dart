import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_model/visit_auth_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(VisitAuthViewModel authViewModel) {
    if (_formKey.currentState!.validate()) {
      context.go('/visit-list');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<VisitAuthViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F4),
      body: Stack(
        children: [

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _TopArcClipper(),
              child: Container(
                height: 260,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 36),

                    Center(
                      child: Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.agriculture_rounded,
                          size: 46,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),


                    const Center(
                      child: Text(
                        'Field Visit Logger',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Center(
                      child: Text(
                        'Sign in to continue',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFA5D6A7),
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 28,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          const _Label(text: 'Username'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _usernameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1B2E1C),
                            ),
                            decoration: _buildInputDecoration(
                              hint: 'Enter your username',
                              icon: Icons.person_outline_rounded,
                            ),
                            validator: authViewModel.validateUsername,
                          ),

                          const SizedBox(height: 22),

                          const _Label(text: 'Password'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !authViewModel.isPasswordVisible,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (_) => _handleLogin(authViewModel),
                            style: const TextStyle(
                              fontSize: 15,
                              color: Color(0xFF1B2E1C),
                            ),
                            decoration: _buildInputDecoration(
                              hint: 'Enter your password',
                              icon: Icons.lock_outline_rounded,
                            ).copyWith(
                              suffixIcon: IconButton(
                                onPressed: authViewModel.togglePasswordVisibility,
                                icon: Icon(
                                  authViewModel.isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: const Color(0xFF9E9E9E),
                                  size: 20,
                                ),
                              ),
                            ),
                            validator: authViewModel.validatePassword,
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () => _handleLogin(authViewModel),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2E7D32),
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBDBDBD), fontSize: 14),
      prefixIcon: Icon(icon, color: const Color(0xFF66BB6A), size: 20),
      filled: true,
      fillColor: const Color(0xFFF7FAF7),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE8EDE8)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE53935)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.8),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Color(0xFF3E5240),
        letterSpacing: 0.2,
      ),
    );
  }
}

class _TopArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 30,
      size.width,
      size.height - 60,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TopArcClipper oldClipper) => false;
}