

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:headr/controllers/profile_controller.dart';
import 'package:headr/models/articles.dart';
import 'package:headr/ui/article_details.dart';
import 'package:headr/ui/profile.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
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
  final AuthController ac = Get.find();
  final FeedController fc = Get.find();

  final List<String> expectationChoices = [
    'Breaking News','Politics','Technology','Education','Sports',
    'Health','Business & Finance','Lifestyle','Travel','Food','Arts',
    'Culture','Word News','AI','App development', 'Web dev', 'MMA',
    'Constituency','Regional','Devotional'
  ];

  List<String> selectedChoices = [];

  @override
  void initState() {
    pageController = PageController(initialPage: 0);
    initDynamicLinks(context);
    handlePushNotificationParams();
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

      extendBodyBehindAppBar: false,
      extendBody: false,
      appBar: PreferredSize(
        preferredSize: Size(100.w, 40.h),
        child: Container(
          width: 100.w,
          height: 10.h,
          alignment: Alignment.bottomLeft,
          decoration: const BoxDecoration(
            color: Colors.black
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Builder(builder: (context){
                  return GestureDetector(
                    onTap: (){
                      Scaffold.of(context).openDrawer();
                    },
                    child: const Icon(Icons.menu,color: Colors.white,));
                }),
                SizedBox(width: 3.w,),
                Text("Headr",style: Get.textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 19
                ),),
                const Spacer(),
                Obx(() {
                  if(pc.currentUser.value == null){
                    return GestureDetector(
                      onTap: (){
                        Get.to(()=> const ProfileScreen(), transition: Transition.rightToLeft);
                      },
                      child: Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.transparent
                        ),
                        child: Center(child: SvgPicture.asset(profile,width: 5.w,),),
                      ),
                    );
                  }else{
                    return GestureDetector(
                      onTap: (){
                        Get.to(()=> const ProfileScreen(), transition: Transition.rightToLeft);
                      },
                      child: CircleAvatar(
                        radius: 4.w,
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(
                          pc.currentUser.value!.userPic.toString(),
                        ),
                      ),
                    );
                  }
                })
              ],
            ),
          ),
        ),
      ),
      drawer: Container(
          width: 70.w,
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h,),
                Center(child: Image.asset('assets/images/Headr White Icon.png',width: 30.w,)),


                SizedBox(height: 5.h,),

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
        ),
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

  void handlePushNotificationParams() {
    OneSignal.Notifications.addClickListener((event) async{
      log('NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $event');

      setState(() {
        String message = "Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
        log(message);
      });

      log('push notification additional params : ${event.notification.additionalData}');

      String articleDocId = event.notification.additionalData?['articleId'];
      var article = await fc.fetchParticularArticle(articleDocId);
      Get.to(()=> ArticleDetails(article: article, callPagination: false));
    });
  }
}



