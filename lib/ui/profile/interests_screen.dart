

import 'dart:developer';

import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:headr/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InterestsScreen extends StatefulWidget {
  const InterestsScreen({super.key});

  @override
  State<InterestsScreen> createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {

  final AuthController ac = Get.find();

  final List<String> expectationChoices = [
    'Breaking News','Politics','Technology','Education','Sports',
    'Health','Business & Finance','Lifestyle','Travel','Food','Arts',
    'Culture','Word News','AI','App development', 'Web dev', 'MMA',
    'Constituency','Regional','Devotional'
  ];

  List<String> selectedChoices = [];

  void fillSelectedChoices() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? feedPrefsList = prefs.getStringList('feedPrefs');
    log('feed prefs : $feedPrefsList');
    feedPrefsList?.forEach((choice) {
      selectedChoices.add(choice);
    });
  }

  @override
  void initState() {
    super.initState();
    fillSelectedChoices();
    Future.delayed(const Duration(milliseconds: 500),(){
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () async{
                if(selectedChoices.isNotEmpty){
                  showLoadingAnimation(context);

                  final SharedPreferences prefs = await SharedPreferences.getInstance();

                  prefs.setStringList('feedPrefs', selectedChoices);

                  List newUserPrefs = selectedChoices.cast<dynamic>();

                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid).update({
                    'userPrefs': newUserPrefs,
                  }).then((value) {
                    successToast('Interests successfully updated');
                    Get.back();
                    Get.back();
                  });
                }else{
                  errorToast('Please select atleast one topic');
                }
              },
              child: Container(
                width: 90.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(46, 46, 48, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text("Update",style: Get.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
                ),),),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // SizedBox(height: 3.h,),
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
                      Text("Your Interests",style: Get.textTheme.titleLarge,),
                      SizedBox(width: 5.w,)
                    ],
                  ),
                ),

                SizedBox(height: 5.h,),
                Row(
                  children: [
                    Text("What are your expectations?",style: Get.textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),

                SizedBox(height: 3.h,),

                ChipsChoice.multiple(
                  padding: EdgeInsets.zero,
                  wrapped: true,
                  value: selectedChoices,
                  onChanged: (value) async {
                    setState(() {
                      selectedChoices = value;
                      ac.feedPreferences.value = value;
                    });
                  },
                  choiceItems: C2Choice.listFrom<String, String>(
                      source: expectationChoices,
                      value: (i, v) => v,
                      label: (i, v) => v),
                  choiceCheckmark: false,
                  choiceStyle: C2ChipStyle.filled(
                      selectedStyle: C2ChipStyle(
                          backgroundColor: Get.theme.primaryColor,
                          borderStyle: BorderStyle.solid,
                          foregroundStyle: const TextStyle(
                              color: Colors.white
                          )
                      ),
                      color: Colors.transparent,
                      borderWidth: 1,
                      borderOpacity: 1,
                      iconColor: Colors.white,
                      borderStyle: BorderStyle.solid,
                      borderRadius: BorderRadius.circular(5)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
