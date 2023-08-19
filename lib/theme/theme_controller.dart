import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/theme/themes.dart';

class ThemeController extends GetxController {
  final storage = GetStorage(); // Access the storage
  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = storage.read('isDarkMode') ?? false;

    Get.changeTheme(isDarkMode.value ? primaryThemeData : lightModeThemeData);
  }

  toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    await storage.write('isDarkMode', isDarkMode.value);
  }
}
