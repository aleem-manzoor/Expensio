import 'package:get/get.dart';
import '../../../app/config/global_var.dart';
import '../../../app/routes/app_pages.dart';
import '../../../app/services/sync_service.dart';
import '../../../data/provider/firebase/firebase_auth_service.dart';
import '../../../data/provider/local_storage/local_db.dart';

class MainController extends GetxController {
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    SyncService.init(Globals.userId.isNotEmpty ? Globals.userId : 'local');
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> logout() async {
    await FirebaseAuthService.signOut();
    LocalDB.clear();
    Globals.userId = '';
    Globals.user = null;
    Globals.authToken = '';
    Get.offAllNamed(Routes.LOGIN);
  }
}
