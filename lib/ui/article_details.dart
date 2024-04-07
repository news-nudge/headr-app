


import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:headr/controllers/feed_controller.dart';
import 'package:headr/models/articles.dart';
import 'package:headr/ui/profile.dart';
import 'package:headr/utils/constants.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class ArticleDetails extends StatefulWidget {
  final Article article;
  const ArticleDetails({super.key, required this.article});

  @override
  State<ArticleDetails> createState() => _ArticleDetailsState();
}

class _ArticleDetailsState extends State<ArticleDetails> {

  final AuthController ac = Get.find();
  final FeedController fc = Get.find();

  RxBool expandContent = false.obs;
  RxBool bookmarkBool = false.obs;

  void checkBookmarkStatus() async{
    if(ac.auth.currentUser!=null){
      bookmarkBool.value = await fc.checkBookmarkStatus(widget.article.docId.toString());
    }
  }


  @override
  void initState() {
    super.initState();
    checkBookmarkStatus();
  }

  @override
  Widget build(BuildContext context) {

    var updatedAt = DateTime.parse(widget.article.uploadedAt.toString());
    log('time ${updatedAt.millisecondsSinceEpoch}');
    String updateTimeAgo = timeago.format(updatedAt,locale: 'en_short');

    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.article.articleImage.toString(),
          width: 100.w,
          height: 100.h,
          fit: BoxFit.cover,
        ),
        Column(
          children: [
            Container(
              width: 100.w,
              // height: 25.h,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Get.to(()=> const ProfileScreen());
                            },
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent
                              ),
                              child: Center(child: SvgPicture.asset(profile),),
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              openReportBottomSheet(context, widget.article);
                            },
                            child: Container(
                              width: 10.w,
                              height: 10.w,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent
                              ),
                              child: const Center(child: Icon(Icons.more_vert),),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h,),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: 100.w,
              // height: 50.h,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0),
                        Colors.black.withOpacity(0.9),
                        Colors.black.withOpacity(1),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    SizedBox(height: 20.h,),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 1.w,
                          backgroundColor: Get.theme.primaryColor,
                        ),
                        SizedBox(width: 3.w,),
                        Text(widget.article.category.toString(),style: Get.textTheme.titleMedium,)
                      ],
                    ),

                    SizedBox(height: 2.h,),

                    Obx(() {
                      if(expandContent.value == true){
                        return GestureDetector(
                          onTap: (){
                            expandContent.value = !expandContent.value;
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 85.w,
                                    child: Text(widget.article.articleTitle.toString(),
                                      style: Get.textTheme.headlineMedium!.copyWith(
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.h,),
                              SizedBox(
                                height: 10.h,
                                child: Text(
                                  widget.article.articleContent.toString(),
                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 14,
                                    color: Colors.white.withOpacity(0.5),
                                  ),
                                  maxLines: 3,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    onTap: ()async{
                                      var url = Uri.parse(widget.article.articleUrl.toString());
                                      if (!await launchUrl(url)) {
                                        throw Exception('Could not launch $url');
                                      }
                                    },
                                    child: const Text("Read more",style:  TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14, color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 2.h,),
                              Center(
                                child: RotatedBox(
                                  quarterTurns: 2,
                                  child: Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.white.withOpacity(0.5),),),
                              ),
                            ],
                          ),
                        );
                      }else{
                        return GestureDetector(
                          onTap: (){
                            expandContent.value = !expandContent.value;
                          },
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 85.w,
                                    child: Text(widget.article.articleTitle.toString(),
                                      style: Get.textTheme.headlineMedium!.copyWith(
                                          fontWeight: FontWeight.bold
                                      ),
                                      textAlign: TextAlign.left,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.h,),
                              Center(
                                child: Icon(Icons.arrow_drop_down_circle_outlined,color: Colors.white.withOpacity(0.5),),
                              ),
                            ],
                          ),
                        );
                      }
                    }),

                    SizedBox(height: 4.h,),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text("${widget.article.source}",style: Get.textTheme.titleSmall!.copyWith(
                              color: Colors.white.withOpacity(0.5)
                            ),),
                            Text(" | ",style: Get.textTheme.titleSmall!.copyWith(
                                color: Colors.white.withOpacity(0.5)
                            )),
                            Text('$updateTimeAgo ago',style: Get.textTheme.titleSmall!.copyWith(
                                color: Colors.white.withOpacity(0.5)
                            ))
                          ],
                        ),

                        Row(
                          children: [
                            Obx(() {
                              if(bookmarkBool.value == false){
                                return InkWell(
                                  onTap: ()async{
                                    if(ac.userExistence() == true){
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser?.uid)
                                          .collection('bookmarks')
                                          .doc(widget.article.docId.toString()).set({
                                        'articleDocId': widget.article.docId.toString(),
                                        'articleImage': widget.article.articleImage.toString(),
                                        'articleTitle': widget.article.articleTitle.toString(),
                                        'source': widget.article.source.toString(),
                                        'timestamp': DateTime.now().millisecondsSinceEpoch,
                                      });
                                      bookmarkBool.value = true;
                                    }else{
                                      openSignUpBottomSheet(context);
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 5.w,
                                    backgroundColor: Colors.transparent,
                                    child: const Icon(Icons.thumb_up_alt_outlined),
                                  ),);
                              }else{
                                return InkWell(
                                  onTap: ()async{
                                    if(ac.userExistence() == true){
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth.instance.currentUser?.uid)
                                          .collection('bookmarks')
                                          .doc(widget.article.docId.toString()).delete();
                                      bookmarkBool.value = false;
                                    }else{
                                      openSignUpBottomSheet(context);
                                    }},
                                  child: CircleAvatar(
                                    radius: 5.w,
                                    backgroundColor: Colors.transparent,
                                    child: Icon(Icons.thumb_up_off_alt_sharp,color: Get.theme.primaryColor,),
                                  ),);
                              }
                            }),
                            SizedBox(width: 5.w,),
                            InkWell(
                              onTap: ()async{
                                // var url = Uri.parse(widget.article.articleUrl.toString());
                                // if (!await launchUrl(url)) {
                                //   throw Exception('Could not launch $url');
                                // }
                                await generateAndSharePostLink(widget.article);
                              },
                              child: SvgPicture.asset(share),
                            ),
                          ],
                        )
                      ],
                    ),

                    SizedBox(height: 2.h,),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  static generateAndSharePostLink(Article article) async{
    var dynamicLinkParameters = DynamicLinkParameters(
      link: Uri.parse("www.google.com/${article.docId}",),
      uriPrefix: 'https://headr.page.link',
      androidParameters: AndroidParameters(
          packageName: 'com.usurper.headr',
          fallbackUrl: Uri.parse('www.google.com')
      ),
    );

    var link = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParameters);
    log("Link : ${link.toString()}");

    await  Share.share(link.toString(), subject: article.articleTitle.toString());
  }
}
