

import 'dart:developer';

import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:headr/ui/home_screen.dart';
import 'package:headr/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'expectations_screen.dart';
import 'onboarding_one.dart';
import 'onboarding_three.dart';
import 'onboarding_two.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final AuthController ac = Get.find();

  final ValueNotifier<double> _valueNotifier = ValueNotifier(90);
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Column(
        children: [
          SizedBox(
            width: w,
            height: h*0.85,
            child: PageView(
              controller: _pageController,
              children: const [
                OnboardingOne(),
                OnboardingTwo(),
                OnboardingThree(),
                ExpectationScreen(),
              ],
              onPageChanged: (int index){
                setState(() {
                  if(index==0){
                    _valueNotifier.value = 90;
                  }else if(index==1){
                    _valueNotifier.value = 180;
                  }else if(index==2){
                    _valueNotifier.value = 270;
                  }else{
                    _valueNotifier.value = 360;
                  }
                });
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 4,
                  axisDirection: Axis.horizontal,
                  effect:  WormEffect(
                    activeDotColor: Theme.of(context).primaryColor,
                    dotColor: Colors.grey.withOpacity(0.5),
                    dotHeight: 8,
                    dotWidth: 8,
                    // activeDotScale: 1.3
                  ),
                ),
                if (_valueNotifier.value != 360) SizedBox(
                  width: 17.w,
                  height: 17.w,
                  child: DashedCircularProgressBar.aspectRatio(
                    aspectRatio: 6, // width ÷ height
                    valueNotifier: _valueNotifier,
                    progress: _valueNotifier.value,
                    startAngle: 0,
                    sweepAngle: 100,
                    foregroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Colors.white.withOpacity(0.1),
                    foregroundStrokeWidth: 5,
                    backgroundStrokeWidth: 5,
                    animation: true,
                    seekSize: 8,
                    seekColor: const Color(0xffeeeeee),
                    child: Center(
                      child: ValueListenableBuilder(
                        valueListenable: _valueNotifier,
                        builder: (_, double value, __) => GestureDetector(
                          onTap: (){
                            if(_valueNotifier.value==360){
                              _pageController.animateToPage(4, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                            }else if(_valueNotifier.value==90){
                              _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                            }else if(_valueNotifier.value == 180){
                              _pageController.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                            }else if(_valueNotifier.value == 270){
                              _pageController.animateToPage(3, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
                            }
                          },
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(
                                Icons.keyboard_arrow_right,
                                color: Get.theme.scaffoldBackgroundColor,
                                size: 25
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ) else InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: ()async{
                    if(ac.feedPreferences.isNotEmpty){
                      final SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setStringList('feedPrefs', ac.feedPreferences);

                      var res = prefs.getStringList('feedPrefs');
                      log('feed prefs : $res');
                      Get.offAll(()=> const HomeScreen());
                    }else{
                      errorToast('Please select few categories');
                    }
                  },
                  child: Container(
                    width: 25.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white)
                    ),
                    child: const Center(child: Text("Let's go"),),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}