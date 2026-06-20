import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/app_theme.dart';
import 'package:my_flutter_app/domain/entities/message.dart';

class UrgencyBadge extends StatelessWidget {
  final UrgencyLevel level;
  final bool compact;

  const UrgencyBadge({super.key, required this.level, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: config.bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: config.color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, color: config.color, size: compact ? 12 : 16),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: TextStyle(
              color: config.color,
              fontSize: compact ? 10 : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  _UrgencyConfig _getConfig() {
    switch (level) {
      case UrgencyLevel.critical:
        return _UrgencyConfig(
          color: AppTheme.critical,
          bgColor: AppTheme.criticalBg,
          icon: Icons.warning_rounded,
          label: 'CRITICAL — Seek Emergency Care',
        );
      case UrgencyLevel.moderate:
        return _UrgencyConfig(
          color: AppTheme.moderate,
          bgColor: AppTheme.moderateBg,
          icon: Icons.schedule_rounded,
          label: 'MODERATE — See Doctor in 24h',
        );
      case UrgencyLevel.mild:
        return _UrgencyConfig(
          color: AppTheme.mild,
          bgColor: AppTheme.mildBg,
          icon: Icons.check_circle_rounded,
          label: 'MILD — Home Care OK',
        );
      case UrgencyLevel.info:
        return _UrgencyConfig(
          color: AppTheme.info,
          bgColor: AppTheme.infoBg,
          icon: Icons.info_rounded,
          label: 'INFO',
        );
      case UrgencyLevel.none:
        return _UrgencyConfig(
          color: AppTheme.textMuted,
          bgColor: Colors.transparent,
          icon: Icons.chat_bubble_outline,
          label: '',
        );
    }
  }
}

class _UrgencyConfig {
  final Color color;
  final Color bgColor;
  final IconData icon;
  final String label;

  _UrgencyConfig({
    required this.color,
    required this.bgColor,
    required this.icon,
    required this.label,
  });
}
