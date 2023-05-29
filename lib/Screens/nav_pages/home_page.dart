import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:keeper/Screens/nav_pages/add_task_page.dart';
import 'package:keeper/Screens/nav_pages/my_page.dart';
import 'package:keeper/Screens/nav_pages/spread_sheet_page.dart';
import 'package:flutter/material.dart';
import 'package:keeper/widgets/calculations.dart';
import 'package:get/get.dart';
import '../../models/user_details_2.dart';
import '../../services/auth_controller.dart';
import '../../models/tasks.dart';
import 'main_page.dart';

class HomePage extends StatefulWidget {
  static const id = 'HomePage';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final value = NumberFormat("#,##0", "en_US");

  final user = AuthController().auth.currentUser;
  @override
  Widget build(BuildContext context) {
    Widget cardIncome(String value) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.arrow_downward,
              size: 28,
              color: Colors.green[700],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Income',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w700),
              ),
            ],
          )
        ],
      );
    }

    Widget cardExpense(String value) {
      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(20),
            ),
            margin: const EdgeInsets.only(right: 8.0),
            child: Icon(
              Icons.arrow_upward,
              size: 28,
              color: Colors.red[700],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expense',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                    fontWeight: FontWeight.w700),
              ),
            ],
          )
        ],
      );
    }

    bool isDesktop(BuildContext context) =>
        MediaQuery.of(context).size.width >= 600;
    bool isMobile(BuildContext context) =>
        MediaQuery.of(context).size.width < 600;
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.info,
            color: Colors.orange,
          ),
          onPressed: () {
            Calculations.totalIncome > Calculations.totalExpense
                ? Get.snackbar(
                    'Status',
                    'Balance Message',
                    backgroundColor: Colors.white,
                    snackPosition: SnackPosition.BOTTOM,
                    titleText: const Center(
                      child: Text(
                        'You are Making Profit!',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  )
                : Calculations.totalIncome == Calculations.totalExpense
                    ? Get.snackbar(
                        'Status',
                        'Balance Message',
                        backgroundColor: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        titleText: const Center(
                          child: Text(
                            'Your books are balanced Perfectly!',
                            style: TextStyle(color: Colors.orange),
                          ),
                        ),
                      )
                    : Get.snackbar(
                        'Status',
                        'Balance Message',
                        backgroundColor: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        titleText: const Center(
                          child: Text(
                            'You are at a Loss!',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 2.0),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, MyPage.id);
              },
              icon: IconButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.orange,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, MyPage.id);
                },
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
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
                  snapshot.data!.docs.map((DocumentSnapshot document) {
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
                        return Container(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            'Welcome ${user.firstName}',
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white
                            )
                          ),
                        );
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return (Container());
              }),
          Stack(
            children: [
              Container(
                width: 500,
                margin: const EdgeInsets.all(12),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.orangeAccent],
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 8.0),
                  child: Column(
                    children: [
                      const Text(
                        'Total Balance',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Text(
                        'N${value.format(Calculations.totalBalance)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 12.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            cardIncome(
                                'N${value.format(Calculations.totalIncome)}'),
                            cardExpense(
                                'N${value.format(Calculations.totalExpense)}')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, right: 10),
            child: Column(
              children: [
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, SpreadSheetPage.id);
                    },
                    style: TextButton.styleFrom(
                        fixedSize: const Size.fromWidth(200),
                        backgroundColor: Colors.orange),
                    child: const Text(
                      'See All Records',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Center(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(user?.uid)
                          .collection('tasks')
                          .orderBy('note', descending: true)
                          .limit(5)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          final List storedocs = [];
                          snapshot.data!.docs.map((DocumentSnapshot document) {
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
                                TaskModel task = TaskModel.fromJson(
                                    snapshot.data.docs[index]);
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: const BoxDecoration(
                                                  color: Colors.orange,
                                                  shape: BoxShape.circle),
                                              child: const Center(
                                                child: Icon(Icons.person),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    task.item,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                        color: Colors.white),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    task.date,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              'N${value.format(int.parse((task.amount)))}',
                                              style: TextStyle(
                                                  color: task.type == 'Income'
                                                      ? Colors.green
                                                      : Colors.red),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 65, top: 8),
                                      child: Divider(
                                        thickness: 0.8,
                                      ),
                                    )
                                  ],
                                );
                              });
                        } else if (snapshot.hasError) {
                          Get.snackbar(
                            'About Task',
                            'User message',
                            backgroundColor: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            titleText: const Text(
                              'Failed Adding Task',
                              style: TextStyle(color: Colors.red),
                            ),
                            messageText: const Text(
                              'Something went wrong... Try again',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        if (snapshot.data == null) {
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AddTaskPage.id);
                              },
                              child: const Text(
                                'Add Your First Task!',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
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
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
