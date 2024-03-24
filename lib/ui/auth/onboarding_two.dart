import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../splash_screen.dart';

class OnboardingTwo extends StatelessWidget {
  const OnboardingTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 25.h,),
              LogoWidget(),
              SizedBox(height: 8.h,),

              Row(
                children: [
                  Text("Personalized News",style: Get.textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),

              SizedBox(height: 3.h,),
              Row(
                children: [
                  SizedBox(
                    width: 80.w,
                    child: Text("Tell us what topics interest you, and we'll curate a news feed just for you. Swipe left or right to select your favorite topics.",
                      style: Get.textTheme.titleSmall!.copyWith(
                      ),),
                  ),
                ],
              )

            ],
          ),
        )
    );
  }
}