


import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:headr/models/articles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedController extends GetxController{

  RxList<Article> articles = RxList<Article>();

  @override
  void onInit() async{
    super.onInit();
    articles.value = await fetchArticles();
  }


  Future<List<Article>> fetchArticles() async{

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? feedPrefs = prefs.getStringList('feedPrefs');
    List? feedPrefsList = feedPrefs?.cast<dynamic>();

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

}