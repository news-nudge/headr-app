

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../splash_screen.dart';
import '../../utils/constants.dart';

class ExpectationScreen extends StatefulWidget {
  const ExpectationScreen({super.key});

  @override
  State<ExpectationScreen> createState() => _ExpectationScreenState();
}

class _ExpectationScreenState extends State<ExpectationScreen> {

  final AuthController ac = Get.find();


  final List<String> expectationChoices = [
    'Breaking News','Politics','Technology','Education','Sports',
    'Health','Business & Finance','Lifestyle','Travel','Food','Arts',
    'Culture','Word News','AI','App development', 'Web dev', 'MMA',
    'Constituency','Regional','Devotional'
  ];

  List<String> selectedChoices = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(appIconWhite,width: 7.w,height: 7.w,)),
                      ),
                    ),
                    SizedBox(width: 3.w,),
                    Text("Hea",style: Get.textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold
                    ),),
                    Text("dr",style: Get.textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
                SizedBox(height: 6.h,),

                Row(
                  children: [
                    Text("What are your\nexpectations?",style: Get.textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),

                SizedBox(height: 3.h,),

                ChipsChoice.multiple(
                  padding: EdgeInsets.zero,
                  wrapped: true,
                  value: selectedChoices,
                  onChanged: (value) async {
                    setState(() {
                      selectedChoices = value;
                      ac.feedPreferences.value = value;
                    });
                  },
                  choiceItems: C2Choice.listFrom<String, String>(
                      source: expectationChoices,
                      value: (i, v) => v,
                      label: (i, v) => v),
                  choiceCheckmark: false,
                  choiceStyle: C2ChipStyle.filled(
                      selectedStyle: C2ChipStyle(
                        backgroundColor: Get.theme.primaryColor,
                        borderStyle: BorderStyle.solid,
                        foregroundStyle: const TextStyle(
                          color: Colors.black
                        )
                      ),
                      color: Colors.transparent,
                      borderWidth: 1,
                      borderOpacity: 1,
                      iconColor: Colors.white,
                      borderStyle: BorderStyle.solid,
                      borderRadius: BorderRadius.circular(5)),
                )

              ],
            ),
          ),
      )
    );
  }
}