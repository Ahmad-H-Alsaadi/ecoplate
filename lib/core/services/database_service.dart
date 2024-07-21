import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String userId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DatabaseService({required this.userId});

  Future<void> updateUserData(String userName, String email) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'userName': userName,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
      print('User data updated successfully for userId: $userId');
    } catch (e) {
      print('Error updating user data for userId: $userId. Error: $e');
      rethrow;
    }
  }
}
