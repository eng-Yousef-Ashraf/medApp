import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/core/di/injection_container.dart';
import 'package:my_flutter_app/core/routes/app_routes.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/domain/entities/booking.dart';
import 'package:my_flutter_app/presentation/cubits/booking/booking_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/booking/booking_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showAppointments = false;
  late final BookingCubit _bookingCubit;

  @override
  void initState() {
    super.initState();
    _bookingCubit = sl<BookingCubit>();
  }

  @override
  void dispose() {
    _bookingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bookingCubit,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Profile card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0D9488), Color(0xFF0D3B66)],
                  ),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text(
                        'A',
                        style: GoogleFonts.poppins(
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Ahmed',
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'ahmed@medlink.com',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),
              // Menu items
              _menuItem(
                Icons.calendar_month_rounded,
                'My Appointments',
                AppTheme.primary,
                () {
                  setState(() => _showAppointments = !_showAppointments);
                  if (_showAppointments) _bookingCubit.loadBookings();
                },
              ),
              if (_showAppointments) _buildAppointments(),
              _menuItem(
                Icons.medical_information_rounded,
                'Medical History',
                AppTheme.info,
                () {},
              ),
              _menuItem(
                Icons.emergency_rounded,
                'Emergency Contacts',
                AppTheme.critical,
                () => Navigator.pushNamed(context, AppRoutes.hospitals),
              ),
              _menuItem(
                Icons.settings_rounded,
                'Settings',
                AppTheme.textMuted,
                () {},
              ),
              _menuItem(
                Icons.help_outline_rounded,
                'Help & Support',
                AppTheme.moderate,
                () {},
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.login),
                  icon: const Icon(
                    Icons.logout_rounded,
                    color: AppTheme.critical,
                  ),
                  label: Text(
                    'Logout',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.critical,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppTheme.critical,
                      width: 0.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        tileColor: AppTheme.bgCard,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: color.withValues(alpha: 0.1),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimary,
          ),
        ),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppTheme.textMuted,
        ),
      ),
    );
  }

  Widget _buildAppointments() {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (ctx, state) {
        if (state is BookingLoaded) {
          if (state.bookings.isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'No appointments yet',
                style: GoogleFonts.inter(
                  color: AppTheme.textMuted,
                  fontSize: 14,
                ),
              ),
            );
          }
          return Column(
            children: state.bookings
                .map(
                  (b) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppTheme.bgCard,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppTheme.divider.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.primary.withValues(alpha: 0.1),
                          ),
                          child: const Icon(
                            Icons.calendar_today_rounded,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                b.doctorName,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textPrimary,
                                ),
                              ),
                              Text(
                                '${DateFormat('MMM d').format(b.date)} • ${b.timeSlot}',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _statusBadge(b.status),
                      ],
                    ),
                  ),
                )
                .toList(),
          );
        }
        return const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(color: AppTheme.primary),
        );
      },
    );
  }

  Widget _statusBadge(BookingStatus status) {
    Color c;
    String t;
    switch (status) {
      case BookingStatus.confirmed:
        c = AppTheme.mild;
        t = 'Confirmed';
      case BookingStatus.pending:
        c = AppTheme.moderate;
        t = 'Pending';
      case BookingStatus.completed:
        c = AppTheme.info;
        t = 'Done';
      case BookingStatus.cancelled:
        c = AppTheme.critical;
        t = 'Cancelled';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        t,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: c,
        ),
      ),
    );
  }
}
