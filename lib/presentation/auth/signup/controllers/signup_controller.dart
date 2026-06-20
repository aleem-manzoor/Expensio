import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:expensio/app/config/global_var.dart';
import 'package:expensio/app/routes/app_pages.dart';
import 'package:expensio/app/utils/utils.dart';
import 'package:expensio/data/model/user_model.dart';
import 'package:expensio/data/provider/firebase/firebase_auth_service.dart';

class SignupController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  RxBool showPassword = false.obs;
  RxBool showConfirmPassword = false.obs;
  RxBool isLoading = false.obs;
  bool isReceiveEmail = false;

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;
    update();
    try {
      final data = await FirebaseAuthService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phoneNumber,
      );
      Globals.userId = data['uid'] as String;
      Globals.user = UserModel(
        firstName: data['firstName'] as String?,
        lastName: data['lastName'] as String?,
        phoneNumber: data['phone'] as String?,
        email: data['email'] as String?,
      );
      Utils.showToast(message: 'Account created successfully!');
      Get.offAllNamed(Routes.MAIN);
    } on FirebaseAuthException catch (e) {
      Utils.showToast(message: _authError(e.code));
    } catch (_) {
      Utils.showToast(message: 'Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
      update();
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'This email is already registered. Please login.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Invalid email address.';
      default:
        return 'Registration failed. Please try again.';
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
