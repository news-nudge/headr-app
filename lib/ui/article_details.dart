


import 'dart:developer' as dev;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/auth_controller.dart';
import 'package:headr/controllers/feed_controller.dart';
import 'package:headr/models/articles.dart';
import 'package:headr/utils/constants.dart';
import 'package:headr/widgets/like_animation_widget.dart';
import 'package:headr/widgets/video_player.dart';
import 'package:headr/widgets/widgets.dart';
import 'package:intl/intl.dart';
// import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_link/share_link.dart';

class ArticleDetails extends StatefulWidget {
  final Article article;
  final bool callPagination;
  const ArticleDetails({super.key, required this.article, required this.callPagination});

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
    expandContent.value = false;
    checkBookmarkStatus();
  }

  @override
  Widget build(BuildContext context) {
    final shareButtonKey = GlobalKey();

    return Material(
      color: Get.theme.scaffoldBackgroundColor,
      child: GestureDetector(
        onDoubleTap: ()async{
          if(bookmarkBool.value == false){
            if(ac.userExistence() == true){
              fc.isLikeAnimating.value = true;
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
          }else{
            if(ac.userExistence() == true){
              fc.isLikeAnimating.value = true;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('bookmarks')
                  .doc(widget.article.docId.toString()).delete();
              bookmarkBool.value = false;
            }else{
              openSignUpBottomSheet(context);
            }
          }
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [


            buildAsset(),


            GestureDetector(
              onTap : (){
                fc.containerExpandBool.value = !fc.containerExpandBool.value;
              },
              child: BlackGradientContainer(
                // expandBool: fc.containerExpandBool.value,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // SizedBox(height: 20.h,),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 1.w,
                            backgroundColor: Colors.white.withOpacity(0.8),
                          ),
                          SizedBox(width: 3.w,),
                          Text(widget.article.category.toString(),style: Get.textTheme.titleMedium,)
                        ],
                      ),

                      SizedBox(height: 2.h,),



                      Row(
                        children: [
                          SizedBox(
                            width: 85.w,
                            child: Text(widget.article.articleTitle.toString(),
                              style: Get.textTheme.headlineSmall!.copyWith(
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

                      /// Read More
                      // ReadMoreText(
                      //   widget.article.articleContent.toString(),
                      //   trimMode: TrimMode.Line,
                      //   trimLines: 2,
                      //   colorClickableText: Colors.white,
                      //   trimCollapsedText: 'Read more',
                      //   trimExpandedText: ' Read less',
                      //   callback: (bool expand){
                      //     fc.containerExpandBool.value = !fc.containerExpandBool.value;
                      //   },
                      //   moreStyle: TextStyle(
                      //       fontSize: 14,
                      //       color: Colors.white.withOpacity(.5)
                      //   ),
                      // ),

                      /// Max Lines
                      Obx(() => Text(widget.article.articleContent.toString(),style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(.5)

                      ),
                        maxLines: fc.containerExpandBool.value == false? 3:30,
                        overflow: TextOverflow.ellipsis,
                      ),),
                      // Text(widget.article.articleContent.toString(),style: TextStyle(
                      //     fontSize: 14,
                      //     color: Colors.white.withOpacity(.5)
                      // ),
                      //   overflow: TextOverflow.ellipsis,
                      // ),
                      SizedBox(height: 4.h,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(DateFormat.yMMMd('en_us')
                              .format(DateTime.parse(widget.article.publishedAt!)),
                              style: Get.textTheme.titleSmall!.copyWith(
                                  color: Colors.white.withOpacity(0.5)
                              )),


                          Row(
                            children: [

                              GestureDetector(
                                child: const Icon(Icons.more_vert,),
                                onTap: (){
                                  openReportBottomSheet(context, widget.article);
                                },
                              ),
                              SizedBox(width: 5.w,),
                              Obx(() {
                                if(bookmarkBool.value == false){
                                  return GestureDetector(
                                    onTap: ()async{
                                      if(ac.userExistence() == true){
                                        fc.isLikeAnimating.value = true;
                                        bookmarkBool.value = true;
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
                                      }else{
                                        openSignUpBottomSheet(context);
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 5.w,
                                      backgroundColor: Colors.transparent,
                                      child: const Icon(Icons.favorite_border_rounded,color: Colors.white,),
                                    ),);
                                }else{
                                  return GestureDetector(
                                    onTap: ()async{
                                      if(ac.userExistence() == true){
                                        fc.isLikeAnimating.value = true;
                                        bookmarkBool.value = false;
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(FirebaseAuth.instance.currentUser?.uid)
                                            .collection('bookmarks')
                                            .doc(widget.article.docId.toString()).delete();
                                      }else{
                                        openSignUpBottomSheet(context);
                                      }},
                                    child: CircleAvatar(
                                      radius: 5.w,
                                      backgroundColor: Colors.transparent,
                                      child: const Icon(Icons.favorite_rounded,color: Colors.redAccent,),
                                    ),);
                                }
                              }),
                              SizedBox(width: 7.w,),
                              GestureDetector(
                                key: shareButtonKey,
                                onTap: ()async{

                                  await generateAndSharePostLink(widget.article);
                                },
                                child: Transform.rotate(
                                    angle: -pi/6,
                                    child: const Icon(Icons.send)),
                              ),
                            ],
                          )
                        ],
                      ),

                      SizedBox(height: 2.h,),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() => Opacity(
                      opacity: fc.isLikeAnimating.value ? 1 : 0,
                      child: LikeAnimationWidget(
                        isAnimating: fc.isLikeAnimating.value,
                        duration: const Duration(milliseconds: 400),
                        onEnd: () {
                          fc.isLikeAnimating.value = false;
                        },
                        child: fc.isLikeAnimating.value == true
                            ? Icon(Icons.favorite_rounded,color: Colors.white,size: 24.w,)
                            : Icon(Icons.favorite_border_rounded,color: Colors.white,size: 24.w,),
                      ),
                    ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buildAsset() {
    if(widget.article.video==''){
      return CachedNetworkImage(
        imageUrl: widget.article.articleImage.toString(),
        width: 100.w,
        height: 100.h,
        fit: BoxFit.cover,
      );
    }else{
      dev.log('video string : ${widget.article.video}');
      return Positioned(
        top: 0,
        child: VideoPlayerWidget(videoUrl: widget.article.video.toString(),));
    }
  }

  static generateAndSharePostLink(Article article) async{
    var dynamicLinkParameters = DynamicLinkParameters(
      link: Uri.parse("https://www.google.com/${article.docId}",),
      uriPrefix: 'https://headr.page.link',
      androidParameters: AndroidParameters(
          packageName: 'com.usurper.headr',
          fallbackUrl: Uri.parse('https://www.google.com/')
      ),
    );

    var link = await FirebaseDynamicLinks.instance.buildLink(dynamicLinkParameters);
    dev.log("Link : ${link.toString()}");

    await ShareLink.shareUri(
      link,
      subject: article.articleTitle.toString(),
      shareOrigin: Rect.largest,
    );

  }
}
