import 'package:auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../models/tasks.dart';
import 'package:keeper/Screens/nav_pages/bar_item_page.dart';

class DateSpreadSheetPage extends StatefulWidget {
  static const id = 'DateSpreadSheetPage';
  @override
  State<DateSpreadSheetPage> createState() => _DateSpreadSheetPageState();
}

class _DateSpreadSheetPageState extends State<DateSpreadSheetPage> {
  final value = NumberFormat("#,##0", "en_US");
  final TextEditingController _searchController = TextEditingController();
  List _allResults = [];
  List _resultsList = [];
  late Future resultsLoaded;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(onSearchChanged);
  }

  onSearchChanged() {
    searchResultsList();
  }

  CollectionReference firestore = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('tasks');
  @override
  void dispose() {
    _searchController.removeListener(onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUserSnapshot();
  }

  searchResultsList() {
    var showResults = [];
    if (_searchController.text != '') {
      for (var tripSnapshot in _allResults) {
        var title = TaskModel.fromJson(tripSnapshot).date;
        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(tripSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUserSnapshot() async {
    final uid = user?.uid;
    var data = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tasks')
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return 'Completed';
  }

  final DateTime _selectedDate = DateTime.now();
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_outlined,
                size: 20, color: Colors.orange),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: Colors.grey[900],
          title: const Text(
            'Transaction Spread Sheet',
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 35),
            Center(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search by date',
                  fillColor: Colors.orange,
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: _resultsList.length,
                      itemBuilder: (context, index) {
                        TaskModel task =
                            TaskModel.fromSnapshot(_resultsList[index]);
                        return Card(
                          color: Colors.grey.shade800,
                          elevation: 5,
                          child: ListTile(
                            leading: Text(
                              task.date,
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.orange),
                            ),
                            title: Text(
                              (task.item),
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              task.note,
                              style: const TextStyle(fontSize: 10),
                            ),
                            trailing: Column(
                              children: [
                                Text(
                                  'N${value.format(int.parse(task.amount))}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: task.type == 'Income'
                                          ? Colors.green
                                          : Colors.red),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _showBottomSheet(context, task);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.blue),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      })),
            )
          ],
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, TaskModel task) {
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
                label: 'Delete Task',
                onTap: () {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(user?.uid)
                      .collection('tasks')
                      .doc(task.id)
                      .delete();
                  Navigator.pushNamed(context, BarItemPage.id);
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
