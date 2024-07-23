

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:headr/utils/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(child: Image.asset('assets/images/Headr White Icon.png',width: 25.h,height: 25.h,fit: BoxFit.cover,)),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("headr",style: Get.textTheme.headlineSmall!.copyWith(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),)
          ],
        ),
      ),
    );
  }
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: Get.theme.primaryColor,
            borderRadius: BorderRadius.circular(20)
          ),
          child: Center(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(appIconWhite,width: 17.w,height: 17.w,)),
          ),
        ),

        // ClipRRect(
        //     borderRadius: BorderRadius.circular(20),
        //     child: Image.asset(headrIcon,width: 20.w,height: 20.w,)),

        SizedBox(height: 1.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hea",style: Get.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold
            ),),
            Text("dr",style: Get.textTheme.titleLarge!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),)
          ],
        )
      ],
    );
  }
}
