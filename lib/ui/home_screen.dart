

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/profile_controller.dart';
import 'package:headr/ui/article_details.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/feed_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late PageController pageController;
  final ProfileController pc = Get.put(ProfileController());
  final FeedController fc = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Obx(() {
        log('articles length : ${fc.articles.length}');
        return PageView.builder(
        controller: pageController,
        itemCount: fc.articles.length,
        pageSnapping: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index){
          if(fc.articles.isEmpty){
            return SizedBox(width: 100.w,height: 100.h,child: const Center(child: Text("Loading..."),),);
          }else{
            return ArticleDetails(article: fc.articles[index]);
          }
        },
      );
      },)
    );
  }
}
