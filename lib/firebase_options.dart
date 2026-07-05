// File generated based on google-services.json and GoogleService-Info.plist
// Project: old-fisherman-80dad

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAYDN2sWw-kZkkJlZDiHPsA0KufcPkhTwk',
    appId: '1:165320770152:android:c99c4272a8c350bc3fb1dd',
    messagingSenderId: '165320770152',
    projectId: 'old-fisherman-80dad',
    storageBucket: 'old-fisherman-80dad.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAu-Fq4AAruaXm0YOUHKW-w2B7Gd_q4Ak8',
    appId: '1:165320770152:ios:7e0385889e9c03cc3fb1dd',
    messagingSenderId: '165320770152',
    projectId: 'old-fisherman-80dad',
    storageBucket: 'old-fisherman-80dad.firebasestorage.app',
    iosBundleId: 'old.fisherman.video.maker',
  );

}