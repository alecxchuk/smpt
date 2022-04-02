// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCLTQu3F80I62FO6iPlsbfcDyKQ4qJGvdc',
    appId: '1:145946713911:android:0a1740a7b3dd40b98584b2',
    messagingSenderId: '145946713911',
    projectId: 'email-sender-acon',
    storageBucket: 'email-sender-acon.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDo-8mxrwnAikgWUj2IT00HGWOKTEZKHVw',
    appId: '1:145946713911:ios:0ee4ac683d0e9dad8584b2',
    messagingSenderId: '145946713911',
    projectId: 'email-sender-acon',
    storageBucket: 'email-sender-acon.appspot.com',
    iosClientId: '145946713911-kdpre0deo1kjv9li6rj2cfo3mhbhtqhf.apps.googleusercontent.com',
    iosBundleId: 'com.smpt',
  );
}
