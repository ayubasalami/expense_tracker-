import 'package:auth/auth.dart';
import 'package:keeper/Screens/nav_pages/bar_item_page.dart';
import 'package:keeper/Screens/nav_pages/main_page.dart';
import 'package:keeper/services/auth_controller.dart';
import 'package:keeper/services/firstore_data.dart';
import 'package:keeper/widgets/imput_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AddTaskPage extends StatefulWidget {
  static const id = 'AddTaskPage';

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  User? user = AuthController().auth.currentUser;
  final itemController = TextEditingController();
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  final noteController = TextEditingController();
  late int balance = 3000;
  int? amount;
  String type = 'Income';

  Widget buildAddTaskBtn() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          if (itemController.text == '' ||
              noteController.text == '' ||
              amountController.text == '') {
            Get.snackbar(
              'About Transaction',
              'Add Transaction message',
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
            await FirestoreService()
                .insertTask(
                  itemController.text,
                  amountController.text,
                  DateFormat.yMd().format(_selectedDate),
                  _startTime,
                  noteController.text,
                  user!.uid,
                  type,
                )
                .onError((error, stackTrace) => Get.snackbar(
                      'About Transaction',
                      'Add Transaction message',
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                      titleText: const Text(
                        'Failed to add Transaction check Internet Connection',
                        style: TextStyle(color: Colors.red),
                      ),
                    ));
            Navigator.pushNamed(context, BarItemPage.id);
          }
        },
        child: const Text(
          'Add Transaction',
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Add Transaction',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          backgroundColor: Colors.grey[900],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined),
            color: Colors.orange,
            onPressed: () {
              Navigator.pushNamed(context, MainPage.id);
            },
          )),
      body: Container(
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
              Column(
                children: [
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
                            color:
                                type == 'Income' ? Colors.white : Colors.black,
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
                            color:
                                type == 'Expense' ? Colors.white : Colors.black,
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
                  buildAddTaskBtn(),
                ],
              ),
            ],
          ),
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

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formartedTime = pickedTime.format(context);
    if (pickedTime == null) {
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
}
