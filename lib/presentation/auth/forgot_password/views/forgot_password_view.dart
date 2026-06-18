import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppsc_preparation/app/config/app_colors.dart';
import 'package:ppsc_preparation/app/shared_widgets/my_text.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      init: ForgotPasswordController(),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.lightWhite,
        body: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildForm(controller),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 60, 28, 40),
      decoration: const BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: Get.back,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white, size: 18),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.lock_reset_rounded, color: AppColors.white, size: 36),
          ),
          const SizedBox(height: 20),
          const Text(
            'Forgot password?',
            style: TextStyle(color: AppColors.white, fontSize: 28, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            'Enter your email to receive a reset link',
            style: TextStyle(color: AppColors.white.withValues(alpha: 0.75), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(ForgotPasswordController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 24),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Email address',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.black),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: 'you@example.com',
                hintStyle: const TextStyle(fontSize: 13, color: AppColors.lightText),
                prefixIcon: const Icon(Icons.email_outlined, color: AppColors.greyText, size: 20),
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.inputBorder)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.inputBorder)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
                errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.expense)),
                focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.expense, width: 1.5)),
              ),
              validator: (v) => !GetUtils.isEmail(v ?? '') ? 'Enter a valid email' : null,
            ),
            const SizedBox(height: 12),
            MyText(
              title: "We'll send a reset link to this email.",
              size: 12,
              weight: FontWeight.w400,
              clr: AppColors.greyText,
            ),
            const SizedBox(height: 36),
            Obx(() => GestureDetector(
              onTap: controller.isLoading.value
                  ? null
                  : () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (controller.formKey.currentState!.validate()) {
                        controller.forgetPassword();
                      }
                    },
              child: Container(
                width: double.infinity,
                height: 54,
                decoration: BoxDecoration(
                  gradient: controller.isLoading.value ? null : AppColors.primaryGradient,
                  color: controller.isLoading.value ? AppColors.primaryLight : null,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: controller.isLoading.value
                      ? []
                      : [BoxShadow(color: AppColors.primary.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))],
                ),
                child: Center(
                  child: controller.isLoading.value
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2.5))
                      : const Text('Send Reset Link', style: TextStyle(color: AppColors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
