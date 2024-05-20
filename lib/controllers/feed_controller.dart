


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

  int oldDocumentArticlesListLength = -1;
  int articlePaginationCount = 20;
  late DocumentSnapshot lastArticleDocument;

  RxString searchedText = ''.obs;
  RxList<Bookmark> searchList = RxList<Bookmark>();

  @override
  void onInit() async{
    super.onInit();
    articles.value = await fetchArticles();
  }


  Future<List<Article>> fetchArticles() async{

    var res = await FirebaseFirestore.instance
        .collection('articles')
        .where('approved',isEqualTo: true)
        .orderBy('uploadedAt',descending: true)
        .limit(articlePaginationCount)
        .get()
        .then((value) {
          lastArticleDocument = value.docs.last;
          var result = value.docs.map((e) => Article.fromDocument(e)).toList();
          return result;
        });

    log('Articles length: ${res.length}');
    return res;
  }

  Future<List<Article>> fetchMoreArticles() async{

    oldDocumentArticlesListLength = articles.length;
    var res = await FirebaseFirestore.instance
        .collection('articles')
        .orderBy('uploadedAt',descending: true)
        .startAfterDocument(lastArticleDocument)
        .limit(articlePaginationCount)
        .get()
        .then((value) {
      lastArticleDocument = value.docs.last;
      var result = value.docs.map((e) {
        var v=  Article.fromDocument(e);
        log('article title : ${v.articleTitle}');
        return v;
      }).toList();
      return result;
    });

    return res;
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

  Future<List<Bookmark>> searchBookmarks(String input) async{
    var res = await FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('bookmarks')
      .where('articleTitle',isGreaterThanOrEqualTo: input)
      .get()
      .then((value) {
        var result = value.docs.map((e) => Bookmark.fromDocument(e)).toList();
        return result;
      });

    return res;
  }

}