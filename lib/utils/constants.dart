

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/articles.dart';

const String appLogo = 'assets/images/new icon.png';
const String newSplash = 'assets/svg/new splash.svg';
const String profile = 'assets/svg/profile.svg';
const String bookmark = 'assets/svg/bookmark.svg';
const String bookmarkFilled = 'assets/svg/bookmark_filled.svg';
const String share = 'assets/svg/url.svg';
const String loginIcon = 'assets/svg/new login icon.svg';
const String splashImage = 'assets/images/splash.png';
const String onboarding1 = 'assets/images/o1.png';
const String onboarding2 = 'assets/images/o2.png';
const String onboarding3 = 'assets/images/o3.png';
const String onboarding4 = 'assets/images/o4.png';

const String likeButton = 'assets/svg/Like (1).svg';
const String likeFilledButton = 'assets/svg/Like Filled.svg';

/// Profile
const String profileBackground = 'assets/svg/profile_background.svg';
const String googleIcon = 'assets/svg/google.svg';
const String bookmarkDone = 'assets/svg/bookmark_done.svg';
const String notificationIcon = 'assets/svg/notification.svg';
const String newsInterestIcon = 'assets/svg/like.svg';
const String feedbackIcon = 'assets/svg/feedback.svg';
const String privacyPolicyIcon = 'assets/svg/policy.svg';
const String termsIcon = 'assets/svg/terms.svg';
const String logoutIcon = 'assets/svg/logout.svg';


/// Lottie
const String noInternet = 'assets/lottie/90478-disconnect.json';
// const String loader = 'assets/lottie/news-nudge-loader.json';
const String greenLoader = 'assets/lottie/green-loader.json';

void showLoadingAnimation(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (BuildContext context) {
      var w = MediaQuery.of(context).size.width*0.5;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Lottie.asset(greenLoader,width: w,height: w),),
        ],
      );
    },
  );
}

void openReportBottomSheet(BuildContext context,Article article) {
  showModalBottomSheet(
      backgroundColor: Colors.black,
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (context) =>
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            maxChildSize: 0.4,
            minChildSize: 0.2,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              var t = Theme.of(context);
              return Padding(
                padding: const EdgeInsets.only(left: 24.0,right: 24,bottom: 24,top: 15),
                child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 30.w,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h,),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text("You want to",style: t.textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),)),
                      SizedBox(height: 1.h,),
                      const Divider(color: Colors.white10,thickness: 2,),
                      SizedBox(height: 1.h,),
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);

                          },
                          child: Row(
                            children: [
                              const Icon(Icons.flag,color: Colors.white,),
                              SizedBox(width: 5.w,),
                              Text("Report",style: Get.textTheme.titleMedium,)
                            ],
                          )),
                      SizedBox(height: 2.h,),
                    ]),
              );
            },
          ));
}


void openSignUpBottomSheet(BuildContext context){
  final AuthController ac = Get.find();
  showModalBottomSheet(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (context) =>
          DraggableScrollableSheet(
            initialChildSize: 0.45,
            maxChildSize: 0.7,
            minChildSize: 0.4,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0,right: 24,bottom: 24,top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 30.w,
                        height: 5,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50)
                        ),
                      ),
                    ),
                    SizedBox(height: 3.h,),
                    SvgPicture.asset(loginIcon),
                    SizedBox(height: 3.h,),
                    Text("Unlock Exclusive Features!",style: Get.textTheme.titleLarge,),
                    SizedBox(height: 2.h,),
                    Text("Sign up now to unlock bookmarking and enjoy a personalized news journey. Don't miss out, join us today!",
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleSmall!.copyWith(
                        color: Colors.white.withOpacity(0.5)
                      ),
                    ),
                    SizedBox(height: 3.h,),
                    GestureDetector(
                      onTap: () async{
                        showLoadingAnimation(context);
                        await ac.googleSignIn();
                        // await GoogleSignIn().disconnect();
                      },
                      child: Container(
                        width: 70.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(googleIcon),
                            SizedBox(width: 3.w,),
                            Text("Sign up with Google",style: Get.textTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.bold
                            ),)
                          ],
                        ),
                      ),
                    )
                  ]),
              );
            },
          ));
}


void openLogoutBottomSheet(BuildContext context){
  showModalBottomSheet(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (context) =>
          DraggableScrollableSheet(
            initialChildSize: 0.18,
            maxChildSize: 0.7,
            minChildSize: 0.15,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return Padding(
                padding: const EdgeInsets.only(left: 24.0,right: 24,bottom: 16,top: 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          width: 30.w,
                          height: 5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50)
                          ),
                        ),
                      ),
                      SizedBox(height: 3.h,),
                      Text("Are you sure you want to logout?",style: Get.textTheme.titleMedium,),

                      SizedBox(height: 3.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Container(
                              width: 30.w,
                              height: 6.h,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Center(
                                child: Text("Go back",style: Get.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),
                          ),

                          GestureDetector(
                            onTap: () async{
                              showLoadingAnimation(context);
                              final SharedPreferences prefs = await SharedPreferences.getInstance();

                              await prefs.remove('feedPrefs');
                              await GoogleSignIn().disconnect().then((value) async{
                                await FirebaseAuth.instance.signOut();
                              });

                              Get.back();
                              successToast('Logged out from account');
                            },
                            child: Container(
                              width: 30.w,
                              height: 5.h,
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(8)
                              ),
                              child: Center(
                                child: Text("Logout",style: Get.textTheme.titleSmall!.copyWith(
                                    fontWeight: FontWeight.bold
                                ),),
                              ),
                            ),
                          ),
                        ],
                      )
                    ]),
              );
            },
          ));
}








successToast(String text){
  return  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0);
}

errorToast(String text){
  return  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0);
}