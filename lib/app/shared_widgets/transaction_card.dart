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
    final color = isExpense ? AppColors.expense : AppColors.income;
    final bgColor = isExpense ? AppColors.expenseLight : AppColors.incomeLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isExpense ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(title: title, size: 13, weight: FontWeight.w700, clr: AppColors.black),
                  const SizedBox(height: 3),
                  MyText(title: subtitle, size: 11, weight: FontWeight.w400, clr: AppColors.greyText),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MyText(
                  title: '${isExpense ? '−' : '+'} Rs ${amount.toStringAsFixed(0)}',
                  size: 13,
                  weight: FontWeight.w700,
                  clr: color,
                ),
                const SizedBox(height: 3),
                MyText(
                  title: DateFormat('d MMM').format(date),
                  size: 10,
                  weight: FontWeight.w400,
                  clr: AppColors.lightText,
                ),
              ],
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 10),
              GestureDetector(
                onTap: onDelete,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.expenseLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.delete_outline_rounded, color: AppColors.expense, size: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
