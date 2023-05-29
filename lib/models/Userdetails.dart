import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String id;
  String userid;
  String companyName;
  String email;
  String firstName;

  UserDetails({
    required this.id,
    required this.companyName,
    required this.email,
    required this.firstName,
    required this.userid,
  });
  factory UserDetails.fromJson(DocumentSnapshot snapshot) {
    return UserDetails(
        companyName: snapshot['companyName'],
        email: snapshot['email'],
        firstName: snapshot['firstName'],
        userid: snapshot['userId'],
        id: snapshot.id);
  }
  factory UserDetails.fromSnapshot(DocumentSnapshot snapshot) {
    return UserDetails(
      companyName: snapshot['companyName'],
      email: snapshot['email'],
      firstName: snapshot['firstName'],
      id: snapshot.id,
      userid: snapshot['userId'],
    );
  }
}
