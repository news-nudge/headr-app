

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/auth_controller.dart';
import '../utils/constants.dart';

class Widgets {

  static void buildFeedbackBottomSheet(BuildContext context,TextEditingController controller, FocusNode focusNode) {
    final AuthController ac = Get.find();
    showModalBottomSheet(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      isScrollControlled: true,
      context: context,
      barrierColor: Colors.black.withOpacity(0.75),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (context) =>
          DraggableScrollableSheet(
            initialChildSize: 0.42,
            maxChildSize: 0.7,
            minChildSize: 0.4,
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24.0,right: 24,bottom: 24,top: 5),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                          SizedBox(height: 5.h,),
                          Text("Feedback",style: Get.textTheme.headlineSmall,),

                          SizedBox(height: 2.h,),

                          TextFormField(
                            focusNode: focusNode,
                            controller: controller,
                            expands: false,
                            style: Get.textTheme.titleMedium,
                            keyboardType: TextInputType.name,
                            minLines: 3,
                            maxLength: 240,
                            maxLines: 15,
                            onChanged: (v) async {

                            },
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

                          SizedBox(height: 3.h,),
                          Center(
                            child: GestureDetector(
                              onTap: () async{
                                showLoadingAnimation(context);
                              },
                              child: Container(
                                width: 80.w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                    color: Get.theme.primaryColor,
                                    borderRadius: BorderRadius.circular(8)
                                ),
                                child: Center(
                                  child: Text("Submit",style: Get.textTheme.titleSmall!.copyWith(
                                      fontWeight: FontWeight.bold
                                  ),),
                                ),
                              ),
                            ),
                          )
                        ]),
                  ),
                ));
            },
          ));
  }

}
