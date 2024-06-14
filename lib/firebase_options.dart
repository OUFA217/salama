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
    apiKey: 'AIzaSyDuD70OI87--TMBovsizuOiJWmumNQUGyg',
    appId: '1:142476817064:web:1de66ce951df8f311ec89d',
    messagingSenderId: '142476817064',
    projectId: 'salama-2d6ee',
    authDomain: 'salama-2d6ee.firebaseapp.com',
    storageBucket: 'salama-2d6ee.appspot.com',
    measurementId: 'G-828HVBD5XB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA_meJXQrdWfB3sh_DecZ_ZZjgPErTg_EY',
    appId: '1:142476817064:android:f1028a247fce4da81ec89d',
    messagingSenderId: '142476817064',
    projectId: 'salama-2d6ee',
    storageBucket: 'salama-2d6ee.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDDSYPjCALLQshMSIKzGQgTQoUG3PpoSEk',
    appId: '1:142476817064:ios:9ef9dc0b92a2b7b91ec89d',
    messagingSenderId: '142476817064',
    projectId: 'salama-2d6ee',
    storageBucket: 'salama-2d6ee.appspot.com',
    iosBundleId: 'com.example.salama',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDDSYPjCALLQshMSIKzGQgTQoUG3PpoSEk',
    appId: '1:142476817064:ios:9ef9dc0b92a2b7b91ec89d',
    messagingSenderId: '142476817064',
    projectId: 'salama-2d6ee',
    storageBucket: 'salama-2d6ee.appspot.com',
    iosBundleId: 'com.example.salama',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDuD70OI87--TMBovsizuOiJWmumNQUGyg',
    appId: '1:142476817064:web:bf1eee3265eff1cc1ec89d',
    messagingSenderId: '142476817064',
    projectId: 'salama-2d6ee',
    authDomain: 'salama-2d6ee.firebaseapp.com',
    storageBucket: 'salama-2d6ee.appspot.com',
    measurementId: 'G-6T6M7CXDEN',
  );

}