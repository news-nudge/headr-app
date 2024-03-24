
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:headr/controllers/profile_controller.dart';
import 'package:headr/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final ProfileController pc = Get.find();
  final AuthController ac = Get.find();

  bool notificationBool = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 3.h,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.back();
                      },
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent
                        ),
                        child: const Center(child: Icon(Icons.chevron_left_rounded),),
                      ),
                    ),
                    Text("Profile",style: Get.textTheme.titleLarge,),
                    SizedBox(width: 10.w,)
                  ],
                ),
              ),

              SizedBox(height: 4.h,),
              if (pc.currentUser.value==null) Stack(
                children: [
                  SvgPicture.asset(profileBackground,width: 100.w,height: 20.h,fit: BoxFit.cover,),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Save your Preferences",style: Get.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold
                        ),),
                        SizedBox(height: 1.h,),
                        Text("Sign in to save your bookmarks",style: Get.textTheme.bodySmall,),
                        SizedBox(height: 3.h,),
                        GestureDetector(
                          onTap: (){
                            openSignUpBottomSheet(context);
                          },
                          child: Container(
                            width: 55.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(3.w),
                              child: Row(
                                children: [
                                  SvgPicture.asset(googleIcon),
                                  SizedBox(width: 3.w,),
                                  Text("Continue with Google",style: Get.textTheme.titleSmall!.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                  ),)
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
              else Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 10.w,
                    backgroundColor: Colors.transparent,
                    backgroundImage: CachedNetworkImageProvider(
                      pc.currentUser.value!.userPic.toString(),
                    ),
                  ),
                  SizedBox(height: 2.h,),
                  Text("${pc.currentUser.value?.name}",style: Get.textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold
                  ),),
                  SizedBox(height: 1.h,),
                  Text("${pc.currentUser.value?.userEmail}",style: Get.textTheme.titleSmall!.copyWith(
                    color: Colors.white.withOpacity(0.5)
                  ),)
                ],
              ),

              SizedBox(height: 3.h,),
              buildProfileRows(context,bookmarkDone,'My Bookmarks',const Icon(Icons.chevron_right_rounded)),
              buildProfileRows(context,notificationIcon,'Notifications',buildNotificationSwitch(context)),
              buildProfileRows(context,newsInterestIcon,'News Interest',const Icon(Icons.chevron_right_rounded)),
              buildProfileRows(context,feedbackIcon,'Give Feedback',const Icon(Icons.chevron_right_rounded)),
              buildProfileRows(context,privacyPolicyIcon,'Privacy Policy',const Icon(Icons.chevron_right_rounded)),
              buildProfileRows(context,termsIcon,'Terms & Conditions',const Icon(Icons.chevron_right_rounded)),
              buildProfileRows(context,logoutIcon,'Logout',const Icon(Icons.chevron_right_rounded)),


            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotificationSwitch(BuildContext context){
    return Switch.adaptive(
      activeColor: Get.theme.primaryColor,
      inactiveTrackColor: const Color.fromRGBO(58, 59, 61, 1),
      value: notificationBool,
      onChanged: (value){
        if(ac.userExistence() == true){
          setState(() {
            notificationBool = !notificationBool;
          });
        }else{
          openSignUpBottomSheet(context);
        }
      },
    );
  }

  Column buildProfileRows(BuildContext context, String leadingIcon,String title, Widget trailing) {
    return Column(
              children: [
                Divider(thickness: 1, color: Colors.grey.withOpacity(0.3),),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Opacity(
                    opacity: loginCondition(context,title) == true
                        ? 1
                        : 0.5,
                    child: GestureDetector(
                      onTap: ()async{
                        if(loginCondition(context, title) == true){
                          if(title == 'Logout'){
                            final SharedPreferences prefs = await SharedPreferences.getInstance();

                            await prefs.remove('feedPrefs');
                            await GoogleSignIn().disconnect().then((value) async{
                              await FirebaseAuth.instance.signOut();
                            });

                            successToast('Logged out from account');
                          }
                        }else{
                          openSignUpBottomSheet(context);
                        }
                      },
                      child: Row(
                        children: [
                          SvgPicture.asset(leadingIcon),
                          SizedBox(width: 5.w,),
                          Text(title,style: Get.textTheme.titleMedium,),
                          const Spacer(),
                          trailing
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
  }

  bool loginCondition(BuildContext context,String title){
    if(title == 'My Bookmarks' || title == 'Notifications' || title=='News Interest'){
      if(ac.userExistence() == true){
        return true;
      }else{
        return false;
      }
    }else{
      return true;
    }
  }
}
