import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/Userdetails.dart';
import '../models/user_details_2.dart';
import '../services/auth_controller.dart';
import '../services/firstore_data.dart';
import '../widgets/imput_field.dart';

class InsertUserPage extends StatefulWidget {
  static const id = 'InsertUserPage';
  final UserDetails2? userDetails;
  InsertUserPage({this.userDetails});
  @override
  State<InsertUserPage> createState() => _InsertUserPageState();
}

class _InsertUserPageState extends State<InsertUserPage> {
  User? user = AuthController().auth.currentUser;
  final companyController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final noteController = TextEditingController();
  Widget buildAddDetailsBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5,
        onPressed: () async {
          if (companyController.text == '' ||
              emailController.text == '' ||
              nameController.text == '') {
            Get.snackbar(
              'About user',
              'Add user message',
              backgroundColor: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              titleText: const Text(
                'Fill all required Fields',
                style: TextStyle(color: Colors.red),
              ),
            );
          } else {
            const Center(
              child: CircularProgressIndicator(),
            );
            await FirebaseFirestore.instance
                .collection('userData2')
                .doc(user?.uid)
                .collection('info')
                .doc('stuff')
                .set({
              'companyName': companyController.text,
              'email': emailController.text,
              'firstName': nameController.text,
            }).onError((error, stackTrace) => Get.snackbar(
                      'About user',
                      'Add user message',
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      titleText: const Text(
                        'Failed to add details check Internet Connection',
                        style: TextStyle(color: Colors.red),
                      ),
                    ));
          }
          Navigator.pop(context);
        },
        padding: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: Colors.orange,
        child: const Center(
          child: Text(
            'Add',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(
          child: Text('User Page'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              size: 20, color: Colors.orange),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                child: Container(
                    padding: const EdgeInsets.only(left: 3, right: 3),
                    child: const Text('Add Details')),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      MyInputField(
                        title: 'Company Name',
                        hint: 'Microsoft',
                        controller: companyController,
                      ),
                      MyInputField(
                        title: 'Email',
                        hint: '123@gmail.com',
                        controller: emailController,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      MyInputField(
                        title: 'First Name',
                        hint: 'john',
                        controller: nameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      buildAddDetailsBtn()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
