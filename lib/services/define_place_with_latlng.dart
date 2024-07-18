import 'dart:convert';
import 'package:http/http.dart' as http;

class DefinePlaceWithLatlng {
  static Future<String> getAddressFromCoordinates(
      double latitude, double longitude) async {
    const apiKey = 'AIzaSyDxcIfLomcjjZW7DEVOUpmzSCX1x1cgj9I';
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final address = jsonResponse['results'][0]['formatted_address'];
      return address;
    } else {
      throw Exception('Failed to load address');
    }
  }
}