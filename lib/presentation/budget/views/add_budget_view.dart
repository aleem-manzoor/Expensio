import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../app/config/app_colors.dart';
import '../../../app/config/app_constants.dart';
import '../../../app/shared_widgets/custom_button.dart';
import '../../../app/shared_widgets/my_text.dart';
import '../../../app/shared_widgets/textfield.dart';
import '../controllers/budget_controller.dart';

class AddBudgetView extends GetView<BudgetController> {
  const AddBudgetView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: Get.back,
          child: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 20),
        ),
        title: MyText(title: 'Set Budget', size: 16, weight: FontWeight.w700, clr: AppColors.black),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: controller.formKey,
          child: Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _label('Month'),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(color: AppColors.inputBorder),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: controller.selectedMonth.value,
                    isExpanded: true,
                    items: List.generate(12, (i) => i + 1)
                        .map((m) => DropdownMenuItem(
                              value: m,
                              child: Text(AppConstants.months[m - 1], style: const TextStyle(fontSize: 13)),
                            ))
                        .toList(),
                    onChanged: (v) {
                      controller.selectedMonth.value = v!;
                      controller.loadBudgets();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _label('Total Monthly Budget (Rs)'),
              const SizedBox(height: 6),
              InputTextField(
                controller: controller.totalBudgetCtrl,
                hint: 'e.g. 50000',
                textInputType: TextInputType.number,
                inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                validation: (v) => (v == null || v.isEmpty) ? 'Enter budget amount' : null,
              ),
              const SizedBox(height: 20),
              MyText(title: 'Category Budgets (optional)', size: 14, weight: FontWeight.w700, clr: AppColors.black),
              const SizedBox(height: 4),
              MyText(title: 'Set limits per category', size: 11, weight: FontWeight.w400, clr: AppColors.greyText),
              const SizedBox(height: 12),
              ...AppConstants.expenseCategories.map((cat) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: MyText(title: cat, size: 12, weight: FontWeight.w500, clr: AppColors.black),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: InputTextField(
                        controller: controller.categoryControllers[cat],
                        hint: '0',
                        textInputType: TextInputType.number,
                        inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d*'))],
                        padding: true,
                      ),
                    ),
                  ],
                ),
              )),
              const SizedBox(height: 24),
              Obx(() => CustomButton(
                text: controller.isSaving.value ? 'Saving...' : 'Save Budget',
                onPress: controller.isSaving.value ? null : controller.saveBudget,
                textColor: AppColors.white,
                boxColor: AppColors.primary,
                isCupertinoIndicator: controller.isSaving.value,
              )),
              const SizedBox(height: 40),
            ],
          )),
        ),
      ),
    );
  }

  Widget _label(String text) =>
      MyText(title: text, size: 13, weight: FontWeight.w600, clr: AppColors.black);
}
