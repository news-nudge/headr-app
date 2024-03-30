import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/splash_screen.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                Text("Welcome to\nHeadr!",style: Get.textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold
                ),),
              ],
            ),

            SizedBox(height: 3.h,),
            Row(
              children: [
                SizedBox(
                  width: 80.w,
                  child: Text("Stay informed with the latest news in just a few minutes. Headr delivers concise summaries of top stories tailored to your interests.",
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
