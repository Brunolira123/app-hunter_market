import 'dart:convert';
import 'package:http/http.dart' as http;

class GooglePlacesService {
  static const _apiKey = 'AIzaSyDiURjUuJ68dYpyM2Vpw182QDN8n4KZW2w';

  static Future<List<Map<String, dynamic>>> buscarSupermercadosProximos(
      double lat, double lng) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$lat,$lng&radius=2000&type=supermarket&key=$_apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;

      return results.map<Map<String, dynamic>>((place) {
        return {
          'nome': place['name'],
          'lat': place['geometry']['location']['lat'],
          'lng': place['geometry']['location']['lng'],
          'fotoUrl': place['photos'] != null
              ? _montarUrlFoto(place['photos'][0]['photo_reference'])
              : 'https://via.placeholder.com/400x200.png?text=Sem+Foto',
          'endereco': place['vicinity'] ?? '',
          'placeId': place['place_id'],
        };
      }).toList();
    } else {
      throw Exception('Erro ao buscar supermercados: ${response.body}');
    }
  }

  static String _montarUrlFoto(String reference) {
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$reference&key=$_apiKey';
  }
}
