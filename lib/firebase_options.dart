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
    apiKey: 'AIzaSyC9_WpMwhluqvVoALbtONDiWgEcoc7xROA',
    appId: '1:515577614227:web:1e91f521e7d9cb8a47e266',
    messagingSenderId: '515577614227',
    projectId: 'fridge-bfde1',
    databaseURL: 'fridge-bfde1.firebaseio.com',
    authDomain: 'fridge-bfde1.firebaseapp.com',
    storageBucket: 'fridge-bfde1.appspot.com',
    measurementId: 'G-8VRCP1TT6C',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyALS3uzIzdiNvtrLsAaZrfAEp5FDuPWx84',
    appId: '1:515577614227:android:1667c000dade394047e266',
    messagingSenderId: '515577614227',
    projectId: 'fridge-bfde1',
    databaseURL: 'fridge-bfde1.firebaseio.com',
    storageBucket: 'fridge-bfde1.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCCWsTESGOTBPLv3NFefKnPQo-fNdhkjWs',
    appId: '1:515577614227:ios:8fd58a691738b08e47e266',
    messagingSenderId: '515577614227',
    projectId: 'fridge-bfde1',
    databaseURL: 'fridge-bfde1.firebaseio.com',
    storageBucket: 'fridge-bfde1.appspot.com',
    iosClientId: '515577614227-7pcrlv0bmqmuemr4ugduo6p2a0r20rj7.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterApp',
  );
}
