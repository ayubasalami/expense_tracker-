import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails2 {
  String id;
  String companyName;
  String email;
  String firstName;

  UserDetails2({
    required this.id,
    required this.companyName,
    required this.email,
    required this.firstName,
  });
  factory UserDetails2.fromJson(DocumentSnapshot snapshot) {
    return UserDetails2(
        companyName: snapshot['companyName'],
        email: snapshot['email'],
        firstName: snapshot['firstName'],
        id: snapshot.id);
  }
  factory UserDetails2.fromSnapshot(DocumentSnapshot snapshot) {
    return UserDetails2(
      companyName: snapshot['companyName'],
      email: snapshot['email'],
      firstName: snapshot['firstName'],
      id: snapshot.id,
    );
  }
}
