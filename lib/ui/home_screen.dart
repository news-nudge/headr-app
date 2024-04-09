

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/profile_controller.dart';
import 'package:headr/models/articles.dart';
import 'package:headr/ui/article_details.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../controllers/feed_controller.dart';
import '../utils/constants.dart';

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
    determinePosition();
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

  bool isLoadingAddress = false;
  String location = '';

  void determinePosition() async {
    log("entered determine location");
    setState(() {
      isLoadingAddress = true;
    });
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings().then((value) {
        Geolocator.getCurrentPosition().then((position) {
          getAddressFromLatLang(position);
        });
      });

      Fluttertoast.showToast(
          msg: "Location services are disabled.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoadingAddress = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.openLocationSettings().then((value) {
          Geolocator.getCurrentPosition().then((position) {
            getAddressFromLatLang(position);
          });
        });
        Fluttertoast.showToast(
            msg: "Location permissions are denied",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          isLoadingAddress = false;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      await Geolocator.openLocationSettings().then((value) {
        Geolocator.getCurrentPosition().then((position) {
          getAddressFromLatLang(position);
        });
      });
      Fluttertoast.showToast(
          msg:
          "Location permissions are permanently denied, we cannot request permissions.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      setState(() {
        isLoadingAddress = false;
      });
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Geolocator.getCurrentPosition().then((position) {
      getAddressFromLatLang(position);
    });
  }

  Future<void> getAddressFromLatLang(Position position) async {
    List<Placemark> placemark = await placemarkFromCoordinates(position.latitude, position.longitude,);
    Placemark place = placemark[0];

    location = '${place.locality}, ${place.country}, ${place.postalCode}';
    isLoadingAddress = false;
    log('location : $location');
    uploadToAccount();

  }

  void uploadToAccount() async{
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
        scrollDirection: Axis.horizontal,
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



