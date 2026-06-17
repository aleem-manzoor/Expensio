import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import 'my_text.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;
  final IconData icon;

  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          MyText(title: label, size: 11, weight: FontWeight.w500, clr: AppColors.greyText),
          const SizedBox(height: 4),
          MyText(title: 'Rs $amount', size: 15, weight: FontWeight.w700, clr: color),
        ],
      ),
    );
  }
}
