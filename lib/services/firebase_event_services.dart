import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirebaseEventServices {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final CollectionReference eventCollection =
      FirebaseFirestore.instance.collection('events');

  Future<void> addEvent(
      String eventTitle,
      Timestamp eventDateTime,
      String eventDescription,
      LatLng? currentLocation,
      File? imageFile,
      String userId,
      String? locationName) async {
    try {
      String imageUrl = '';

      if (imageFile != null) {
        final imageReference = firebaseStorage.ref().child(
            "events/${FirebaseAuth.instance.currentUser!.uid}/${UniqueKey().toString()}.jpg");
        await imageReference.putFile(imageFile);
        imageUrl = await imageReference.getDownloadURL();
      }

      await eventCollection.add({
        'eventId': UniqueKey().toString(),
        'userId': userId,
        'title': eventTitle,
        'dateTime': eventDateTime,
        'description': eventDescription,
        'location': currentLocation != null
            ? GeoPoint(currentLocation.latitude, currentLocation.longitude)
            : null,
        'imageUrl': imageUrl,
        'locationName': locationName ?? '',
        'LikedUsers': [],
        'participants': {}
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> fetchMyEventStream(String userId) {
    return eventCollection.where('userId', isEqualTo: userId).snapshots();
  }

  Stream<QuerySnapshot> fetchEventStream() {
    return eventCollection.snapshots();
  }

  Future<void> deleteEvent(String eventId) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where('eventId', isEqualTo: eventId)
        .get();

    var realEventId = querySnapshot.docs.first;
    await eventCollection.doc(realEventId.id).delete();
  }

  Future<void> editEvent(
      String eventId,
      String eventTitle,
      Timestamp eventDateTime,
      String eventDescription,
      LatLng? currentLocation,
      File? imageFile,
      String? locationName) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventId', isEqualTo: eventId)
          .get();

      var realEventId = querySnapshot.docs.first;
      String imageUrl = '';

      if (imageFile != null) {
        final imageReference = firebaseStorage.ref().child(
            "events/${FirebaseAuth.instance.currentUser!.uid}/${UniqueKey().toString()}.jpg");
        await imageReference.putFile(imageFile);
        imageUrl = await imageReference.getDownloadURL();
      }

      await eventCollection.doc(realEventId.id).update({
        'title': eventTitle,
        'dateTime': eventDateTime,
        'description': eventDescription,
        'location': currentLocation != null
            ? GeoPoint(currentLocation.latitude, currentLocation.longitude)
            : null,
        'imageUrl': imageUrl,
        'locationName': locationName ?? '',
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> likeEvent(String eventId, String userId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventId', isEqualTo: eventId)
          .get();

      var realEventId = querySnapshot.docs.first;
      await eventCollection.doc(realEventId.id).update({
        'LikedUsers': FieldValue.arrayUnion([userId])
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> unlikeEvent(String eventId, String userId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventId', isEqualTo: eventId)
          .get();

      var realEventId = querySnapshot.docs.first;
      await eventCollection.doc(realEventId.id).update({
        'LikedUsers': FieldValue.arrayRemove([userId])
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> getRecentSevenDaysEvents() {
    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(Duration(days: 7));

    return eventCollection
        .where('dateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .snapshots();
  }

  Future<QuerySnapshot> getRecentSevenDaysEventsByIndividuallyParticipated(
      String userId) async {
    DateTime today = DateTime.now();
    DateTime sevenDaysAgo = today.subtract(Duration(days: 7));

    return await eventCollection
        .where('dateTime',
            isGreaterThanOrEqualTo: Timestamp.fromDate(sevenDaysAgo))
        .where('participants.$userId', isGreaterThan: 0)
        .get();
  }

  Future<void> addParticipant(
      Map<String, int> participants, String eventId) async {
    try {
      var querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventId', isEqualTo: eventId)
          .get();

      var realEventId = querySnapshot.docs.first;

      var doc = await eventCollection.doc(realEventId.id).get();
      Map<String, int> existingParticipants =
          Map<String, int>.from(doc['participants'] ?? {});

      participants.forEach((key, value) {
        if (existingParticipants.containsKey(key)) {
          existingParticipants[key] = existingParticipants[key]! + value;
        } else {
          existingParticipants[key] = value;
        }
      });

      await eventCollection
          .doc(realEventId.id)
          .update({'participants': existingParticipants});
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot> participatedEvents(String userId) {
    return eventCollection
        .where('participants.$userId', isGreaterThan: 0)
        .snapshots();
  }

}
