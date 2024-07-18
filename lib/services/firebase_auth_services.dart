import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseAuthServices {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<bool> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> signUp(
    String name,
    String email,
    String password,
    String? curLocationName,
    double? lat,
    double? lng,
    File? imageFile,
  ) async {
    final _usersCollection = firebaseFirestore.collection('users');

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final userDoc =
          _usersCollection.doc(FirebaseAuth.instance.currentUser!.uid);

      if (imageFile != null) {
        final imageReference = firebaseStorage.ref().child(
            "users/${FirebaseAuth.instance.currentUser!.uid}/profile.jpg");
        await imageReference.putFile(imageFile);
        final imageUrl = await imageReference.getDownloadURL();

        await userDoc.set({
          "name": name,
          "email": email,
          "curLocateName": curLocationName,
          "lat": lat,
          "lng": lng,
          "imageUrl": imageUrl,
        });
      } else {
        await userDoc.set({
          "name": name,
          "email": email,
          "curLocateName": curLocationName,
          "lat": lat,
          "lng": lng,
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      rethrow;
    }
  }

  Stream<DocumentSnapshot> getCurrentUsers() {
    return userCollection
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }
}
