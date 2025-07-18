import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LocationData? _locationData;
  final Location _location = Location();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    final loc = await _location.getLocation();
    setState(() {
      _locationData = loc;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mapa')),
      body: _locationData == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: (controller) => _mapController = controller,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _locationData!.latitude!,
                  _locationData!.longitude!,
                ),
                zoom: 15,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
