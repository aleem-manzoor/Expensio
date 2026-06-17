import 'package:flutter/material.dart';
import '../config/app_colors.dart';
import 'my_text.dart';

class BudgetProgressCard extends StatelessWidget {
  final String category;
  final double spent;
  final double budget;

  const BudgetProgressCard({
    super.key,
    required this.category,
    required this.spent,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    final progress = budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
    final isOver = spent > budget;
    final color = isOver ? AppColors.red : AppColors.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(title: category, size: 13, weight: FontWeight.w600, clr: AppColors.black),
              MyText(
                title: 'Rs ${spent.toStringAsFixed(0)} / Rs ${budget.toStringAsFixed(0)}',
                size: 11,
                weight: FontWeight.w500,
                clr: color,
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 7,
              backgroundColor: AppColors.lightWhite,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 6),
          MyText(
            title: isOver
                ? 'Over budget by Rs ${(spent - budget).toStringAsFixed(0)}'
                : 'Rs ${(budget - spent).toStringAsFixed(0)} remaining',
            size: 10,
            weight: FontWeight.w400,
            clr: color,
          ),
        ],
      ),
    );
  }
}
