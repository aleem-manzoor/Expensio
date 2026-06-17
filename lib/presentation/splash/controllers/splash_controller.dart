import 'package:get/get.dart';
import 'package:ppsc_preparation/app/config/global_var.dart';
import 'package:ppsc_preparation/app/routes/app_pages.dart';
import 'package:ppsc_preparation/data/model/user_model.dart';
import 'package:ppsc_preparation/data/provider/firebase/firebase_auth_service.dart';
import 'package:ppsc_preparation/data/provider/local_storage/local_db.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 3), _checkSession);
    super.onInit();
  }

  Future<void> _checkSession() async {
    final firebaseUser = FirebaseAuthService.currentUser;
    if (firebaseUser != null) {
      try {
        await firebaseUser.reload();
        Globals.userId = firebaseUser.uid;
        final profile = await FirebaseAuthService.getUserProfile(firebaseUser.uid);
        if (profile != null) {
          Globals.user = UserModel(
            firstName: profile['firstName'] as String?,
            lastName: profile['lastName'] as String?,
            phoneNumber: profile['phone'] as String?,
            email: profile['email'] as String?,
          );
        }
      } catch (_) {
        Globals.userId = firebaseUser.uid;
      }
      Get.offAndToNamed(Routes.MAIN);
    } else {
      final isShown = await LocalDB.getData('onBoarding');
      if (isShown != null) {
        Get.offAllNamed(Routes.LOGIN);
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }
}
