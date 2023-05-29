import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/user_details_2.dart';

class FirestoreService extends StatefulWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  final value = NumberFormat("#,##0", "en_US");

  Future insertTask(
    String item,
    String amount,
    String date,
    String time,
    String note,
    String userId,
    String type,
  ) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser?.uid)
          .collection('tasks')
          .add({
        'note': note,
        'item': item,
        'time': time,
        'userId': userId,
        'type': type,
        'amount': amount,
        'date': date,
      });
    } catch (e) {}
  }

  Future insertUserDetails(String companyName, String email, String firstName,
      String? userId) async {
    try {
      await firestore.collection('userData').add({
        'companyName': companyName,
        'email': email,
        'firstName': firstName,
        'userId': userId
      });
    } catch (e) {}
  }

  Future insertUserDetails2(
    String companyName,
    String email,
    String firstName,
    String uid,
  ) async {
    try {
      await firestore
          .collection('userData2')
          .doc(auth.currentUser?.uid)
          .collection('info')
          .doc()
          .update({
        'companyName': companyName,
        'email': email,
        'firstName': firstName,
        'uid': uid
      });
    } catch (e) {}
  }

  @override
  State<FirestoreService> createState() => _FirestoreServiceState();
}

class _FirestoreServiceState extends State<FirestoreService> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
