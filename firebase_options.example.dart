// ARCHIVO DE EJEMPLO - NO USAR EN PRODUCCIÓN
// 
// Este archivo muestra la estructura que debe tener tu firebase_options.dart
// Para generar el archivo real, ejecuta:
//   flutterfire configure
//
// El archivo generado se guardará en: lib/firebase_options.dart

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'TU_API_KEY_AQUI',
    appId: 'TU_APP_ID_AQUI',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'tu-project-id',
    storageBucket: 'tu-project-id.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'TU_API_KEY_IOS_AQUI',
    appId: 'TU_APP_ID_IOS_AQUI',
    messagingSenderId: 'TU_MESSAGING_SENDER_ID',
    projectId: 'tu-project-id',
    storageBucket: 'tu-project-id.appspot.com',
    iosBundleId: 'com.hir0exe.flutterBigShotDev',
  );
}

