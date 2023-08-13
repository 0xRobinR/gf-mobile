import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gf_mobile/components/Text/TitleText.dart';
import 'package:gf_mobile/components/fab/MultiFab.dart';
import 'package:gf_mobile/components/grid/GGridView.dart';
import 'package:gf_mobile/components/list/GListView.dart';
import 'package:gf_mobile/components/list/GListView.dart';
import 'package:gf_mobile/components/list/GListView.dart';
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
    return Scaffold(
      body: SafeArea(
        child: PageStorage(
          bucket: PageStorageBucket(),
          child: _pages[selectedIndex],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.small(
          onPressed: (){},
          backgroundColor: textColor,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: FlashyTabBar(
        height: 55,
        backgroundColor: Colors.black54,
        selectedIndex: selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          selectedIndex = index;
        }),
        items: [
          FlashyTabBarItem(
              icon: const Icon(Icons.home, color: Colors.white),
              title: const Text('Home'),
              activeColor: textColor),
          FlashyTabBarItem(
              icon: const Icon(Icons.data_array, color: Colors.white),
              title: const Text('My Files'),
              activeColor: textColor),
          FlashyTabBarItem(
              icon: const Icon(Icons.settings, color: Colors.white),
              title: const Text('Settings'),
              activeColor: textColor),
        ],
      ),
    );
  }
}
