import 'package:keeper/Screens/nav_pages/Login_page.dart';
import 'package:keeper/Screens/nav_pages/bar_item_page.dart';
import 'package:keeper/Screens/nav_pages/home_page.dart';
import 'package:keeper/Screens/nav_pages/my_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'add_task_page.dart';

class MainPage extends StatefulWidget {
  static const id = 'MainPage';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    HomePage(),
    BarItemPage(),
    AddTaskPage(),
    MyPage(),
  ];
  int currentIndex = 0;
  void onTap(int index) {
    setState(() {
      showDialog(
          context: context,
          builder: (context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          });
      currentIndex = index;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop(BuildContext context) =>
        MediaQuery.of(context).size.width >= 600;
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width < 600;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        // body: StreamBuilder<User?>(
        //   stream: FirebaseAuth.instance.authStateChanges(),
        //   builder: (context, snapshot) {
        //     if (snapshot.hasData) {
        //       return pages[currentIndex];
        //     } else {
        //       return LoginPage();
        //     }
        //   },
        // ),

        // body: pages[currentIndex],
        body: Row(
          children: [
            if (MediaQuery.of(context).size.width >= 640)
              NavigationRail(
                backgroundColor: Colors.grey[900],
                onDestinationSelected: (int index) {
                  setState(() {
                    pages[currentIndex];
                    currentIndex = index;
                  });
                },
                selectedIndex: currentIndex,
                destinations: const [
                  NavigationRailDestination(
                      icon: Icon(Icons.apps), label: Text('Home')),
                  NavigationRailDestination(
                      icon: Icon(Icons.storage_sharp), label: Text('Today')),
                  NavigationRailDestination(
                      icon: Icon(Icons.add), label: Text('Add Task')),
                  NavigationRailDestination(
                      icon: Icon(Icons.person), label: Text('My Page')),
                ],
              ),
            Expanded(
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return pages[currentIndex];
                  } else {
                    return LoginPage();
                  }
                },
              ),
            )
          ],
        ),
        bottomNavigationBar: MediaQuery.of(context).size.width < 640
            ? BottomNavigationBar(
                unselectedFontSize: 0,
                selectedFontSize: 0,
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.grey[900],
                onTap: onTap,
                currentIndex: currentIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey.withOpacity(0.5),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 0,
                items: const [
                  BottomNavigationBarItem(
                    label: 'Home',
                    icon: Icon(
                      Icons.apps,
                    ),
                  ),
                  BottomNavigationBarItem(
                    label: 'Bar',
                    icon: Icon(Icons.storage_sharp),
                  ),
                  BottomNavigationBarItem(
                    label: 'Add Task',
                    icon: Icon(Icons.add),
                  ),
                  BottomNavigationBarItem(
                    label: 'My Page',
                    icon: Icon(Icons.person),
                  ),
                ],
              )
            : null);
  }
}
