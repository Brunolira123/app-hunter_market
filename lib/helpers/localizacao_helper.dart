import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class LocationHelper {
  static Future<loc.LocationData?> getLocation() async {
    final location = loc.Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return null;
    }

    loc.PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) return null;
    }

    try {
      return await location.getLocation();
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getCityName(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        final cidade =
            placemarks.first.locality ?? placemarks.first.subAdministrativeArea;
        return cidade ?? "Cidade não identificada";
      }
    } catch (_) {
      return null;
    }
    return null;
  }
}
