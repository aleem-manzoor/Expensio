import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_constants.dart';
import '../controllers/budget_controller.dart';

class AddBudgetView extends GetView<BudgetController> {
  const AddBudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightWhite,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Form(
                key: controller.formKey,
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMonthSelector(),
                    const SizedBox(height: 20),
                    _buildTotalBudgetCard(),
                    const SizedBox(height: 20),
                    _buildCategorySection(),
                    const SizedBox(height: 28),
                    _buildSaveButton(),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: Row(children: [
        GestureDetector(
          onTap: Get.back,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 18),
          ),
        ),
        const SizedBox(width: 14),
        const Text('Set Budget', style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        const Text('Month', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black)),
        const Spacer(),
        DropdownButtonHideUnderline(
          child: DropdownButton<int>(
            value: controller.selectedMonth.value,
            icon: const Icon(Icons.expand_more_rounded, color: AppColors.primary),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primary),
            items: List.generate(12, (i) => i + 1).map((m) => DropdownMenuItem(
              value: m,
              child: Text(AppConstants.months[m - 1], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black)),
            )).toList(),
            onChanged: (v) {
              controller.selectedMonth.value = v!;
              controller.loadBudgets();
            },
          ),
        ),
      ]),
    );
  }

  Widget _buildTotalBudgetCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('MONTHLY BUDGET', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.greyText, letterSpacing: 0.8)),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.totalBudgetCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.primary),
          decoration: const InputDecoration(
            hintText: '0',
            hintStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.lightText),
            prefixText: 'Rs  ',
            prefixStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.greyText),
            border: InputBorder.none,
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Enter total budget' : null,
        ),
      ]),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('CATEGORY LIMITS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.greyText, letterSpacing: 0.8)),
        const SizedBox(height: 4),
        const Text('Optional — set spending limits per category', style: TextStyle(fontSize: 12, color: AppColors.lightText)),
        const SizedBox(height: 16),
        ...AppConstants.expenseCategories.map((cat) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(children: [
            Expanded(
              flex: 3,
              child: Text(cat, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black)),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: TextFormField(
                controller: controller.categoryControllers[cat],
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: const TextStyle(color: AppColors.lightText, fontSize: 13),
                  prefixText: 'Rs ',
                  prefixStyle: const TextStyle(color: AppColors.greyText, fontSize: 12),
                  filled: true,
                  fillColor: AppColors.lightWhite,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                ),
              ),
            ),
          ]),
        )),
      ]),
    );
  }

  Widget _buildSaveButton() {
    return Obx(() => GestureDetector(
      onTap: controller.isSaving.value ? null : controller.saveBudget,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: controller.isSaving.value ? null : AppColors.primaryGradient,
          color: controller.isSaving.value ? AppColors.primaryLight : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: controller.isSaving.value ? [] : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: controller.isSaving.value
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5))
              : const Text('Save Budget', style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700)),
        ),
      ),
    ));
  }
}
