import 'package:keeper/Screens/nav_pages/Login_page.dart';
import 'package:keeper/Screens/nav_pages/main_page.dart';
import 'package:keeper/Screens/scroller_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  _initialScreen(User? user) {
    if (user == null) {
      print('Login Page');
      Get.offAll(() => SliderPage());
    } else {
      Get.offAll(() => MainPage());
    }
  }

  void register(
    String email,
    password,
  ) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      Get.snackbar(
        'About User',
        'User message',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Account Creation Failed',
          style: TextStyle(color: Colors.red),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }

  void Login(
    String email,
    password,
  ) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        'About Login',
        'Login message',
        backgroundColor: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        titleText: const Text(
          'Login Failed',
          style: TextStyle(color: Colors.red),
        ),
        messageText: Text(
          e.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
  }

  void Logout() async {
    await auth.signOut();
  }
}
