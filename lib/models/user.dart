import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetails {
  String? docId;
  String? name;
  String? userPic;
  String? userEmail;
  List? userPrefs;
  String? fcmToken;
  String? apnsToken;

  UserDetails(
      {this.docId,
      this.name,
      this.userPic,
      this.userEmail,
      this.userPrefs,
      this.fcmToken,
      this.apnsToken});

  factory UserDetails.fromDocument(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    var d = snapshot.data()!;
    return UserDetails(
      docId : d['docId'],
      name : d['name'],
      userPic : d['userPic'],
      userEmail : d['userEmail'],
      userPrefs : d['userPrefs'],
      fcmToken : d['fcmToken'],
      apnsToken : d['apnsToken'],
    );
  }
}
