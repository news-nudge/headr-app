

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/auth_controller.dart';
import '../utils/constants.dart';

class Widgets {

  static void buildFeedbackBottomSheet(BuildContext context,TextEditingController controller, FocusNode focusNode) {
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

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.prefixIcon,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.multiline = 1,
    this.prefixBool = true,
    this.suffix,
    this.type = TextInputType.text,
    required this.color,
  });

  final String hintText;
  final Widget? prefixIcon;
  final bool? prefixBool;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? multiline;
  final Widget? suffix;
  final void Function(String)? onChanged;
  final Color color;
  final TextInputType? type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      focusNode: focusNode,
      maxLines: multiline,
      keyboardType: type,
      style: Theme.of(context).textTheme.titleMedium,
      decoration: InputDecoration(
        // fillColor: const Color(0xff222222),
        // filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xff767676)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: color,
                  width: 2
              ),
              borderRadius: BorderRadius.circular(8)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: color,
                  width: 2
              ),
              borderRadius: BorderRadius.circular(8)
          ),
          border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: color,
                  width: 2
              ),
              borderRadius: BorderRadius.circular(8)
          ),
          prefixIcon: prefixBool! ? IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  prefixIcon!,
                  const SizedBox(width: 5,),
                  VerticalDivider(color: color)
                ],
              ),
            ),
          ) : null,

          suffixIcon: suffix
      ),
    );
  }
}

class HeadrBackButton extends StatelessWidget {
  const HeadrBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
    );
  }
}

class HeadrButton extends StatelessWidget {
  final String text;
  final double width;

  const HeadrButton({
    super.key, required this.text, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: 6.h,
        decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(
          child: Text(text, style: Theme
              .of(context)
              .textTheme
              .titleMedium!
              .copyWith(
              fontWeight: FontWeight.bold,
              // letterSpacing: 1.1,
              fontSize: 18
          ),),)
    );
  }
}


class BlackGradientContainer extends StatelessWidget {
  final Widget child;
  // bool? expandBool;
  const BlackGradientContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      constraints: BoxConstraints(
          minHeight: 30.h,
          maxHeight: 65.h
      ),
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0),
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
      child: child,
    );
    // if(expandBool == false){
    //   return Container(
    //     width: 100.w,
    //     constraints: BoxConstraints(
    //         minHeight: 30.h,
    //         maxHeight: 65.h
    //     ),
    //     alignment: Alignment.bottomCenter,
    //     decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //             colors: [
    //               Colors.black.withOpacity(0),
    //               Colors.black.withOpacity(0.8),
    //               Colors.black.withOpacity(0.9),
    //             ],
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomCenter
    //         )
    //     ),
    //     child: child,
    //   );
    // }
    // else{
    //   return Container(
    //     width: 100.w,
    //     constraints: BoxConstraints(
    //         minHeight: 30.h,
    //         maxHeight: 87.h
    //     ),
    //     alignment: Alignment.bottomCenter,
    //     decoration: BoxDecoration(
    //         gradient: LinearGradient(
    //             colors: [
    //               Colors.black.withOpacity(0),
    //               Colors.black.withOpacity(0.7),
    //               Colors.black.withOpacity(0.8),
    //               Colors.black.withOpacity(0.9),
    //               // Colors.black.withOpacity(1),
    //             ],
    //             begin: Alignment.topCenter,
    //             end: Alignment.bottomCenter
    //         )
    //     ),
    //     child: child,
    //   );
    // }
  }
}


