import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
        return linux;
      default:
        throw UnsupportedError('Plataforma no soportada.');
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCic8uFOKB7hYoMzn8cpk9ZcmOf9Dw9LtE',
    appId: '1:138977466044:web:f17f1ffcd2f1e7cdbfa2b9',
    messagingSenderId: '138977466044',
    projectId: 'juntapp-dsagra',
    authDomain: 'juntapp-dsagra.firebaseapp.com',
    storageBucket: 'juntapp-dsagra.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWwrqpTqpaugH5ZaD8zXLAPrWA3qxC-JY',
    appId: '1:138977466044:android:49eb6176defe8d77bfa2b9',
    messagingSenderId: '138977466044',
    projectId: 'juntapp-dsagra',
    storageBucket: 'juntapp-dsagra.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBwrCX93Hhofkt9WCTFi1dj1rk6zSJXn_Y',
    appId: '1:138977466044:ios:70f6db877d7c2836bfa2b9',
    messagingSenderId: '138977466044',
    projectId: 'juntapp-dsagra',
    storageBucket: 'juntapp-dsagra.firebasestorage.app',
    iosBundleId: 'com.example.juntapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBwrCX93Hhofkt9WCTFi1dj1rk6zSJXn_Y',
    appId: '1:138977466044:ios:70f6db877d7c2836bfa2b9',
    messagingSenderId: '138977466044',
    projectId: 'juntapp-dsagra',
    storageBucket: 'juntapp-dsagra.firebasestorage.app',
    iosBundleId: 'com.example.juntapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCic8uFOKB7hYoMzn8cpk9ZcmOf9Dw9LtE',
    appId: '1:138977466044:web:2a883bff7e74a8f7bfa2b9',
    messagingSenderId: '138977466044',
    projectId: 'juntapp-dsagra',
    authDomain: 'juntapp-dsagra.firebaseapp.com',
    storageBucket: 'juntapp-dsagra.firebasestorage.app',
  );

  static const FirebaseOptions linux = FirebaseOptions(
    apiKey: 'YOUR_LINUX_API_KEY',
    appId: 'YOUR_LINUX_APP_ID',
    messagingSenderId: 'YOUR_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
  );
}