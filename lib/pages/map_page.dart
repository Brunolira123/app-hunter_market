import 'dart:io';
import 'dart:math';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';
import '../services/google_places_service.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  loc.LocationData? _locationData;
  final loc.Location _location = loc.Location();

  List<Map<String, dynamic>> _supermercados = [];
  final Set<Marker> _marcadores = {};
  final Set<Circle> _circulos = {};

  double _raioKm = 10.0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _fetchLocation();
    await _buscarSupermercados();
  }

  Future<void> _fetchLocation() async {
    try {
      final permission = await _location.hasPermission();
      if (permission == loc.PermissionStatus.denied) {
        final granted = await _location.requestPermission();
        if (granted != loc.PermissionStatus.granted) return;
      }
      final serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        final enabled = await _location.requestService();
        if (!enabled) return;
      }
      final locData = await _location.getLocation();
      setState(() => _locationData = locData);
      _atualizarCirculo();
    } catch (_) {}
  }

  Future<void> _buscarSupermercados() async {
    if (_locationData == null) return;

    final lat = _locationData!.latitude!;
    final lng = _locationData!.longitude!;
    final raioMetros = _raioKm * 1000;

    final resultados = await GooglePlacesService.buscarSupermercadosProximos(
      lat,
      lng,
      raioMetros,
    );

    final filtrados = resultados.where((mercado) {
      if (mercado["lat"] == null || mercado["lng"] == null) return false;

      final dist = _calculaDistancia(lat, lng, mercado["lat"], mercado["lng"]);
      return dist <= _raioKm;
    }).toList();

    filtrados.sort((a, b) {
      final distA = _calculaDistancia(lat, lng, a["lat"], a["lng"]);
      final distB = _calculaDistancia(lat, lng, b["lat"], b["lng"]);
      return distA.compareTo(distB);
    });

    setState(() {
      _supermercados = filtrados;
      _marcadores.clear();

      for (var mercado in filtrados) {
        _marcadores.add(
          Marker(
            markerId: MarkerId(mercado["placeId"] ?? UniqueKey().toString()),
            position: LatLng(mercado["lat"], mercado["lng"]),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueOrange,
            ),
            infoWindow: InfoWindow(
              title: mercado["nome"],
              snippet: "Toque para ver mais",
              onTap: () => _abrirDetalhesLoja(mercado),
            ),
          ),
        );
      }
    });
  }

  double _calculaDistancia(double lat1, double lon1, double lat2, double lon2) {
    const raioTerra = 6371;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return raioTerra * c;
  }

  double _toRad(double grau) => grau * pi / 180;

  void _atualizarCirculo() {
    if (_locationData == null) return;

    setState(() {
      _circulos.clear();
      _circulos.add(
        Circle(
          circleId: CircleId('raio_pesquisa'),
          center: LatLng(_locationData!.latitude!, _locationData!.longitude!),
          radius: _raioKm * 1000,
          fillColor: Colors.orange.withOpacity(0.2),
          strokeColor: Colors.orange,
          strokeWidth: 2,
        ),
      );
    });
  }

  void _onRaioChanged(double novoRaio) {
    setState(() => _raioKm = novoRaio);
    _atualizarCirculo();
    _buscarSupermercados();
  }

  void _abrirDetalhesLoja(Map<String, dynamic> mercado) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        maxChildSize: 0.85,
        minChildSize: 0.4,
        builder: (_, controller) => SingleChildScrollView(
          controller: controller,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    mercado['fotoUrl'],
                    height: 180,
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
                  "Endereço: ${mercado['endereco'] ?? 'N/D'}",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () async {
                        final origem =
                            '${_locationData!.latitude},${_locationData!.longitude}';
                        final destino = '${mercado["lat"]},${mercado["lng"]}';
                        final url = Uri.parse(
                          'https://www.google.com/maps/dir/?api=1&origin=$origem&destination=$destino&travelmode=driving',
                        );
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      icon: Icon(Icons.navigation),
                      label: Text("Rota"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _abrirLinkCrm(context),
                      icon: Icon(Icons.open_in_browser),
                      label: Text("CRM"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _abrirLinkCrm(BuildContext context) async {
    const urlString = 'https://vrsoftware.bitrix24.com.br/crm/lead/list/';
    final url = Uri.parse(urlString);

    try {
      if (Platform.isAndroid) {
        final intent = AndroidIntent(action: 'action_view', data: urlString);
        await intent.launch();
      } else if (Platform.isIOS) {
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao abrir link: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hunter Market'),
        backgroundColor: Colors.orange,
      ),
      body: _locationData == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
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
                    markers: _marcadores,
                    circles: _circulos,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Raio: ${_raioKm.toStringAsFixed(1)} km',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800],
                        ),
                      ),
                      Slider(
                        value: _raioKm,
                        min: 1,
                        max: 50,
                        divisions: 49,
                        label: '${_raioKm.toStringAsFixed(1)} km',
                        activeColor: Colors.orange,
                        onChanged: _onRaioChanged,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _supermercados.isEmpty
                      ? Center(child: Text('Nenhum mercado encontrado'))
                      : ListView.builder(
                          itemCount: _supermercados.length,
                          itemBuilder: (context, index) {
                            final mercado = _supermercados[index];
                            final distancia = _calculaDistancia(
                              _locationData!.latitude!,
                              _locationData!.longitude!,
                              mercado["lat"],
                              mercado["lng"],
                            );
                            return Card(
                              margin: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                              child: ListTile(
                                onTap: () => _abrirDetalhesLoja(mercado),
                                contentPadding: EdgeInsets.all(12),
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    mercado['fotoUrl'],
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                title: Text(
                                  mercado["nome"],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  '${distancia.toStringAsFixed(1)} km\n${mercado["endereco"] ?? ""}',
                                ),
                                trailing: Icon(Icons.arrow_forward_ios),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
