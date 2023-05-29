import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keeper/Screens/insert_user_page.dart';
import 'package:keeper/Screens/nav_pages/spread_sheet_page.dart';
import 'package:keeper/services/auth_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/user_details_2.dart';
import '../../widgets/my_screen_button.dart';
import '../../widgets/profile_avatar.dart';
import 'main_page.dart';

class MyPage extends StatefulWidget {
  static const id = 'MyPage';
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(
          child: Text('My Page'),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_outlined,
              size: 20, color: Colors.orange),
          onPressed: () {
            Navigator.pushNamed(context, MainPage.id);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    const ProfileAvatar(),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('userData2')
                            .doc(user?.uid)
                            .collection('info')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            // print(snapshot.data);
                            final List storedocs = [];
                            snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map a = document.data() as Map<String, dynamic>;
                              storedocs.add(a);
                              a['id'] = document.id;
                            }).toList();
                            final data = snapshot.data.docs;
                            storedocs.add(data);
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  UserDetails2 user = UserDetails2.fromSnapshot(
                                      snapshot.data.docs[index]);
                                  return Center(
                                      child: Card(
                                    color: Colors.orange,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 3),
                                      child: Text(user.companyName,
                                          style: const TextStyle(
                                              fontSize: 22,
                                              color: Colors.black)),
                                    ),
                                  ));
                                });
                          } else if (snapshot.hasError) {
                            Get.snackbar(
                              'About user',
                              'User message',
                              backgroundColor: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              titleText: const Text(
                                'No name found',
                                style: TextStyle(color: Colors.red),
                              ),
                              messageText: const Text(
                                'fetching name....',
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          }
                          if (snapshot.data == null) {
                            const Center(
                              child: Text(''),
                            );
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return (Container());
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    My_screen_button(
                      onpressed: () {
                        Navigator.pushNamed(context, InsertUserPage.id);
                      },
                      icon: Icons.add,
                      text: 'Add a new transaction',
                    ),
                    My_screen_button(
                      onpressed: () {
                        Navigator.pushNamed(context, SpreadSheetPage.id);
                      },
                      icon: Icons.book,
                      text: 'View All Records',
                    ),
                    My_screen_button(
                      onpressed: () {},
                      icon: Icons.settings,
                      text: 'Contact Developer',
                    ),
                    My_screen_button(
                      onpressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InsertUserPage(),
                          ),
                        );
                      },
                      icon: Icons.help_center,
                      text: 'Edit Personal Info',
                    ),
                    My_screen_button(
                      onpressed: () {
                        _showBottomSheet();
                      },
                      icon: Icons.logout,
                      text: 'Log Out',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _showBottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: 230,
        color: Colors.grey[900],
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[300]),
            ),
            const Spacer(),
            _bottomSheetButton(
                label: 'Log Out',
                onTap: () {
                  AuthController.instance.Logout();
                },
                color: Colors.red[300]!,
                context: context),
            const SizedBox(
              height: 15,
            ),
            _bottomSheetButton(
                label: 'Close',
                onTap: () {
                  Get.back();
                },
                color: Colors.white,
                isClosed: true,
                context: context),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton(
      {required String label,
      required Function()? onTap,
      required Color color,
      bool isClosed = false,
      required BuildContext context}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
              width: 2, color: isClosed == true ? Colors.grey[300]! : color),
          borderRadius: BorderRadius.circular(20),
          color: isClosed == true ? Colors.transparent : color,
        ),
        child: Center(
          child: Text(
            label,
            style: isClosed
                ? GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey)
                : GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
          ),
        ),
      ),
    );
  }
}
