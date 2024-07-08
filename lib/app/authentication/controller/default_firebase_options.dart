import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyBg_7OAdaRtZ_EIzskzCSwJbJnlcp8dLTo',
      appId: '1:19864181156:android:3fdf8347061da6a37bc931',
      messagingSenderId: '19864181156',
      projectId: 'ecoplate',
      storageBucket: 'ecopalte.appspot.com',
      authDomain: 'YOUR_ANDROID_AUTH_DOMAIN', // Replace with actual authDomain if available
      measurementId: 'YOUR_ANDROID_MEASUREMENT_ID', // Replace with actual measurementId if available
      databaseURL: 'YOUR_ANDROID_DATABASE_URL', // Replace with actual databaseURL if available
    );
  }
}
