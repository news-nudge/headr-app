

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/profile_controller.dart';
import 'package:headr/models/articles.dart';
import 'package:headr/ui/article_details.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/feed_controller.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

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
    pageController = PageController(initialPage: 0);
    initDynamicLinks(context);
    callPosition();
    super.initState();
  }

  void callPaginationFunction() async{
    List<Article> moreArticles = await fc.fetchMoreArticles();
    for(var article in moreArticles){
      if(fc.articles.contains(article)){
        continue;
      }else{
        fc.articles.add(article);
      }
    }

    for (var element in fc.articles) {
      log('article : ${element.articleTitle}');
    }
  }


  void callPosition() async{
    String location = await Helpers.determineAddress();
    uploadToAccount(location);
  }

  void uploadToAccount(String location) async{
    if(FirebaseAuth.instance.currentUser?.uid!=null){
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .update({
            'location': location
          });
      log('location uploaded');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Obx(() {
        return PageView.builder(
        controller: pageController,
        itemCount: fc.articles.length,
        pageSnapping: true,
        scrollDirection: Axis.vertical,
        onPageChanged: (int index){
          if(index == fc.articles.length -1){
            callPaginationFunction();
          }
        },
        itemBuilder: (context,index){
          if(fc.articles.isEmpty){
            return SizedBox(width: 100.w,height: 100.h,child: const Center(child: Text("Loading..."),),);
          }else{
            if(index == fc.articles.length - 1){
              return ArticleDetails(article: fc.articles[index],callPagination: true,);
            }else{
              return ArticleDetails(article: fc.articles[index],callPagination: false,);
            }
          }
        },
      );
      },)
    );
  }

  Future<void> initDynamicLinks(BuildContext context) async {
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async{
      await _handleDynamicLink(context,dynamicLinkData);
    }).onError((error) {
      log('onLink error');
      log(error.message);
    });

    final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();

    if(!context.mounted) return;
    await _handleDynamicLink(context,data);
  }

  _handleDynamicLink(BuildContext context,PendingDynamicLinkData? dynamicLinkData) async{
    final Uri? deeplink = dynamicLinkData?.link;
    log('Handling Deep Link | deepLink article id: ${deeplink?.path.substring(1)}');
    log('Deep Link Path : ${deeplink?.path}');

    if(deeplink!= null){
      showLoadingAnimation(context);
      String articleId = deeplink.path.substring(1);
      Article article = await fc.fetchParticularArticle(articleId.toString());
      Get.back();
      Get.to(()=> ArticleDetails(article: article,callPagination: false,));
    }
  }
}



