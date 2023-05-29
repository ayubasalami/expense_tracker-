import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:keeper/Screens/nav_pages/home_page.dart';
import 'package:keeper/Screens/nav_pages/main_page.dart';
import 'package:keeper/models/tasks.dart';
import '../services/auth_controller.dart';
import '../widgets/imput_field.dart';

class EditPage extends StatefulWidget {
  final TaskModel? task;
  EditPage({this.task});
  static const id = 'EditPage';

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  User? user = AuthController().auth.currentUser;
  final itemController = TextEditingController();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  late int balance = 3000;
  int? amount;
  String type = 'Income';
  @override
  Widget build(BuildContext context) {
    Widget buildEditTransactionBtn(TaskModel? task) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 25),
        width: double.infinity,
        child: RaisedButton(
          elevation: 5,
          onPressed: () async {
            if (itemController.text == '' ||
                noteController.text == '' ||
                amountController.text == '') {
              Get.snackbar(
                'About Transaction',
                'Edit Transaction message',
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
                  .collection('users')
                  .doc(user?.uid)
                  .collection('tasks')
                  .doc(task?.id)
                  .update({
                'note': noteController.text,
                'item': itemController.text,
                'time': _startTime,
                'userId': user!.uid,
                'type': type,
                'amount': amountController.text,
                'date': DateFormat.yMd().format(_selectedDate),
              }).onError((error, stackTrace) => Get.snackbar(
                        'About Transaction',
                        'Edit Transaction message',
                        backgroundColor: Colors.white,
                        snackPosition: SnackPosition.BOTTOM,
                        titleText: const Text(
                          'Failed to Edit Transaction check Internet Connection',
                          style: TextStyle(color: Colors.red),
                        ),
                      ));
              Navigator.pushNamed(context, MainPage.id);
            }
          },
          padding: const EdgeInsets.all(15),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          color: Colors.orange,
          child: const Text(
            'Edit Transaction',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Center(
          child: Text('Edit Transaction'),
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
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Card(),
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
                          title: 'Item',
                          hint: 'Enter an Item',
                          controller: itemController,
                        ),
                        MyInputField(
                          title: 'Note',
                          hint: 'Enter a note',
                          controller: noteController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MyInputField(
                          title: 'Time',
                          hint: _startTime,
                          widget: IconButton(
                            onPressed: () {
                              _getTimeFromUser(isStartTime: true);
                            },
                            icon: const Icon(
                              Icons.access_time_rounded,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyInputField(
                          title: 'Date',
                          hint: DateFormat.yMd().format(_selectedDate),
                          widget: IconButton(
                            onPressed: () {
                              _getDateFromUser();
                            },
                            icon: const Icon(
                              Icons.calendar_today_outlined,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                        MyInputField(
                          onChanged: (val) {
                            try {
                              amount = int.parse(val);
                            } catch (e) {}
                          },
                          title: 'Amount',
                          hint: 'Enter Amount',
                          keyboardType: TextInputType.number,
                          controller: amountController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ChoiceChip(
                              selectedColor:
                                  type == 'Income' ? Colors.green : Colors.grey,
                              label: Text(
                                'Money In',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: type == 'Income'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selected: type == 'Income' ? true : false,
                              onSelected: (val) {
                                if (val) {
                                  setState(() {
                                    type = 'Income';
                                  });
                                }
                              },
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            ChoiceChip(
                              selectedColor:
                                  type == 'Expense' ? Colors.red : Colors.grey,
                              label: Text(
                                'Money Out',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: type == 'Expense'
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              selected: type == 'Expense' ? true : false,
                              onSelected: (val) {
                                if (val) {
                                  setState(() {
                                    type = 'Expense';
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                        buildEditTransactionBtn(widget.task)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formartedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('Time cancelled');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formartedTime;
      });
    } else if (isStartTime == false) {}
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(
          _startTime.split(':')[0],
        ),
        minute: int.parse(
          _startTime.split(':')[1].split(' ')[0],
        ),
      ),
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2022),
      firstDate: DateTime(2015),
      lastDate: DateTime(2250),
    );
    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
      return null;
    }
  }
}
