import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default Firebase configuration options for different platforms
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Firebase configuration values from google-services.json
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDrY2hYkPr9rGbxq-xqQyqQOZ-DGCUXOYA',
    appId: '1:961632194156:android:9dcc3af0ee45823bbb9249',
    messagingSenderId: '961632194156',
    projectId: 'sports-app-dc923',
    authDomain: 'sports-app-dc923.firebaseapp.com',
    storageBucket: 'sports-app-dc923.firebasestorage.app',
    measurementId: 'G-MEASUREMENT_ID', // Replace with actual measurement ID if available
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrY2hYkPr9rGbxq-xqQyqQOZ-DGCUXOYA',
    appId: '1:961632194156:android:9dcc3af0ee45823bbb9249',
    messagingSenderId: '961632194156',
    projectId: 'sports-app-dc923',
    storageBucket: 'sports-app-dc923.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyALAkSpspoRhayBBOK6Bvci754xOMG-5Ks',
    appId: '1:961632194156:ios:dad4d8a42e77e25cbb9249',
    messagingSenderId: '961632194156',
    projectId: 'sports-app-dc923',
    storageBucket: 'sports-app-dc923.firebasestorage.app',
    iosBundleId: 'com.example.sportsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyALAkSpspoRhayBBOK6Bvci754xOMG-5Ks',
    appId: '1:961632194156:ios:dad4d8a42e77e25cbb9249',
    messagingSenderId: '961632194156',
    projectId: 'sports-app-dc923',
    storageBucket: 'sports-app-dc923.firebasestorage.app',
    iosBundleId: 'com.example.sportsApp',
  );
}
