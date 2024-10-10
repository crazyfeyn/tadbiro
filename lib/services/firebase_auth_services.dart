import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_application_1/models/user_model.dart';
import 'package:flutter_application_1/services/location_services.dart';
import 'package:location/location.dart';

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
    final usersCollection = firebaseFirestore.collection('users');

    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final userDoc =
          usersCollection.doc(FirebaseAuth.instance.currentUser!.uid);

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

  Future<UserModel?> checkToken() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await userCollection.doc(user.uid).get();
      if (userDoc.exists) {
        // Get current location
        LocationData locationData = await LocationService.getCurrentLocation();
        String curLocateName = await getLocationName(locationData.latitude,
            locationData.longitude); // Fetch location name

        // Create UserModel with location data
        return UserModel.fromDocumentSnapshot(userDoc);
      }
    }
    return null;
  }

// This method should return a location name based on latitude and longitude.
// You can use a geocoding package or API for this purpose.
  Future<String> getLocationName(double? lat, double? lng) async {
    // Implement your logic to get the location name from lat/lng
    // For example, using a geocoding service
    // Here’s a placeholder implementation:
    return 'Location Name'; // Replace with actual location name
  }
}
