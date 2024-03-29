


import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:headr/models/articles.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/bookmark.dart';

class FeedController extends GetxController{

  RxList<Article> articles = RxList<Article>();
  RxList<Bookmark> bookmarks = RxList<Bookmark>();

  @override
  void onInit() async{
    super.onInit();
    articles.value = await fetchArticles();
  }


  Future<List<Article>> fetchArticles() async{

    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String>? feedPrefs = prefs.getStringList('feedPrefs');
    // List? feedPrefsList = feedPrefs?.cast<dynamic>();

    var res = await FirebaseFirestore.instance
        .collection('articles')
        .limit(20)
        .get()
        .then((value) {
      var result = value.docs.map((e) => Article.fromDocument(e)).toList();
      return result;
    });

    log('feed controller length 2: ${res.length}');
    return res;

    // if(feedPrefsList!=null && feedPrefsList.isNotEmpty){
    //   var res = await FirebaseFirestore.instance
    //       .collection('articles')
    //       .where('category',whereIn: feedPrefsList)
    //       .limit(20)
    //       .get()
    //       .then((value) {
    //     var result = value.docs.map((e) => Article.fromDocument(e)).toList();
    //     return result;
    //   });
    //
    //   log('feed controller length : ${res.length}');
    //   return res;
    // }else{
    //   var res = await FirebaseFirestore.instance
    //       .collection('articles')
    //       .limit(20)
    //       .get()
    //       .then((value) {
    //     var result = value.docs.map((e) => Article.fromDocument(e)).toList();
    //     return result;
    //   });
    //
    //   log('feed controller length 2: ${res.length}');
    //   return res;
    // }
  }

  Future<Article> fetchParticularArticle(String articleDocId) async{
    var res = await FirebaseFirestore.instance
        .collection('articles')
        .where('docId',isEqualTo: articleDocId)
        .get()
        .then((value) {
      var result = value.docs.map((e) => Article.fromDocument(e)).toList()[0];
      return result;
    });

    return res;
  }

  Future<List<Bookmark>> fetchBookmarks() async{
    var res = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bookmarks')
        .limit(25)
        .get()
        .then((value) {
          var result = value.docs.map((e) => Bookmark.fromDocument(e)).toList();
          return result;
        });
    return res;
  }


  Future<bool> checkBookmarkStatus(String articleDocId) async{
    var res = await FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('bookmarks')
        .doc(articleDocId)
        .get()
        .then((value) {
          var result = value;
          return result;
        });

    if(res.exists){
      return true;
    }else{
      return false;
    }
  }

}