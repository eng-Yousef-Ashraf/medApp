import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/domain/entities/booking.dart';
import 'package:my_flutter_app/domain/entities/doctor.dart';
import 'package:my_flutter_app/presentation/cubits/booking/booking_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/booking/booking_state.dart';

class BookingScreen extends StatefulWidget {
  final Doctor? preselectedDoctor;
  const BookingScreen({super.key, this.preselectedDoctor});
  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String? _selectedSlot;
  final _reasonCtrl = TextEditingController();
  late final List<String> _slots;

  @override
  void initState() {
    super.initState();
    _slots =
        widget.preselectedDoctor?.availableSlots ??
        [
          '09:00 AM',
          '10:00 AM',
          '11:00 AM',
          '02:00 PM',
          '03:00 PM',
          '04:00 PM',
        ];
  }

  @override
  void dispose() {
    _reasonCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Appointment',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: BlocListener<BookingCubit, BookingState>(
        listener: (ctx, state) {
          if (state is BookingSuccess) {
            _showSuccessDialog(ctx);
          } else if (state is BookingError) {
            ScaffoldMessenger.of(ctx).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.critical,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor info
              if (widget.preselectedDoctor != null)
                _buildDoctorCard().animate().fadeIn(),
              const SizedBox(height: 24),
              // Date picker
              Text(
                'Select Date',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildDatePicker().animate().fadeIn(delay: 100.ms),
              const SizedBox(height: 24),
              // Time slots
              Text(
                'Available Time Slots',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              _buildTimeSlots().animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 24),
              // Reason
              Text(
                'Reason for Visit',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _reasonCtrl,
                maxLines: 3,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppTheme.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: 'Describe your reason...',
                  filled: true,
                  fillColor: AppTheme.bgCard,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 32),
              // Confirm button
              BlocBuilder<BookingCubit, BookingState>(
                builder: (ctx, state) {
                  return SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          state is BookingLoading || _selectedSlot == null
                          ? null
                          : _confirmBooking,
                      child: state is BookingLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Confirm Booking',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              ).animate().fadeIn(delay: 400.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorCard() {
    final d = widget.preselectedDoctor!;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.divider.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AppTheme.primary.withValues(alpha: 0.2),
            child: Text(
              d.name.split(' ').last[0],
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  d.name,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  d.specialty,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 14,
                color: AppTheme.moderate,
              ),
              Text(
                ' ${d.rating}',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.moderate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    final now = DateTime.now();
    final days = List.generate(14, (i) => now.add(Duration(days: i + 1)));
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (ctx, i) {
          final d = days[i];
          final active =
              d.day == _selectedDate.day && d.month == _selectedDate.month;
          return GestureDetector(
            onTap: () => setState(() => _selectedDate = d),
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: active ? AppTheme.primary : AppTheme.bgCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? AppTheme.primary : AppTheme.divider,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('E').format(d),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: active
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${d.day}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: active ? Colors.white : AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    DateFormat('MMM').format(d),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: active
                          ? Colors.white.withValues(alpha: 0.8)
                          : AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _slots.map((s) {
        final active = s == _selectedSlot;
        return GestureDetector(
          onTap: () => setState(() => _selectedSlot = s),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            decoration: BoxDecoration(
              color: active ? AppTheme.primary : AppTheme.bgCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: active ? AppTheme.primary : AppTheme.divider,
              ),
            ),
            child: Text(
              s,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                color: active ? Colors.white : AppTheme.textSecondary,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _confirmBooking() {
    final booking = Booking(
      id: 'b_${DateTime.now().millisecondsSinceEpoch}',
      doctorId: widget.preselectedDoctor?.id ?? 'd1',
      doctorName: widget.preselectedDoctor?.name ?? 'Doctor',
      doctorSpecialty: widget.preselectedDoctor?.specialty ?? 'General',
      date: _selectedDate,
      timeSlot: _selectedSlot!,
      reason: _reasonCtrl.text.isEmpty ? 'General checkup' : _reasonCtrl.text,
      status: BookingStatus.pending,
    );
    context.read<BookingCubit>().createBooking(booking);
  }

  void _showSuccessDialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.mildBg,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                size: 48,
                color: AppTheme.mild,
              ),
            ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 20),
            Text(
              'Booking Confirmed!',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your appointment has been\nsuccessfully booked.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  Navigator.pop(ctx);
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
