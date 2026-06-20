import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/presentation/cubits/hospital/hospital_cubit.dart';
import 'package:my_flutter_app/presentation/cubits/hospital/hospital_state.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalsScreen extends StatelessWidget {
  const HospitalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emergency Hospitals',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          // Emergency call button
          Container(
            margin: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () => launchUrl(Uri.parse('tel:911')),
                icon: const Icon(Icons.emergency_rounded, size: 24),
                label: Text(
                  'Call Emergency (911)',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.critical,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ).animate().fadeIn().slideY(begin: -0.1, end: 0),
          // Hospital list
          Expanded(
            child: BlocBuilder<HospitalCubit, HospitalState>(
              builder: (ctx, state) {
                if (state is HospitalLoading)
                  return const Center(
                    child: CircularProgressIndicator(color: AppTheme.primary),
                  );
                if (state is HospitalLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: state.hospitals.length,
                    itemBuilder: (ctx, i) {
                      final h = state.hospitals[i];
                      return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppTheme.bgCard,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppTheme.divider.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: h.emergencyAvailable
                                            ? AppTheme.criticalBg
                                            : AppTheme.infoBg,
                                      ),
                                      child: Icon(
                                        Icons.local_hospital_rounded,
                                        color: h.emergencyAvailable
                                            ? AppTheme.critical
                                            : AppTheme.info,
                                        size: 26,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            h.name,
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: AppTheme.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            h.address,
                                            style: GoogleFonts.inter(
                                              fontSize: 12,
                                              color: AppTheme.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              size: 14,
                                              color: AppTheme.moderate,
                                            ),
                                            Text(
                                              ' ${h.rating}',
                                              style: GoogleFonts.inter(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.moderate,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          h.distance,
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: AppTheme.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    if (h.is24Hours)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.mildBg,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.access_time_rounded,
                                              size: 12,
                                              color: AppTheme.mild,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '24/7',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.mild,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (h.emergencyAvailable) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.criticalBg,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.emergency_rounded,
                                              size: 12,
                                              color: AppTheme.critical,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              'ER',
                                              style: GoogleFonts.inter(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600,
                                                color: AppTheme.critical,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    const Spacer(),
                                    SizedBox(
                                      height: 36,
                                      child: ElevatedButton.icon(
                                        onPressed: () => launchUrl(
                                          Uri.parse('tel:${h.phone}'),
                                        ),
                                        icon: const Icon(
                                          Icons.phone_rounded,
                                          size: 16,
                                        ),
                                        label: Text(
                                          'Call',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppTheme.primary,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (i * 100).ms)
                          .slideX(begin: 0.05, end: 0);
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
