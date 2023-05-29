import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String userid;
  String item;
  String time;
  String date;
  String note;
  String amount;
  String type;
  String id;
  TaskModel(
      {required this.date,
      required this.item,
      required this.amount,
      required this.note,
      required this.userid,
      required this.time,
      required this.type,
      required this.id,
      uid});
  factory TaskModel.fromJson(DocumentSnapshot snapshot) {
    return TaskModel(
        date: snapshot['date'],
        item: snapshot['item'],
        amount: snapshot['amount'],
        note: snapshot['note'],
        userid: snapshot['userId'],
        time: snapshot['time'],
        type: snapshot['type'],
        id: snapshot.id);
  }

  factory TaskModel.fromSnapshot(DocumentSnapshot snapshot) {
    return TaskModel(
      date: snapshot['date'],
      item: snapshot['item'],
      amount: snapshot['amount'],
      note: snapshot['note'],
      userid: snapshot['userId'],
      time: snapshot['time'],
      type: snapshot['type'],
      id: snapshot.id,
    );
  }
}
