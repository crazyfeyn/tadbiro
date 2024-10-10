import 'package:flutter_application_1/models/event_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationService {
  static final _location = Location();

  static bool _isServiceEnabled = false;
  static PermissionStatus _permissionStatus = PermissionStatus.denied;
  static LocationData? currentLocation;

  static Future<void> _checkService() async {
    _isServiceEnabled = await _location.serviceEnabled();

    if (!_isServiceEnabled) {
      _isServiceEnabled = await _location.requestService();
      if (!_isServiceEnabled) {
        return;
      }
    }
  }

  static Future<void> _checkPermission() async {
    _permissionStatus = await _location.hasPermission();

    if (_permissionStatus == PermissionStatus.denied) {
      _permissionStatus = await _location.requestPermission();
      if (_permissionStatus != PermissionStatus.granted) {
        return;
      }
    }
  }

  static Future<LocationData> getCurrentLocation() async {
    if (_isServiceEnabled && _permissionStatus == PermissionStatus.granted) {
      currentLocation = await _location.getLocation();
      return currentLocation!;
    }
    return LocationData.fromMap({'a': 2});
  }
}
