// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
        return windows;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBY4MekHfjETMr3LFeYDip2BqQMLwEYh_c',
    appId: '1:523833171591:web:4549bf16a30e1da4d9e222',
    messagingSenderId: '523833171591',
    projectId: 'mpstorageaplication',
    authDomain: 'mpstorageaplication.firebaseapp.com',
    storageBucket: 'mpstorageaplication.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4zqVkPN1vsJ9GYrIpbFpQD95cXOS5u-k',
    appId: '1:523833171591:android:52beca0b7a257effd9e222',
    messagingSenderId: '523833171591',
    projectId: 'mpstorageaplication',
    storageBucket: 'mpstorageaplication.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCL0h5wGUP7Ps6FFieHOe7UXGvH4ebrXBw',
    appId: '1:523833171591:ios:90d3771c8d4ff2f7d9e222',
    messagingSenderId: '523833171591',
    projectId: 'mpstorageaplication',
    storageBucket: 'mpstorageaplication.appspot.com',
    iosBundleId: 'com.example.mpstorage',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCL0h5wGUP7Ps6FFieHOe7UXGvH4ebrXBw',
    appId: '1:523833171591:ios:90d3771c8d4ff2f7d9e222',
    messagingSenderId: '523833171591',
    projectId: 'mpstorageaplication',
    storageBucket: 'mpstorageaplication.appspot.com',
    iosBundleId: 'com.example.mpstorage',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBY4MekHfjETMr3LFeYDip2BqQMLwEYh_c',
    appId: '1:523833171591:web:36988d9cd211cb16d9e222',
    messagingSenderId: '523833171591',
    projectId: 'mpstorageaplication',
    authDomain: 'mpstorageaplication.firebaseapp.com',
    storageBucket: 'mpstorageaplication.appspot.com',
  );
}
