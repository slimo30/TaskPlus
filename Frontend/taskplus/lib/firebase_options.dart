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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC4NB3Mx87ffIlEEEm3e5OapfWZrwzw3G4',
    appId: '1:933927494037:web:59e0b85854efd2c9d6969c',
    messagingSenderId: '933927494037',
    projectId: 'taskplus-1ccf9',
    authDomain: 'taskplus-1ccf9.firebaseapp.com',
    storageBucket: 'taskplus-1ccf9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAsfFcWg71j44wyQCwyrzqmdD7qJjvXp4M',
    appId: '1:933927494037:android:cc05479ab064814cd6969c',
    messagingSenderId: '933927494037',
    projectId: 'taskplus-1ccf9',
    storageBucket: 'taskplus-1ccf9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyByg3F91XBqM-V11AOyKg_a-CX_WFA9AsM',
    appId: '1:933927494037:ios:8ae7522db8b9b6b8d6969c',
    messagingSenderId: '933927494037',
    projectId: 'taskplus-1ccf9',
    storageBucket: 'taskplus-1ccf9.appspot.com',
    iosBundleId: 'com.example.taskplus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyByg3F91XBqM-V11AOyKg_a-CX_WFA9AsM',
    appId: '1:933927494037:ios:42d8a8ffbe15f465d6969c',
    messagingSenderId: '933927494037',
    projectId: 'taskplus-1ccf9',
    storageBucket: 'taskplus-1ccf9.appspot.com',
    iosBundleId: 'com.example.taskplus.RunnerTests',
  );
}
