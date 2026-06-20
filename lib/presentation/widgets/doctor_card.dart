import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/domain/entities/doctor.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final bool compact;
  const DoctorCard({super.key, required this.doctor, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(doctor.specialty);
    return Container(
      padding: EdgeInsets.all(compact ? 12 : 16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.divider.withValues(alpha: 0.5)),
      ),
      child: compact ? _buildCompact(colors) : _buildFull(colors),
    );
  }

  Widget _buildCompact(List<Color> colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: colors[0].withValues(alpha: 0.15),
              child: Text(
                doctor.name.split(' ').last[0],
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors[0],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    doctor.specialty,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(Icons.star_rounded, size: 14, color: AppTheme.moderate),
            Text(
              ' ${doctor.rating}',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppTheme.moderate,
              ),
            ),
            Text(
              ' (${doctor.reviewCount})',
              style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: colors[0].withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                '${doctor.experienceYears}y exp',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: colors[0],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFull(List<Color> colors) {
    return Row(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: colors[0].withValues(alpha: 0.15),
          child: Text(
            doctor.name.split(' ').map((w) => w[0]).take(2).join(),
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colors[0],
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                doctor.name,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                doctor.specialty,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: AppTheme.moderate,
                  ),
                  Text(
                    ' ${doctor.rating}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.moderate,
                    ),
                  ),
                  Text(
                    ' (${doctor.reviewCount} reviews)',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Icon(Icons.chevron_right_rounded, color: AppTheme.textMuted),
      ],
    );
  }

  List<Color> _getColors(String s) {
    switch (s) {
      case 'Cardiology':
        return [const Color(0xFFEF4444), const Color(0xFFF87171)];
      case 'Neurology':
        return [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)];
      case 'Pediatrics':
        return [const Color(0xFF10B981), const Color(0xFF34D399)];
      case 'Orthopedics':
        return [const Color(0xFFF59E0B), const Color(0xFFFBBF24)];
      case 'Dermatology':
        return [const Color(0xFFEC4899), const Color(0xFFF472B6)];
      case 'Psychiatry':
        return [const Color(0xFF6366F1), const Color(0xFF818CF8)];
      case 'Emergency Medicine':
        return [const Color(0xFFEF4444), const Color(0xFFF97316)];
      default:
        return [AppTheme.primary, AppTheme.primaryLight];
    }
  }
}
