

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // static const FirebaseOptions web = FirebaseOptions(
  //   apiKey: 'AIzaSyC_N8yMwOSFiNXj35EdTJP9FqpE6p3OSBk',
  //   appId: '1:290972050498:web:d39da7f4e064ce79b939db',
  //   messagingSenderId: '290972050498',
  //   projectId: 'playhub-a3729',
  //   authDomain: 'playhub-a3729.firebaseapp.com',
  //   storageBucket: 'playhub-a3729.appspot.com',
  //   measurementId: 'G-V6JNW9N8D7',
  // );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDYKSxCjpNLcddkDnvXjSNRQfD-L_EvcSE',
    appId: '1:708417576707:android:8973c3949d323d659a5336',
    messagingSenderId: '708417576707',
    projectId: 'headr-81a9f',
    storageBucket: 'headr-81a9f.appspot.com',
    authDomain: 'headr-81a9f.firebaseapp.com',
  );

  // static const FirebaseOptions ios = FirebaseOptions(
  //   apiKey: 'AIzaSyAg38zFJPZJCqFS8ZMTpzu_wnvOa_Yut8k',
  //   appId: '1:290972050498:ios:c2286ebc66bf8800b939db',
  //   messagingSenderId: '290972050498',
  //   projectId: 'playhub-a3729',
  //   storageBucket: 'playhub-a3729.appspot.com',
  //   iosBundleId: 'com.usurper.playhub',
  // );
}