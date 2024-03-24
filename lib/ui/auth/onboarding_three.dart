import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../splash_screen.dart';

class OnboardingThree extends StatelessWidget {
  const OnboardingThree({super.key});

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
                  Text("Ready to\nDive in!",style: Get.textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.bold
                  ),),
                ],
              ),

              SizedBox(height: 3.h,),
              Row(
                children: [
                  SizedBox(
                    width: 80.w,
                    child: Text("You're all set to experience bite-sized news updates at your fingertips. Start exploring now and stay ahead with NewsNudge!",
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