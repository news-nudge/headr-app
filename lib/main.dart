import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:headr/controllers/feed_controller.dart';
import 'package:headr/splash_screen.dart';
import 'package:headr/utils/constants.dart';
import 'package:headr/utils/theme.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'controllers/auth_controller.dart';
import 'firebase_options.dart';

void main() async {


  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,).then((value) {
    log('entered 1');
    Get.put(FeedController());

    log('entered 2');
    Future.delayed(const Duration(seconds: 2), () => Get.put(AuthController()));
  });



  /// Push notifications
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
  OneSignal.initialize(oneSignalAppId);
  OneSignal.Notifications.requestPermission(true);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return ResponsiveSizer(builder: (context,orientation,deviceType){
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.rightToLeftWithFade,
        themeMode: ThemeMode.dark,
        title: 'Headr',
        theme: T1.darkTheme(),
        home: const SplashScreen(),
      );
    });
  }
}
