import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Carte extends StatefulWidget {
  const Carte({super.key});

  @override
  State<Carte> createState() => _CarteState();
}

class _CarteState extends State<Carte> {
  late GoogleMapController mapController; // Contrôleur de la carte

  // Position initiale de la caméra
  final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(37.7749, -122.4194), // San Francisco
    zoom: 10.0,
  );

  @override
  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carte Google Maps"),
      ),
      body: GoogleMap(
        onMapCreated: onMapCreated, // Créer la carte
        initialCameraPosition: _initialPosition, // Position initiale
        mapType: MapType.normal, // Type de la carte (normal, satellite, etc.)
      ),
    );
  }
}
