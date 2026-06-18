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
    final color = isOver ? AppColors.expense : AppColors.primary;
    final pct = (progress * 100).toStringAsFixed(0);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                MyText(title: category, size: 13, weight: FontWeight.w700, clr: AppColors.black),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: MyText(title: '$pct%', size: 10, weight: FontWeight.w700, clr: color),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.lightWhite,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MyText(
                title: 'Spent: Rs ${spent.toStringAsFixed(0)}',
                size: 10,
                weight: FontWeight.w500,
                clr: AppColors.greyText,
              ),
              MyText(
                title: isOver
                    ? 'Over Rs ${(spent - budget).toStringAsFixed(0)}'
                    : 'Left: Rs ${(budget - spent).toStringAsFixed(0)}',
                size: 10,
                weight: FontWeight.w600,
                clr: color,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
