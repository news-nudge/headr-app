

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:headr/models/user.dart';

class ProfileController extends GetxController{

  Rxn<UserDetails> currentUser = Rxn<UserDetails>();


  @override
  void onInit() async{
    super.onInit();

    if(FirebaseAuth.instance.currentUser!=null){
      currentUser.value = await fetchCurrentUser();
    }

  }

  Future<UserDetails> fetchCurrentUser() async{
    var res = await FirebaseFirestore.instance.collection('users')
        .where('docId',isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((value) {
          var result = value.docs.map((e) => UserDetails.fromDocument(e)).toList()[0];
          return result;
        });

    return res;
  }

}