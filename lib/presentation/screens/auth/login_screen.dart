import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_flutter_app/core/di/injection_container.dart';
import 'package:my_flutter_app/core/routes/app_routes.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/core/widgets/custom_text_field.dart';
import 'package:my_flutter_app/core/widgets/glass_card.dart';
import 'package:my_flutter_app/presentation/cubits/auth/auth_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/auth/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _hidePass = true;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _authCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _authCubit,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (ctx, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(ctx, AppRoutes.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.critical,
              ),
            );
          }
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildLogo(),
                      const SizedBox(height: 32),
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 4),
                      Text(
                        'Sign in to continue',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                      const SizedBox(height: 40),
                      _buildForm(),
                      const SizedBox(height: 24),
                      _buildDivider(),
                      const SizedBox(height: 24),
                      _buildGoogleBtn(),
                      const SizedBox(height: 32),
                      _buildRegisterLink(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.primaryLight],
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
          ),
        ],
      ),
      child: const Icon(
        Icons.local_hospital_rounded,
        size: 40,
        color: Colors.white,
      ),
    ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack);
  }

  Widget _buildForm() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CustomTextField(
            controller: _emailCtrl,
            hintText: 'Email address',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => v == null || v.isEmpty ? 'Enter email' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _passCtrl,
            hintText: 'Password',
            prefixIcon: Icons.lock_outline,
            obscureText: _hidePass,
            validator: (v) => v == null || v.isEmpty ? 'Enter password' : null,
            suffixIcon: IconButton(
              icon: Icon(
                _hidePass ? Icons.visibility_off : Icons.visibility,
                color: AppTheme.textMuted,
                size: 20,
              ),
              onPressed: () => setState(() => _hidePass = !_hidePass),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Forgot Password?',
                style: GoogleFonts.inter(color: AppTheme.primary, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 8),
          BlocBuilder<AuthCubit, AuthState>(
            builder: (ctx, state) {
              return SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: state is AuthLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate())
                            _authCubit.login(_emailCtrl.text, _passCtrl.text);
                        },
                  child: state is AuthLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sign In'),
                ),
              );
            },
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: AppTheme.textMuted.withValues(alpha: 0.3)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'or',
            style: GoogleFonts.inter(color: AppTheme.textMuted),
          ),
        ),
        Expanded(
          child: Divider(color: AppTheme.textMuted.withValues(alpha: 0.3)),
        ),
      ],
    );
  }

  Widget _buildGoogleBtn() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => _authCubit.loginWithGoogle(),
        icon: const Icon(Icons.g_mobiledata_rounded, size: 28),
        label: Text(
          'Continue with Google',
          style: GoogleFonts.inter(fontSize: 15),
        ),
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.register),
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 14),
          children: [
            TextSpan(
              text: 'Register',
              style: GoogleFonts.inter(
                color: AppTheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 700.ms);
  }
}
