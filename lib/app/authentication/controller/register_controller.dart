import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      print("Attempting to create user with email: $email");

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        print("User created successfully with UID: ${user.uid}");

        await _saveUserDataToFirestore(user: user, name: name);
      } else {
        throw Exception("User creation successful but user data is missing");
      }
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException in registerUser: ${e.code} - ${e.message}");
      throw _handleFirebaseAuthException(e);
    } catch (e, stackTrace) {
      print("Error in registerUser: $e");
      print("Stack trace: $stackTrace");

      if (e.toString().contains("type 'List<Object?>' is not a subtype of type 'PigeonUserDetails?'")) {
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          print("User likely created successfully. UID: ${currentUser.uid}");
          await _saveUserDataToFirestore(user: currentUser, name: name);
          return;
        }
      }

      throw Exception("Registration failed: ${e.toString()}");
    }
  }

  Future<void> _saveUserDataToFirestore({
    required User user,
    required String name,
  }) async {
    try {
      print("Attempting to save user data to Firestore for UID: ${user.uid}");

      await _firestore.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'name': name,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print("User data saved successfully to Firestore for UID: ${user.uid}");
    } catch (e) {
      print("Error saving user data to Firestore: $e");
      throw Exception("Failed to save user data: ${e.toString()}");
    }
  }

  Exception _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return Exception('The password provided is too weak.');
      case 'email-already-in-use':
        return Exception('An account already exists for that email.');
      case 'invalid-email':
        return Exception('The email address is not valid.');
      default:
        return Exception('An error occurred during registration: ${e.message}');
    }
  }
}
