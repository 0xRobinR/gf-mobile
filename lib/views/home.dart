import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:gf_mobile/theme/themes.dart';
import 'package:gf_mobile/views/my_files/GFFiles.dart';
import 'package:gf_mobile/views/settings/Settings.dart';
import 'package:gf_mobile/views/statistics/GFStats.dart';

class Main extends StatefulWidget {
  const Main({super.key, required this.title});

  final String title;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> with AutomaticKeepAliveClientMixin {
  int selectedIndex = 0;

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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ThemeSwitchingArea(
      child: Scaffold(
        body: SafeArea(
          child: PageStorage(
            bucket: PageStorageBucket(),
            child: _pages[selectedIndex],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: selectedIndex != 2
            ? FloatingActionButton(
                onPressed: () {},
                backgroundColor: textColor,
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: FlashyTabBar(
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
                icon: const Icon(Icons.data_array, color: Colors.white),
                title: const Text('My Files'),
                activeColor: Colors.white),
            FlashyTabBarItem(
                icon: const Icon(Icons.settings, color: Colors.white),
                title: const Text('Settings'),
                activeColor: Colors.white),
          ],
        ),
      ),
    );
  }
}
