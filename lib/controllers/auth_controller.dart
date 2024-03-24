

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:headr/ui/auth/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../ui/home_screen.dart';
import '../ui/auth/no_internet_screen.dart';

class AuthController extends GetxController{


  /// User Auth
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  RxList<String> feedPreferences = RxList<String>();

  /// Internet
  late StreamSubscription subscription;
  RxBool hasInternet = false.obs;
  RxBool googleBool = false.obs;

  @override
  void onInit() {
    super.onInit();
    subscription = Connectivity().onConnectivityChanged.listen((event) {
      if(event == ConnectivityResult.none){
        hasInternet.value = false;
      }else{
        hasInternet.value = true;
      }
    });

    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());

    ///The below function is a GetX feature
    ///Which listens to change in _user variable throughout the app
    ///If there is any change it will implement the given function

    // everAll([hasInternet,_user], _initializeApp);
    ever(hasInternet,_handleInternet);
    ever(_user,_initializeApp);

  }

  _initializeApp(dynamic parameters) async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var prefsList = prefs.getStringList('feedPrefs');
    if(hasInternet.value ==true) {
      if(prefsList!=null && prefsList.isNotEmpty && googleBool.value == false){
        Get.offAll(() => const HomeScreen());
      }else{
        Get.offAll(()=> const OnboardingScreen());
      }
    }
  }

  _handleInternet(bool? hasInternet) {
    log("Internet :$hasInternet");
    if(hasInternet == false){
      Get.to(()=>const NoInternetScreen());
    }else{
      _initializeApp(_user.value);
    }
  }

  bool userExistence () {
    if(FirebaseAuth.instance.currentUser == null){
      return false;
    }else{
      return true;
    }
  }

  Future<bool> checkUserExistence(String userId)async{
    var res = await FirebaseFirestore.instance
        .collection('users')
        .where('docId',isEqualTo: userId)
        .get().then((query) {
      var result = query.docs.map((e) => UserDetails.fromDocument(e)).toList();
      return result;
    });

    bool existenceOfUser = res.isNotEmpty;
    return existenceOfUser;
  }



  Future<void> googleSignIn()async{

    // googleBool.value = true;
    /// Open interactive google accounts
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    /// Get user details after account selection
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;

    /// Create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential).then((value) async{

      if (value.user != null) {
        ///Checking if the user Id already exists
        ///If yes: Then we direct the user to the drawer screen
        ///Else : We proceed to the on boarding section
        var userExists = await checkUserExistence(value.user!.uid);
        if (userExists) {
          Get.to(() => const HomeScreen());
        } else {
          await FirebaseFirestore.instance.collection('users').doc(value.user!.uid).set({
            'docId' : value.user!.uid,
            'name' : value.user?.displayName.toString(),
            'userPic' : value.user?.photoURL.toString(),
            'userEmail' : value.user?.email.toString(),
            'userPrefs' : [''],
            'fcmToken' : '',
            'apnsToken' : '',
          }).then((value) {
            Future.delayed(const Duration(seconds: 1),(){
              Get.offAll(()=> const HomeScreen());
            });
          });
        }
      }
    });
  }




}