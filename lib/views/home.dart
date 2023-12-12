import 'dart:async';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gf_mobile/components/Loading.dart';
import 'package:gf_mobile/hooks/useAuthCall.dart';
import 'package:gf_mobile/state/AddressNotifier.dart';
import 'package:gf_mobile/theme/themes.dart';
import 'package:gf_mobile/views/create_bucket/AddFiles.dart';
import 'package:gf_mobile/views/my_files/GFFiles.dart';
import 'package:gf_mobile/views/settings/Settings.dart';
import 'package:gf_mobile/views/statistics/GFStats.dart';
import 'package:provider/provider.dart';

class Main extends StatefulWidget {
  const Main({super.key, required this.title});

  final String title;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with AutomaticKeepAliveClientMixin {
  int selectedIndex = 0;
  bool isLoading = true;
  bool isRequiredAuth = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkAuth();
    });
  }

  void checkAuth({bool? isPin}) async {
    Map<String, bool> auth =
        await checkAuthentication(context, isForcePin: isPin ?? false);
    if (auth.isNotEmpty && auth["isAuthEnabled"]! && auth["isAuthenticated"]!) {
      setState(() {
        isRequiredAuth = false;
        isLoading = false;
      });
    } else if (auth.isNotEmpty && auth["isAuthEnabled"]!) {
      setState(() {
        isRequiredAuth = true;
        isLoading = false;
      });

      Timer(const Duration(milliseconds: 500), () {
        Get.snackbar("Authentication Error",
            "Invalid authentication detected. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: Colors.white,
            duration: const Duration(milliseconds: 1200),
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            icon: const Icon(Icons.lock, color: Colors.white));
      });

      Get.back();
    } else {
      setState(() {
        isRequiredAuth = false;
        isLoading = false;
      });
    }
  }

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  changeIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  final List<Widget> _pages = [
    const GFStats(),
    const GFFiles(),
    const Settings(),
  ];

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return const AddFiles();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget lockedScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 50),
            const SizedBox(height: 20),
            const Text("App is locked"),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  checkAuth();
                },
                child: const Text("Unlock using Biometrics",
                    style: TextStyle(color: Colors.black))),
            ElevatedButton(
                onPressed: () {
                  checkAuth(isPin: true);
                },
                child: const Text("Unlock using PIN",
                    style: TextStyle(color: Colors.black)))
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<AddressNotifier>(
        builder: (context, addressNotifier, child) {
      return isRequiredAuth
          ? lockedScreen()
          : ThemeSwitchingArea(
              child: Scaffold(
                body: isLoading
                    ? SafeArea(
                        child: Center(
                          child: GFLoader(
                            width: 50,
                            dotColor: Theme.of(context).primaryColor,
                          ),
                        ),
                      )
                    : SafeArea(
                        child: PageStorage(
                          bucket: PageStorageBucket(),
                          child: _pages[addressNotifier.address != ""
                              ? selectedIndex
                              : 0],
                        ),
                      ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat,
                floatingActionButton: !isLoading &&
                        selectedIndex != 2 &&
                        addressNotifier.address != ""
                    ? FloatingActionButton(
                        onPressed: () {
                          _showBottomSheet(context);
                        },
                        backgroundColor: textColor,
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      )
                    : null,
                bottomNavigationBar: (isLoading ||
                        addressNotifier.address == "")
                    ? null
                    : FlashyTabBar(
                        height: 55,
                        backgroundColor: Colors.black,
                        selectedIndex: selectedIndex,
                        showElevation: true,
                        onItemSelected: (index) => setState(() {
                          selectedIndex = index;
                        }),
                        items: [
                          FlashyTabBarItem(
                              icon: const Icon(Icons.home, color: Colors.white),
                              title: const Text('Home'),
                              activeColor: Colors.white),
                          FlashyTabBarItem(
                              icon: const Icon(Icons.data_array,
                                  color: Colors.white),
                              title: const Text('My Files'),
                              activeColor: Colors.white),
                          FlashyTabBarItem(
                              icon: const Icon(Icons.settings,
                                  color: Colors.white),
                              title: const Text('Settings'),
                              activeColor: Colors.white),
                        ],
                      ),
              ),
            );
    });
  }
}
