import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyCjvwXqIpWJ0ALHh-z9c8wKUkaUUOzlGws',
      appId: '1:634989098033:android:d873bbbde9bf46c2e25110',
      messagingSenderId: '634989098033',
      projectId: 'ecoplate-e7860',
      storageBucket: 'ecoplate-e7860.appspot.com',
      authDomain: 'YOUR_ANDROID_AUTH_DOMAIN',
      measurementId: 'YOUR_ANDROID_MEASUREMENT_ID',
      databaseURL: 'YOUR_ANDROID_DATABASE_URL',
    );
  }
}
