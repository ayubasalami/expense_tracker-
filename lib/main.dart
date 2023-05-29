import 'package:keeper/Screens/insert_user_page.dart';
import 'package:keeper/Screens/nav_pages/bar_item_page.dart';
import 'package:keeper/Screens/nav_pages/add_task_page.dart';
import 'package:keeper/Screens/nav_pages/main_page.dart';
import 'package:keeper/Screens/nav_pages/my_page.dart';
import 'package:keeper/Screens/nav_pages/splash_screen.dart';
import 'package:keeper/Screens/nav_pages/spread_sheet_page.dart';
import 'package:keeper/services/auth_controller.dart';
import 'package:keeper/Screens/date_specific_spreadsheet.dart';
import 'package:keeper/Screens/scroller_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:keeper/Screens/nav_pages/Login_page.dart';
import 'package:keeper/Screens/nav_pages/registration_page.dart';
import 'package:get/get.dart';
import 'Screens/nav_pages/home_page.dart';
import 'package:flutter/material.dart';

const apiKey = 'AIzaSyDoVO2WkYQrtViU9wQhyNevmlBGSffTvtU';
const projectId = 'keeper-1b2a9';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyDoVO2WkYQrtViU9wQhyNevmlBGSffTvtU',
        appId: '1:690347629397:web:f919fca09c492445beeddc',
        messagingSenderId: '690347629397',
        projectId: "keeper-1b2a9",
        storageBucket: 'keeper.appspot.com'),
    // Uncomment the name for mobile version
    // name: 'keeper',
  ).then((value) => Get.put(AuthController()));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme:
          ThemeData(brightness: Brightness.dark, primarySwatch: Colors.orange),
      title: 'Keeper',
      debugShowCheckedModeBanner: false,
      initialRoute: SplashScreen.id,
      home: HomePage(),
      routes: {
        SpreadSheetPage.id: (context) => SpreadSheetPage(),
        SplashScreen.id: (context) => SplashScreen(),
        HomePage.id: (context) => HomePage(),
        AddTaskPage.id: (context) => AddTaskPage(),
        LoginPage.id: (context) => LoginPage(),
        BarItemPage.id: (context) => BarItemPage(),
        MainPage.id: (context) => MainPage(),
        SliderPage.id: (context) => SliderPage(),
        Registration_Page.id: (context) => Registration_Page(),
        MyPage.id: (context) => MyPage(),
        DateSpreadSheetPage.id: (context) => DateSpreadSheetPage(),
        InsertUserPage.id: (context) => InsertUserPage(),
      },
    );
  }
}
