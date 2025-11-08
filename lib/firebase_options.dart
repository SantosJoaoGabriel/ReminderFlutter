import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return FirebaseOptions(
        apiKey: "AIzaSyAZdF43HY0vrvJFcdVjlF7sXx4aL47XuqU",
        authDomain: "financing-app-de352.firebaseapp.com",
        projectId: "financing-app-de352",
        storageBucket: "financing-app-de352.firebasestorage.app",
        messagingSenderId: "577617143128",
        appId: "1:577617143128:web:fa157b14a1d6124a11b12d",
        measurementId: "G-176B3LXD61",
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return FirebaseOptions(
          apiKey: 'SUA API KEY',
          appId: 'SEU APP ID',
          messagingSenderId: 'SEU MESSAGE ID',
          projectId: 'SEU PROJECT ID',
        );
      case TargetPlatform.iOS:
        return FirebaseOptions(
          apiKey: 'SUA API KEY',
          appId: 'SEU APP ID',
          messagingSenderId: 'SEU MESSAGE ID',
          projectId: 'SEU PROJECT ID',
        );
      default: 
        return FirebaseOptions (
          apiKey: 'SUA API KEY',
          appId: 'SEU APP ID',
          messagingSenderId: 'SEU MESSAGE ID',
          projectId: 'SEU PROJECT ID',
      );
    }
  }
}
