import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.ok = false, this.warn = false});
  final String label;
  final bool ok;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final color = ok ? AppColors.ok : (warn ? AppColors.warn : AppColors.ibmBlue);
    return Chip(
      avatar: Icon(ok ? Icons.check_circle : Icons.info_outline, color: color, size: 18),
      label: Text(label),
      side: BorderSide(color: color.withOpacity(.35)),
      backgroundColor: color.withOpacity(.08),
    );
  }
}
