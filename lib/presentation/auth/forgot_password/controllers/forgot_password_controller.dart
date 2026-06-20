import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensio/app/utils/utils.dart';
import 'package:expensio/data/provider/firebase/firebase_auth_service.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> forgetPassword() async {
    isLoading.value = true;
    update();
    try {
      await FirebaseAuthService.sendPasswordReset(emailController.text.trim());
      Utils.showToast(message: 'Password reset email sent! Check your inbox.');
      Get.back();
    } on FirebaseAuthException catch (e) {
      final msg = e.code == 'user-not-found'
          ? 'No account found with this email.'
          : 'Failed to send reset email. Try again.';
      Utils.showToast(message: msg);
    } catch (_) {
      Utils.showToast(message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
