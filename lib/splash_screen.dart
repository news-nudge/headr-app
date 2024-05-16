

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:headr/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.primaryColor,
      body: Center(child: SvgPicture.asset(appIcon)),
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
        ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(appLogo,width: 20.w,height: 20.w,)),
        SizedBox(height: 2.h,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Hea",style: Get.textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold
            ),),
            Text("dr",style: Get.textTheme.titleLarge!.copyWith(
              color: Get.theme.primaryColor,
              fontWeight: FontWeight.bold
            ),)
          ],
        )
      ],
    );
  }
}
