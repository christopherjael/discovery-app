import 'dart:async';
import 'package:discoveryapp/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_info.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Location _location = Location();
  List<LocationInfo> _locations = [];

  final TextEditingController _searchController = TextEditingController();

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(18.48187182164199, -69.91422944296767),
    zoom: 12.0,
  );

  Future<void> _loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocations = prefs.getStringList('locations') ?? [];

    setState(() {
      _locations = savedLocations.map((locationString) {
        final parts = locationString.split(';');
        return LocationInfo(
          coordinates: LatLng(double.parse(parts[0]), double.parse(parts[1])),
          title: parts[2],
          description: parts[3],
          category: parts[4],
        );
      }).toList();
    });
  }

  Future<void> _saveLocations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    final locationsToSave = _locations
        .map((location) =>
    '${location.coordinates.latitude};${location.coordinates.longitude};${location.title};${location.description};${location.category}')
        .toList();
    await prefs.setStringList('locations', locationsToSave);
  }

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _searchController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      hintText: 'Busca un lugar',
                    ),
                    onChanged: (value){print(value);},
                  ),
                ),
              ),
              IconButton(onPressed: ()async{
                var place = await LocationService().getPlace(_searchController.text);
                goToOnePlace(place);
              }, icon: Icon(Icons.search),),
            ],
          ),
          Expanded(
            child: GoogleMap(
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _controller.complete(controller);
                });
              },
              onLongPress: (LatLng latLng) {
                _showLocationDialog(latLng);
              },
              markers: _locations.map((location) {
                return Marker(
                  markerId: MarkerId(location.coordinates.toString()),
                  position: location.coordinates,
                  infoWindow: InfoWindow(
                    title: location.title,
                    snippet: location.description,
                  ),
                  icon: //BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/img/star.png').then((value) => value);
                );
              }).toSet(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.location_searching),
        backgroundColor: Colors.white,
      ),
    );
  }

  void _showLocationDialog(LatLng latLng) async {
    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    String _selectedCategory = 'Hotel'; // Valor predeterminado
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Agregar Información de Ubicación'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                ),
                DropdownButtonFormField<String>(
                  isExpanded: true,
                  hint: Text(
                    _selectedCategory,
                  ),
                  onSaved: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                    });
                  },
                  items: ['Hotel', 'Restaurante', 'Parque', 'Museo'] // Agrega más categorías si es necesario
                      .map<DropdownMenuItem<String>>((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    _locations.add(
                      LocationInfo(
                        coordinates: latLng,
                        title: titleController.text,
                        description: descriptionController.text,
                        category: _selectedCategory
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                },
                child: Text('Agregar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
            ],
          );
        },
    );

    await _saveLocations();

    //Navigator.of(context).pop();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Verificar si la aplicación tiene permiso de ubicación
    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Obtener la ubicación actual del usuario
    LocationData locationData = await _location.getLocation();

    // Mover la cámara del mapa a la ubicación actual
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(locationData.latitude!,locationData.longitude!), zoom: 20.0)),
    );
  }

    Future<void> goToOnePlace(Map<String, dynamic> place) async {
      final double lat = place['geometry']['location']['lat'];
      final double lng = place['geometry']['location']['lng'];

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(lat, lng), zoom: 12),
        ),
      );
  }
}
