import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../config/app_colors.dart';
import 'my_text.dart';

class TransactionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final DateTime date;
  final bool isExpense;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const TransactionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.date,
    required this.isExpense,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha:0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: (isExpense ? AppColors.red : AppColors.primary).withValues(alpha:0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isExpense ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: isExpense ? AppColors.red : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(title: title, size: 13, weight: FontWeight.w600, clr: AppColors.black),
                  const SizedBox(height: 2),
                  MyText(title: subtitle, size: 11, weight: FontWeight.w400, clr: AppColors.greyText),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyText(
                  title: '${isExpense ? '-' : '+'} Rs ${amount.toStringAsFixed(0)}',
                  size: 13,
                  weight: FontWeight.w700,
                  clr: isExpense ? AppColors.red : AppColors.primary,
                ),
                const SizedBox(height: 2),
                MyText(
                  title: DateFormat('d MMM').format(date),
                  size: 10,
                  weight: FontWeight.w400,
                  clr: AppColors.greyText,
                ),
              ],
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 8),
              GestureDetector(
                onTap: onDelete,
                child: const Icon(Icons.delete_outline, color: AppColors.red, size: 18),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
