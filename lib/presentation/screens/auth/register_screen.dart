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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _hidePass = true;
  late final AuthCubit _authCubit;

  @override
  void initState() {
    super.initState();
    _authCubit = sl<AuthCubit>();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
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
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: AppTheme.textPrimary,
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        width: 70,
                        height: 70,
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
                          Icons.person_add_rounded,
                          size: 34,
                          color: Colors.white,
                        ),
                      ).animate().scale(
                        duration: 500.ms,
                        curve: Curves.easeOutBack,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Create Account',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ).animate().fadeIn(delay: 200.ms),
                      const SizedBox(height: 4),
                      Text(
                        'Sign up to get started',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          color: AppTheme.textSecondary,
                        ),
                      ).animate().fadeIn(delay: 300.ms),
                      const SizedBox(height: 32),
                      GlassCard(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                CustomTextField(
                                  controller: _nameCtrl,
                                  hintText: 'Full Name',
                                  prefixIcon: Icons.person_outline,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Enter your name'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _emailCtrl,
                                  hintText: 'Email address',
                                  prefixIcon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Enter email'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _passCtrl,
                                  hintText: 'Password',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: _hidePass,
                                  validator: (v) => v != null && v.length < 6
                                      ? 'Min 6 characters'
                                      : null,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _hidePass
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: AppTheme.textMuted,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        setState(() => _hidePass = !_hidePass),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                CustomTextField(
                                  controller: _confirmCtrl,
                                  hintText: 'Confirm Password',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: true,
                                  validator: (v) => v != _passCtrl.text
                                      ? 'Passwords don\'t match'
                                      : null,
                                ),
                                const SizedBox(height: 24),
                                BlocBuilder<AuthCubit, AuthState>(
                                  builder: (ctx, state) {
                                    return SizedBox(
                                      width: double.infinity,
                                      height: 52,
                                      child: ElevatedButton(
                                        onPressed: state is AuthLoading
                                            ? null
                                            : () {
                                                if (_formKey.currentState!
                                                    .validate())
                                                  _authCubit.register(
                                                    _nameCtrl.text,
                                                    _emailCtrl.text,
                                                    _passCtrl.text,
                                                  );
                                              },
                                        child: state is AuthLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      color: Colors.white,
                                                    ),
                                              )
                                            : const Text('Create Account'),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: 400.ms)
                          .slideY(begin: 0.1, end: 0),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              color: AppTheme.textMuted.withValues(alpha: 0.3),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              'or',
                              style: GoogleFonts.inter(
                                color: AppTheme.textMuted,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              color: AppTheme.textMuted.withValues(alpha: 0.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: () => _authCubit.loginWithGoogle(),
                          icon: const Icon(
                            Icons.g_mobiledata_rounded,
                            size: 28,
                          ),
                          label: Text(
                            'Continue with Google',
                            style: GoogleFonts.inter(fontSize: 15),
                          ),
                        ),
                      ).animate().fadeIn(delay: 600.ms),
                      const SizedBox(height: 32),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: RichText(
                          text: TextSpan(
                            text: 'Already have an account? ',
                            style: GoogleFonts.inter(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: GoogleFonts.inter(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ).animate().fadeIn(delay: 700.ms),
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
}
