import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/firebase_auth_services.dart';

class AuthController extends ChangeNotifier {
  final firebaseAuthServices = FirebaseAuthServices();

  Future<bool> signIn(String newEmail, String newPassword) async {
    return firebaseAuthServices.signIn(newEmail, newPassword);
  }

  Future<void> signUp(String name, String email, String password,
      String? curLocateName, double? lat, double? lng, File? imageFile) async {
    return firebaseAuthServices.signUp(
        name, email, password, curLocateName, lat, lng, imageFile);
  }

  Future<void> resetPassword(String email) async {
    return firebaseAuthServices.resetPassword(email);
  }

  Stream<DocumentSnapshot> getCurrentUsers() {
    return firebaseAuthServices.getCurrentUsers();
  }
}
