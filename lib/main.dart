import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ppsc_preparation/data/provider/local_storage/local_db.dart';
import 'package:ppsc_preparation/firebase_options.dart';
import 'package:sizer/sizer.dart';
import 'package:ppsc_preparation/app/config/app_colors.dart';
import 'app/routes/app_pages.dart';
import 'app/services/connectivity_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox<String>('expenses');
  await Hive.openBox<String>('incomes');
  await Hive.openBox<String>('budgets');
  Get.put(LocalDB());
  Get.put(CheckConnectivity());
  runApp(Sizer(builder: (context, orientation, screenType) {
    return GetMaterialApp(
      title: "Beaverise",
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.white,
        primaryColor: AppColors.primary,
      ),
      // theme: ThemeData.dark(),
      // darkTheme: ThemeData.dark().copyWith(
      //   scaffoldBackgroundColor: const Color(0xFF020202),
      // ),
      // themeMode: ThemeMode.dark,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
            textScaler: const TextScaler.linear(1.1),
          ),
          child: child ?? Container(),
        );
      },
    );
  }));
}
