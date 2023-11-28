// create routes for the app

import 'package:get/get.dart';
import 'package:gf_mobile/views/create_bucket/CreateBucket.dart';
import 'package:gf_mobile/views/home.dart';
import 'package:gf_mobile/views/onboard/OnBoardPage.dart';
import 'package:gf_mobile/views/splash_screen/SplashScreen.dart';
import 'package:gf_mobile/views/upload_file.dart';

class Routes {
  static const String splash = '/splash-screen';
  static const String onboard = '/onboard';
  static const String home = '/home';
  static const String uploadFile = '/uploadFile';
  static const String createBucket = '/create_bucket';
}

class AppPages {
  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: Routes.uploadFile,
      page: () => const UploadFile(),
    ),
    GetPage(
        name: Routes.home,
        page: () => const Main(title: 'GreenField Mobile'),
        transition: Transition.cupertinoDialog,
        transitionDuration: const Duration(milliseconds: 1500)),
    GetPage(
        name: Routes.onboard,
        page: () => const OnBoard(),
        transition: Transition.cupertino,
        transitionDuration: const Duration(milliseconds: 800)),
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(name: Routes.createBucket, page: () => const CreateBucket())
  ];
}
