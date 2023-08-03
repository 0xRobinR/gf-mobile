// create routes for the app

import 'package:get/get.dart';
import 'package:gf_mobile/views/home.dart';
import 'package:gf_mobile/views/upload_file.dart';


class Routes {
  static const String home = '/home';
  static const String uploadFile = '/uploadFile';
}

class AppPages {
  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: Routes.uploadFile,
      page: () => const UploadFile(),
    ),
    GetPage(name: Routes.home, page: () => const Main(title: 'GreenField Mobile')),
  ];
}
