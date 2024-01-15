import 'dart:math';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/routes.dart';
import 'package:gf_mobile/services/object/putObjectSync.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/state/AppAuthNotifier.dart';
import 'package:gf_mobile/state/BucketNotifier.dart';
import 'package:gf_mobile/state/ObjectNotifier.dart';
import 'package:gf_mobile/state/SPNotifier.dart';
import 'package:gf_mobile/theme/theme_controller.dart';
import 'package:gf_mobile/theme/themes.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  Get.put(ThemeController());

  Workmanager().initialize(startBackgroundUpload, isInDebugMode: true);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => AddressNotifier()),
    ChangeNotifierProvider(create: (_) => AuthNotifier()),
    ChangeNotifierProvider(create: (_) => SPNotifier()),
    ChangeNotifierProvider(create: (_) => BucketNotifier()),
    ChangeNotifierProvider(create: (_) => ObjectNotifier())
  ], child: const GFMobile()));
}

class GFMobile extends StatefulWidget {
  const GFMobile({super.key});

  @override
  State<GFMobile> createState() => _GFMobileState();
}

class _GFMobileState extends State<GFMobile> with WidgetsBindingObserver {
  ThemeController themeController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive) {
      lockApp();
    } else if (state == AppLifecycleState.resumed) {
      unlockApp();
    }
  }

  void unlockApp() {
    // Get.back();
  }

  void lockApp() {
    // Get.to(() => LockScreenWidget());
  }

  @override
  Widget build(BuildContext context) {
    final isPlatformDark = themeController.isDarkMode.value;
    final initTheme = isPlatformDark ? primaryThemeData : lightModeThemeData;
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    authNotifier.init();

    return ThemeProvider(
        initTheme: initTheme,
        builder: (context, themeData) {
          return GetMaterialApp(
            title: 'Greenfield',
            theme: themeData,
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
            darkTheme: primaryThemeData,
            debugShowCheckedModeBanner: false,
          );
        });
  }
}

class LockScreenWidget extends StatelessWidget {
  LockScreenWidget({super.key});

  final List<String> lockScreenTextToAttract = [
    "Knock, knock! Who's there? Not you, yet.",
    "I'm locked more than a teenager's diary!",
    "Hello from the other side (of the lock screen)!",
    "Slide to unlock... Or maybe don't. I need a break.",
    "I'm like a treasure, locked away and waiting!",
    "Go ahead, make my day. Try the password.",
    "This is not the screen you are looking for. Move along.",
    "Password incorrect. But nice try!",
    "You shall not pass! Without the correct password.",
    "Ever heard of a phone taking a nap? Well, here you go.",
    "I'm just a locked screen, standing in front of a user, asking to be unlocked.",
    "Why did the phone screen lock itself? To get to the other side!",
    "If you guess the password, I'll grant you three wishes.",
    "I’m not saying I don’t trust you, but... well, that’s exactly what I’m saying.",
    "Swiper, no swiping!",
    "You miss 100% of the passwords you don’t try.",
    "I'm the Fort Knox of lock screens. Good luck!",
    "Roses are red, violets are blue, the password's a secret, not telling you.",
    "If at first, you don't succeed, try, try again. But maybe not here.",
    "I'm like a secret agent, but just a phone. Top secret stuff inside!",
    "This lock screen is more secure than Area 51.",
    "I’d tell you the password, but then I’d have to lock you out forever.",
    "I'm not lazy, I'm just on energy-saving mode.",
    "Lock screen or modern art? Discuss.",
    "I bet you can't unlock me on your first try!",
    "Are you a hacker in disguise? Prove it!",
    "Password tip: It’s not '1234'. Don’t even try it.",
    "If you can read this, you’re too close to my phone.",
    "This phone is sleeping. Come back later.",
    "Do not disturb. Epic game in progress inside.",
    "Keep calm and enter the right password.",
    "Unlocked phones spill secrets. Trust me, I know.",
    "If I had a dollar for every login attempt…",
    "Remember, with great power comes great responsibility to remember your password.",
    "Lookin’ for the key to my heart? Try the password first!",
    "I’m locked up tighter than a jar of pickles.",
    "I mustache you to enter your password.",
    "This is your phone. I’m taking a personal day.",
    "Sorry, the password is not 'OpenSesame'.",
    "Locked out? Don’t worry, it’s just a phase.",
    "I could tell you the password, but then I’d have to self-destruct.",
    "If I had a face like yours, I’d protect it with a password too.",
    "Congratulations, you’ve found the world’s most stubborn lock screen!",
    "The lock screen is mightier than the sword.",
    "Out to lunch. If you need me, leave a password."
  ];

  @override
  Widget build(BuildContext context) {
    final randomText = lockScreenTextToAttract[
        Random().nextInt(lockScreenTextToAttract.length)];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SvgPicture.asset(
              'assets/logo/bnbchain.svg',
              height: 100,
              width: 100,
            ),
            const SizedBox(height: 20),
            const TitleText(title: "BNB GreenField"),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(randomText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
