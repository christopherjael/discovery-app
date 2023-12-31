// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDkqObixGpr_IYDXsK2MRLQ0LNZKIFCVNU',
    appId: '1:16784552282:web:434b893cdbcaa0473b8363',
    messagingSenderId: '16784552282',
    projectId: 'dicoveryapp',
    authDomain: 'dicoveryapp.firebaseapp.com',
    storageBucket: 'dicoveryapp.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCOTgNWudLvNzf5TbwVTPx8mghCA_X3Ulc',
    appId: '1:16784552282:android:8e056cf6cba954743b8363',
    messagingSenderId: '16784552282',
    projectId: 'dicoveryapp',
    storageBucket: 'dicoveryapp.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBJ295JdcgYannmYhlki-wAPnmj_zNoALw',
    appId: '1:16784552282:ios:ebdddcbde80118023b8363',
    messagingSenderId: '16784552282',
    projectId: 'dicoveryapp',
    storageBucket: 'dicoveryapp.appspot.com',
    iosClientId: '16784552282-uss2loqh5dbuaul4md8b1jikfcck8hus.apps.googleusercontent.com',
    iosBundleId: 'com.example.discoveryapp.discoveryapp',
  );
}
