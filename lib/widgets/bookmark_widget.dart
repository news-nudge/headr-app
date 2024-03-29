


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/feed_controller.dart';
import 'package:headr/models/articles.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../utils/constants.dart';

class BookmarkWidget extends StatefulWidget {
  final String articleDocId;
  const BookmarkWidget({super.key, required this.articleDocId});

  @override
  State<BookmarkWidget> createState() => _BookmarkWidgetState();
}

class _BookmarkWidgetState extends State<BookmarkWidget> {

  final FeedController fc = Get.find();

  RxBool bookmarkBool = false.obs;

  void checkBookmarkStatus() async{
    bookmarkBool.value = await fc.checkBookmarkStatus(widget.articleDocId);
  }


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if(bookmarkBool.value == true){
        return InkWell(
          onTap: ()async{

            Article article = await fc.fetchParticularArticle(widget.articleDocId);

            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('bookmarks')
                .doc(article.docId.toString()).set({
              'articleDocId': article.docId.toString(),
              'articleImage': article.articleImage.toString(),
              'articleTitle': article.articleTitle.toString(),
              'source': article.source.toString(),
              'timestamp': DateTime.now().millisecondsSinceEpoch,
            });
            bookmarkBool.value = true;
          },
          child: CircleAvatar(
            radius: 5.w,
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset(bookmark),
          ),);
      }else{
        return InkWell(
          onTap: ()async{
            await FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('bookmarks')
                .doc(widget.articleDocId).delete();

            fc.bookmarks.value = await fc.fetchBookmarks();
            bookmarkBool.value = false;
            },
          child: CircleAvatar(
            radius: 5.w,
            backgroundColor: Colors.transparent,
            child: SvgPicture.asset(bookmarkFilled),
          ),);
      }
    });
  }
}
