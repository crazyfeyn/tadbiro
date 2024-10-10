import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id;
  String? curLocateName;
  num? lat;
  num? lng;
  String email;
  String fullName;
  String profileImage;

  UserModel({
    required this.id,
    required this.curLocateName,
    required this.lat,
    required this.lng,
    required this.email,
    required this.fullName,
    required this.profileImage,
  });

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot query) {
    final data = query.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception("Data is null in document snapshot");
    }

    return UserModel(
      id: query.id as String? ?? '00',
      curLocateName: data['curLocateName'] as String? ?? '',
      lat: data['lat'] as double? ?? 0.0,
      lng: data['lng'] as double? ?? 0.0,
      email: data['email'] as String? ?? '',
      fullName: data['name'] as String? ?? '',
      profileImage: data['imageUrl'] as String? ??
          'https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg',
    );
  }
}
