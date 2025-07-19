import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LocationData? _locationData;
  final Location _location = Location();

  final List<Map<String, dynamic>> _supermercados = [
    {
      "nome": "Supermercado João",
      "lat": -23.552,
      "lng": -46.634,
      "razaoSocial": "João Supermercados Ltda",
      "cnpj": "12.345.678/0001-90",
      "fotoUrl":
          "https://maps.googleapis.com/maps/api/streetview?size=400x200&location=-23.552,-46.634&key=AIzaSyDiURjUuJ68dYpyM2Vpw182QDN8n4KZW2w"
    },
    {
      "nome": "Supermercado Central",
      "lat": -23.560,
      "lng": -46.640,
      "razaoSocial": "Central Comércio de Alimentos S.A.",
      "cnpj": "98.765.432/0001-55",
      "fotoUrl": "https://via.placeholder.com/400x200.png?text=Central+Store"
    },
    {
      "nome": "Supermercado do Zé",
      "lat": -23.545,
      "lng": -46.625,
      "razaoSocial": "Zé Distribuidora ME",
      "cnpj": "11.222.333/0001-44",
      "fotoUrl": "https://via.placeholder.com/400x200.png?text=Supermercado+do+Zé"
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    try {
      final permission = await _location.hasPermission();
      if (permission == PermissionStatus.denied) {
        final granted = await _location.requestPermission();
        if (granted != PermissionStatus.granted) {
          print("⛔ Permissão negada");
          return;
        }
      }

      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final enabled = await _location.requestService();
        if (!enabled) {
          print("⛔ Serviço de localização não ativado");
          return;
        }
      }

      final loc = await _location.getLocation();
      print("📍 Localização retornada: ${loc.latitude}, ${loc.longitude}");
      setState(() => _locationData = loc);
    } catch (e, s) {
      print("💥 Erro no fetchLocation: $e");
      print(s);
    }
  }

  double _calculaDistancia(
      double lat1, double lon1, double lat2, double lon2) {
    const raioTerra = 6371;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) *
            cos(_toRad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return raioTerra * c;
  }

  double _toRad(double grau) => grau * pi / 180;

  void _abrirDetalhesLoja(Map<String, dynamic> mercado) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.6,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              SizedBox(height: 12),

              // Foto da loja
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  mercado['fotoUrl'] ??
                      'https://via.placeholder.com/400x200.png?text=Loja',
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 16),

              Text(
                mercado['nome'],
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 8),

              Text(
                "Razão Social: ${mercado['razaoSocial'] ?? 'Empresa Exemplo Ltda'}",
                style: TextStyle(fontSize: 16),
              ),

              SizedBox(height: 4),

              Text(
                "CNPJ: ${mercado['cnpj'] ?? '00.000.000/0001-00'}",
                style: TextStyle(fontSize: 16),
              ),

              Spacer(),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (_locationData == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Localização atual não disponível")),
                      );
                      return;
                    }
                    final origem =
                        '${_locationData!.latitude},${_locationData!.longitude}';
                    final destino = '${mercado["lat"]},${mercado["lng"]}';
                    final url = Uri.parse(
                        'https://www.google.com/maps/dir/?api=1&origin=$origem&destination=$destino&travelmode=driving');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Não foi possível abrir o Google Maps")),
                      );
                    }
                  },
                  icon: Icon(Icons.directions),
                  label: Text("Traçar rota no Google Maps"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("📍 Localização atual: $_locationData");

    return Scaffold(
      appBar: AppBar(title: Text('Hunter Market')),
      body: _locationData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: GoogleMap(
                    onMapCreated: (controller) => _mapController = controller,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _locationData!.latitude!,
                        _locationData!.longitude!,
                      ),
                      zoom: 14,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _supermercados.length,
                    itemBuilder: (context, index) {
                      final mercado = _supermercados[index];
                      final distancia = _calculaDistancia(
                        _locationData!.latitude!,
                        _locationData!.longitude!,
                        mercado["lat"],
                        mercado["lng"],
                      );

                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ElevatedButton(
                          onPressed: () => _abrirDetalhesLoja(mercado),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(mercado["nome"], style: TextStyle(fontSize: 16)),
                              Text('${distancia.toStringAsFixed(2)} km'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
    );
  }
}
