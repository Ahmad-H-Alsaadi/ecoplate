import 'package:flutter/material.dart';
import 'package:ecoplate/app/account/model/account_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AccountModel? _account;
  bool _isLoading = false;

  AccountModel? get account => _account;
  bool get isLoading => _isLoading;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  AccountController() {
    loadUserData();
  }

  Future<void> loadUserData() async {
    _isLoading = true;
    notifyListeners();

    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        _account = AccountModel.fromJson(doc.data() as Map<String, dynamic>);
        nameController.text = _account!.name;
        emailController.text = _account!.email;
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> saveChanges() async {
    try {
      _account = AccountModel(
        name: nameController.text,
        email: emailController.text,
        password: '', // We don't update the password here
      );
      User? user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set(_account!.toJson());
        await user.updateDisplayName(_account!.name);
        await user.updateEmail(_account!.email);
      }
      return 'Changes saved successfully';
    } catch (e) {
      return 'Error saving changes: $e';
    }
  }

  Future<String> updatePassword() async {
    try {
      if (passwordController.text.isNotEmpty) {
        User? user = _auth.currentUser;
        if (user != null) {
          await user.updatePassword(passwordController.text);
          passwordController.clear();
          return 'Password updated successfully';
        }
      }
      return 'Please enter a new password';
    } catch (e) {
      return 'Error updating password: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
