


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:headr/controllers/profile_controller.dart';
import 'package:headr/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {

  final AuthController ac = Get.find();
  final ProfileController pc = Get.find();

  final TextEditingController feedbackController = TextEditingController();
  final FocusNode feedbackNode = FocusNode();


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
                if(feedbackController.text!=''){
                  showLoadingAnimation(context);
                  var feedbackDocId = const Uuid().v4();
                  await FirebaseFirestore.instance
                      .collection('feedback')
                      .doc(feedbackDocId).set({
                    'docId': feedbackDocId,
                    'from': pc.currentUser.value?.name.toString(),
                    'userId': pc.currentUser.value?.docId.toString(),
                    'email': pc.currentUser.value?.userEmail.toString(),
                    'pic': pc.currentUser.value?.userPic.toString(),
                    'feedback': feedbackController.text
                  }).then((value) {
                    successToast('Feedback successfully sent');
                    Get.back();
                    Get.back();
                  });
                }else{
                  errorToast('Kindly enter a few words in the text box');
                }
              },
              child: Container(
                width: 90.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: Get.theme.primaryColor,
                  // color: const Color.fromRGBO(46, 46, 48, 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text("Submit",style: Get.textTheme.titleLarge!.copyWith(
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
                      Text("Feedback",style: Get.textTheme.titleLarge,),
                      SizedBox(width: 5.w,)
                    ],
                  ),
                ),

                SizedBox(height: 5.h,),

                TextFormField(
                  focusNode: feedbackNode,
                  controller: feedbackController,
                  expands: false,
                  style: Get.textTheme.titleMedium,
                  keyboardType: TextInputType.name,
                  minLines: 5,
                  maxLength: 240,
                  maxLines: 25,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    fillColor: Colors.white10,
                    filled: true,
                    hintText: "We'd love to hear from you! Share your thoughts",
                    hintStyle:
                    Get.textTheme.titleMedium!.copyWith(color: Colors.white38),
                    focusColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
