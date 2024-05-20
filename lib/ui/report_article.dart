

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/profile_controller.dart';
import 'package:headr/models/articles.dart';
import 'package:headr/widgets/widgets.dart';

import 'package:radio_group_v2/radio_group_v2.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uuid/uuid.dart';

import '../utils/constants.dart';

class ReportArticle extends StatelessWidget {
  final Article article;
  ReportArticle({super.key, required this.article});

  final ProfileController pc = Get.find();

  final RadioGroupController myController = RadioGroupController();
  final GlobalKey<RadioGroupState> horizontalGroupKey = GlobalKey<RadioGroupState>();

  final TextEditingController _complaintController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
                onTap: ()async{
                  var reportDocId = const Uuid().v4();
                  if(_complaintController.text==''){
                    FirebaseFirestore.instance
                        .collection('reported')
                        .doc(reportDocId).set({
                      'reportedAt': DateTime.now().millisecondsSinceEpoch,
                      'reportReason': myController.value.toString(),
                      'reportedBy': pc.currentUser.value?.name.toString(),
                      'userDocId': pc.currentUser.value?.docId.toString(),
                      'articleId': article.docId.toString(),
                    }).then((value) {
                      Navigator.pop(context);
                      successToast('Article has been reported');
                    });
                  }else{
                    FirebaseFirestore.instance
                        .collection('reported')
                        .doc(reportDocId).set({
                      'reportedAt': DateTime.now().millisecondsSinceEpoch,
                      'reportReason': _complaintController.text,
                      'reportedBy': pc.currentUser.value?.name.toString(),
                      'userDocId': pc.currentUser.value?.docId.toString(),
                      'articleId': article.docId.toString(),
                    }).then((value) {
                      Navigator.pop(context);
                      successToast('Article has been reported');
                    });
                  }
                },
                child: HeadrButton(text: 'Submit', width: 90.w))
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5.h,),
              Row(
                children: [
                  const HeadrBackButton(),
                  SizedBox(width: 5.w,),
                  Text("REPORT",style: Get.textTheme.titleLarge,),
                ],
              ),

              SizedBox(height: 5.h,),
              Text("Why are you reporting this article?",style: Get.textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),),

              SizedBox(height: 2.h,),
              RadioGroup(
                key: horizontalGroupKey,
                controller: myController,
                values: const ["Vulgar content", "Inappropriate content", "Incorrect information"],
                indexOfDefault: 0,
                orientation: RadioGroupOrientation.vertical,
                decoration: RadioGroupDecoration(
                  spacing: 30.0,
                  labelStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 17
                  ),
                  activeColor: Get.theme.primaryColor,
                ),
              ),

              SizedBox(height: 5.h,),
              Text("Something else?",style: Get.textTheme.titleMedium!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5
              ),),

              SizedBox(height: 1.h,),
              CustomTextFormField(
                hintText: 'Brief your concern here...',
                color: Colors.white10,
                prefixBool: false,
                controller: _complaintController,
                type: TextInputType.name,
                multiline: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
