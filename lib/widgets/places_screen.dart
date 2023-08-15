import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_info.dart';
import '../pages/edit_location_info.dart';


class PlacesScreen extends StatefulWidget {
  @override
  State<PlacesScreen> createState() => _PlacesScreenState();
}

class _PlacesScreenState extends State<PlacesScreen> {
  List<LocationInfo> _locations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocations = prefs.getStringList('locations') ?? [];
    //print(_locations);
    //print(savedLocations);
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
    //print(_locations);
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: ListView.builder(
          itemCount: _locations.length,
          itemBuilder: (context, index) {
            final location = _locations[index];
            return Dismissible(
              key: Key(location.coordinates.toString()),
              direction: DismissDirection.endToStart,
              background: Container(
                alignment: Alignment.centerRight,
                color: Colors.red,
                child: const Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
              ),
              onDismissed: (direction) {
                _removeLocation(location);
              },
              child: ListTile(
                title: Text('Titulo: ${location.title}'),
                subtitle: Text('Descripcion: ${location.description}\nCategoria: ${location.category}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditLocationScreen(location: location),
                    ),
                  );
                },
              ),
            );
          },
        ),
      );
  }

  Future<void> _removeLocation(LocationInfo location) async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocations = prefs.getStringList('locations') ?? [];

    savedLocations.removeWhere((locString) {
      final parts = locString.split(';');
      final savedLocation = LocationInfo(
        coordinates: LatLng(double.parse(parts[0]), double.parse(parts[1])),
        title: parts[2],
        description: parts[3],
        category: parts[4],
      );
      return savedLocation.coordinates == location.coordinates;
    });

    await prefs.setStringList('locations', savedLocations);

    setState(() {
      _locations.remove(location);
    });
  }
}
