

import 'package:cloud_firestore/cloud_firestore.dart';

class Bookmark {
  String? articleDocId;
  String? articleImage;
  String? articleTitle;
  String? source;
  int? timestamp;

  Bookmark({this.articleDocId,this.articleImage,this.articleTitle,this.source,this.timestamp});

  factory Bookmark.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    var d = snapshot.data()!;
    return Bookmark(
      articleDocId : d['articleDocId'],
      articleImage : d['articleImage'],
      articleTitle : d['articleTitle'],
      source : d['source'],
      timestamp : d['timestamp'],
    );
  }
}