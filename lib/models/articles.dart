import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  String? docId;
  String? articleTitle;
  String? articleImage;
  String? articleContent;
  String? articleAuthor;
  String? articleUrl;
  String? publishedAt;
  String? uploadedAt;
  String? source;
  String? country;
  String? category;

  Article(
      {this.docId,
      this.articleTitle,
      this.articleImage,
      this.articleContent,
      this.articleAuthor,
      this.articleUrl,
      this.publishedAt,
      this.uploadedAt,
      this.source,
      this.country,
      this.category});


  factory Article.fromDocument(DocumentSnapshot<Map<String,dynamic>> snapshot){
    var d = snapshot.data()!;

    return Article(
      docId : d['docId'],
      articleTitle : d['articleTitle'],
      articleImage : d['articleImage'],
      articleContent : d['articleContent'],
      articleAuthor : d['articleAuthor'],
      articleUrl : d['articleUrl'],
      publishedAt : d['publishedAt'],
      uploadedAt : d['uploadedAt'],
      source : d['source'],
      country : d['country'],
      category : d['category'],
    );
  }

}
