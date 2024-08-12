import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/event_model.dart';
import 'package:flutter_application_1/services/firebase_event_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EventController extends ChangeNotifier {
  final firebaseEventServices = FirebaseEventServices();

  Future<void> addEvent(
      String eventTitle,
      Timestamp eventDateTime,
      String eventDescription,
      LatLng? currentLocation,
      File? imageFile,
      String userId,
      String locationName) async {
    return firebaseEventServices.addEvent(eventTitle, eventDateTime,
        eventDescription, currentLocation, imageFile, userId, locationName);
  }

  Stream<QuerySnapshot> fetchEventStream() {
    return firebaseEventServices.fetchEventStream();
  }

  Stream<QuerySnapshot> fetchMyEventStream(String userId) {
    return firebaseEventServices.fetchMyEventStream(userId);
  }

  Future<void> deleteEvent(String eventId) async {
    return firebaseEventServices.deleteEvent(eventId);
  }

  Future<void> editEvent(
      String eventId,
      String eventTitle,
      Timestamp eventDateTime,
      String eventDescription,
      LatLng? currentLocation,
      File? imageFile,
      String locationName) async {
    return firebaseEventServices.editEvent(eventId, eventTitle, eventDateTime,
        eventDescription, currentLocation, imageFile, locationName);
  }

  Stream<QuerySnapshot> getRecentSevenDaysEvents() {
    return firebaseEventServices.getRecentSevenDaysEvents();
  }

  void toggleLike(EventModel event, BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final isLiked = event.likedUsers.contains(userId);

    if (isLiked) {
      firebaseEventServices.unlikeEvent(event.eventId, userId);
      event.likedUsers.remove(userId);
    } else {
      firebaseEventServices.likeEvent(event.eventId, userId);
      event.likedUsers.add(userId);
    }

    notifyListeners();
  }

  Future<void> addParticipant(
      Map<String, int> participants, String eventId) async {
    return firebaseEventServices.addParticipant(participants, eventId);
  }

  Stream<QuerySnapshot> participatedEvents(String userId) {
    return firebaseEventServices.participatedEvents(userId);
  }

  Future<QuerySnapshot> getRecentSevenDaysEventsByIndividuallyParticipated(
      String userId) {
    return firebaseEventServices
        .getRecentSevenDaysEventsByIndividuallyParticipated(userId);
  }
}
