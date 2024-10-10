import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  final String eventId;
  final String userId;
  final String title;
  final Timestamp dateTime;
  final String description;
  final GeoPoint? location;
  String? imageUrl;
  String? locationName;
  List<dynamic> likedUsers;
  Map<String, dynamic> participants;

  EventModel({
    required this.eventId,
    required this.userId,
    required this.title,
    required this.dateTime,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.locationName,
    required this.likedUsers,
    required this.participants,
  });

  factory EventModel.fromDocumentSnapshot(DocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>;

    return EventModel(
        eventId: data['eventId'],
        userId: data['userId'],
        title: data['title'],
        dateTime: data['dateTime'],
        description: data['description'],
        location: data['location'],
        imageUrl: data['imageUrl'],
        locationName: data['locationName'] ?? '',
        likedUsers: data['LikedUsers'],
        participants: data['participants'],
        );
  }

  
}
