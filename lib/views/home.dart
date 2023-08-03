import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:gf_mobile/components/fab/MultiFab.dart';
import 'package:gf_mobile/components/grid/GGridView.dart';
import 'package:gf_mobile/theme/themes.dart';

class Main extends StatefulWidget {
  const Main({super.key, required this.title});

  final String title;

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          changeIndex(index);
        },
        children: [
          PageStorage(
              bucket: PageStorageBucket(),
              key: UniqueKey(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Expanded(child: GGridView(itemCount: 10)),
                  ],
                ),
              )),
          PageStorage(
              bucket: PageStorageBucket(),
              key: UniqueKey(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Expanded(child: GGridView(itemCount: 10)),
                  ],
                ),
              )),
          PageStorage(
              bucket: PageStorageBucket(),
              key: UniqueKey(),
              child: Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Column(
                  children: [
                    Expanded(child: GGridView(itemCount: 10)),
                  ],
                ),
              )),
        ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: const MultiFab(),
      bottomNavigationBar: FlashyTabBar(
        height: 55,
        selectedIndex: selectedIndex,
        showElevation: true,
        onItemSelected: (index) => setState(() {
          selectedIndex = index;
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        }),
        items: [
          FlashyTabBarItem(
              icon: const Icon(Icons.home),
              title: const Text('Home'),
              activeColor: textColor),
          FlashyTabBarItem(
              icon: const Icon(Icons.data_array),
              title: const Text('My Files'),
              activeColor: textColor),
          FlashyTabBarItem(
              icon: const Icon(Icons.settings),
              title: const Text('Settings'),
              activeColor: textColor),
        ],
      ),
    );
  }
}
