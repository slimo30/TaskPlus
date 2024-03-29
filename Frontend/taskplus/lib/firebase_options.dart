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
    apiKey: 'AIzaSyAUbS8p9Zo6PNViSMauwnw7gSsWYw1be4o',
    appId: '1:615559650193:web:a793218124db1ac9c41830',
    messagingSenderId: '615559650193',
    projectId: 'taskplus-64fb9',
    authDomain: 'taskplus-64fb9.firebaseapp.com',
    storageBucket: 'taskplus-64fb9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDkFtkd0W5Ufch9ygq-CrAZZVj0HaXV9EE',
    appId: '1:615559650193:android:ed71e50a924759bbc41830',
    messagingSenderId: '615559650193',
    projectId: 'taskplus-64fb9',
    storageBucket: 'taskplus-64fb9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAxth5KedOvxMiMK0s-T64gJfPi5ozG4So',
    appId: '1:615559650193:ios:273f77bd67a0af91c41830',
    messagingSenderId: '615559650193',
    projectId: 'taskplus-64fb9',
    storageBucket: 'taskplus-64fb9.appspot.com',
    iosBundleId: 'com.example.taskplus',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAxth5KedOvxMiMK0s-T64gJfPi5ozG4So',
    appId: '1:615559650193:ios:4c23c587b4c9d15ec41830',
    messagingSenderId: '615559650193',
    projectId: 'taskplus-64fb9',
    storageBucket: 'taskplus-64fb9.appspot.com',
    iosBundleId: 'com.example.taskplus.RunnerTests',
  );
}
