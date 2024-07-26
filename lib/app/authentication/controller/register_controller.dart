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

      // Create user in Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Get the newly created user
      User? user = userCredential.user;

      if (user != null) {
        print("User created successfully with UID: ${user.uid}");

        // Save additional user data to Firestore
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

      // Check if the error is the specific PigeonUserDetails error
      if (e.toString().contains("type 'List<Object?>' is not a subtype of type 'PigeonUserDetails?'")) {
        // The user was likely created successfully, but we got an error when trying to read the response
        // We'll try to fetch the current user manually
        User? currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          print("User likely created successfully. UID: ${currentUser.uid}");
          await _saveUserDataToFirestore(user: currentUser, name: name);
          return; // Registration successful
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
