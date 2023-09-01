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

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Add Files',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.create_new_folder),
                title: const Text('Create Bucket'),
                onTap: () {
                  // Implement folder list upload logic
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.upload_file),
                title: const Text('Upload File'),
                onTap: () {
                  // Implement file upload logic
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.drive_folder_upload),
                title: const Text('Upload Folder'),
                onTap: () {
                  // Implement folder list upload logic
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

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
                onPressed: () {
                  _showBottomSheet(context);
                },
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
