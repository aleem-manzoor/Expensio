import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_constants.dart';
import '../controllers/income_controller.dart';

class AddIncomeView extends GetView<IncomeController> {
  const AddIncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.editingIncome != null;
    return Scaffold(
      backgroundColor: AppColors.lightWhite,
      body: Column(
        children: [
          _buildHeader(isEditing),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Form(
                key: controller.formKey,
                child: Obx(() => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAmountCard(),
                    const SizedBox(height: 20),
                    _buildSectionCard(children: [
                      _buildLabel('Source'),
                      const SizedBox(height: 10),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedSource.value,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more_rounded, color: AppColors.income, size: 20),
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.black),
                          items: AppConstants.incomeSources.map((e) => DropdownMenuItem(
                            value: e,
                            child: Row(children: [
                              const Icon(Icons.work_outline_rounded, size: 16, color: AppColors.income),
                              const SizedBox(width: 10),
                              Text(e, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.black)),
                            ]),
                          )).toList(),
                          onChanged: (v) => controller.selectedSource.value = v!,
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionCard(children: [
                      _buildLabel('Date'),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () => controller.pickDate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(color: AppColors.lightWhite, borderRadius: BorderRadius.circular(12)),
                          child: Row(children: [
                            const Icon(Icons.calendar_today_outlined, color: AppColors.income, size: 18),
                            const SizedBox(width: 12),
                            Text(
                              DateFormat('EEEE, d MMMM yyyy').format(controller.selectedDate.value),
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black),
                            ),
                            const Spacer(),
                            const Icon(Icons.chevron_right_rounded, color: AppColors.greyText, size: 20),
                          ]),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 16),
                    _buildSectionCard(children: [
                      _buildLabel('Note (optional)'),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: controller.descriptionCtrl,
                        maxLines: 3,
                        style: const TextStyle(fontSize: 13, color: AppColors.black),
                        decoration: InputDecoration(
                          hintText: 'Add a note about this income...',
                          hintStyle: const TextStyle(color: AppColors.lightText, fontSize: 13),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                          filled: true,
                          fillColor: AppColors.lightWhite,
                          contentPadding: const EdgeInsets.all(14),
                        ),
                      ),
                    ]),
                    const SizedBox(height: 28),
                    _buildSubmitButton(isEditing),
                  ],
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isEditing) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppColors.incomeGradient,
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
        Text(
          isEditing ? 'Edit Income' : 'Add Income',
          style: const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w800),
        ),
      ]),
    );
  }

  Widget _buildAmountCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.income.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _buildLabel('Amount (Rs)'),
        const SizedBox(height: 12),
        TextFormField(
          controller: controller.amountCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.income),
          decoration: const InputDecoration(
            hintText: '0',
            hintStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.lightText),
            prefixText: 'Rs  ',
            prefixStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.greyText),
            border: InputBorder.none,
          ),
          validator: (v) => (v == null || v.isEmpty) ? 'Enter amount' : null,
        ),
      ]),
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.greyText, letterSpacing: 0.5),
  );

  Widget _buildSubmitButton(bool isEditing) {
    return Obx(() => GestureDetector(
      onTap: controller.isSaving.value ? null : controller.saveIncome,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          gradient: controller.isSaving.value ? null : AppColors.incomeGradient,
          color: controller.isSaving.value ? AppColors.incomeLight : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: controller.isSaving.value ? [] : [BoxShadow(color: AppColors.income.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Center(
          child: controller.isSaving.value
              ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: AppColors.income, strokeWidth: 2.5))
              : Text(
                  isEditing ? 'Update Income' : 'Save Income',
                  style: const TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700),
                ),
        ),
      ),
    ));
  }
}
