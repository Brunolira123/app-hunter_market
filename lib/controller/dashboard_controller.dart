// lib/controllers/dashboard_controller.dart
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;

class DashboardController {
  Future<String> getCityName() async {
    try {
      final location = loc.Location();
      final serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        final enabled = await location.requestService();
        if (!enabled) return 'Serviço de localização desativado';
      }

      var permission = await location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        permission = await location.requestPermission();
        if (permission != loc.PermissionStatus.granted) {
          return 'Permissão negada';
        }
      }

      final currentLocation = await location.getLocation();

      final placemarks = await placemarkFromCoordinates(
        currentLocation.latitude ?? 0.0,
        currentLocation.longitude ?? 0.0,
      );

      return placemarks.first.locality ?? 'Cidade não encontrada';
    } catch (e) {
      return 'Erro ao localizar';
    }
  }
}
