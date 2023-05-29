import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keeper/Screens/edit_page.dart';
import 'package:keeper/services/auth_controller.dart';
import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keeper/widgets/calculations.dart';
import 'package:keeper/models/tasks.dart';
import 'package:intl/intl.dart';
import '../../models/tasks.dart';
import 'add_task_page.dart';
import 'main_page.dart';

class BarItemPage extends StatefulWidget {
  static const id = 'BarItemPage';

  @override
  State<BarItemPage> createState() => _BarItemPageState();
}

class _BarItemPageState extends State<BarItemPage> {
  List<Object> documentList = [];
  final auth = FirebaseAuth.instance;
  final user = AuthController().auth.currentUser;
  final value = NumberFormat("#,##0", "en_US");
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    _addDateBar() {
      return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: Colors.orange,
          selectedTextColor: Colors.white,
          monthTextStyle: const TextStyle(
            color: Colors.grey,
          ),
          dayTextStyle: const TextStyle(
            color: Colors.grey,
          ),
          dateTextStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
          onDateChange: (date) {
            setState(() {
              _selectedDate = date;
            });
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.black12),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, bottom: 25, right: 20, left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Today\'s  Transactions',
                        style: GoogleFonts.bebasNeue(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          color: Colors.orange,
                          Icons.arrow_back_ios_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, MainPage.id);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, AddTaskPage.id);
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                          ),
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Add Task',
                                style: TextStyle(color: Colors.white),
                              ),
                              IconButton(
                                iconSize: 30,
                                color: Colors.orange,
                                onPressed: () {
                                  Navigator.pushNamed(context, AddTaskPage.id);
                                },
                                icon: const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  _addDateBar()
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .collection('tasks')
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
                            Calculations.getTotalBalance(storedocs.asMap());
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  TaskModel task = TaskModel.fromJson(
                                      snapshot.data.docs[index]);
                                  if (task.date ==
                                      DateFormat.yMd().format(_selectedDate)) {
                                    return SingleChildScrollView(
                                      child: Center(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration:
                                                          const BoxDecoration(
                                                              color:
                                                                  Colors.orange,
                                                              shape: BoxShape
                                                                  .circle),
                                                      child: const Center(
                                                        child:
                                                            Icon(Icons.person),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      width: 15,
                                                    ),
                                                    Container(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            task.item,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            task.date,
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 12,
                                                                color: Colors
                                                                    .grey),
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
                                                      'N${value.format(int.parse(task.amount))}',
                                                      style: TextStyle(
                                                          color: task.type ==
                                                                  'Income'
                                                              ? Colors.green
                                                              : Colors.red),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                _showBottomSheet(context, task);
                                              },
                                              child: const Text(
                                                'see more',
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                  left: 65, top: 8),
                                              child: Divider(
                                                thickness: 0.8,
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
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
                            const Center(
                              child: Text('Add a task/Transaction'),
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
                ),
              ],
            ),
          ),
        ],
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
          )),
    );
  }

  _showBottomSheet(
    BuildContext context,
    TaskModel task,
  ) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: MediaQuery.of(context).size.height * 0.39,
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
            Container(),
            _bottomSheetButton(
                label: 'Delete Transaction',
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('tasks')
                      .doc(task.id)
                      .delete();
                  Get.back();
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
            _bottomSheetButton(
                label: 'Edit Transaction',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPage(
                        task: task,
                      ),
                    ),
                  );
                },
                color: Colors.red[300]!,
                context: context),
          ],
        ),
      ),
    );
  }
}
