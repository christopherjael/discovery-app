import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/location_info.dart';

class EditLocationScreen extends StatefulWidget {
  final LocationInfo location;

  EditLocationScreen({required this.location});

  @override
  _EditLocationScreenState createState() => _EditLocationScreenState();
}

class _EditLocationScreenState extends State<EditLocationScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String _selectedCategory = 'Hotel'; // Valor predeterminado

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.location.title;
    _descriptionController.text = widget.location.description;
    _selectedCategory = widget.location.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Ubicación'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descripción'),
            ),
            SizedBox(height: 16),
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
            ElevatedButton(
              onPressed: () {
                // Guardar la ubicación editada y actualizar en SharedPreferences
                widget.location.title = _titleController.text;
                widget.location.description = _descriptionController.text;
                widget.location.category = _selectedCategory;
                _saveEditedLocation(widget.location);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveEditedLocation(LocationInfo location) async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocations = prefs.getStringList('locations') ?? [];

    final locationIndex = savedLocations.indexWhere((locString) {
      final parts = locString.split(';');
      final savedLocation = LocationInfo(
        coordinates: LatLng(double.parse(parts[0]), double.parse(parts[1])),
        title: parts[2],
        description: parts[3],
        category: parts[4]
      );

      return savedLocation.coordinates == location.coordinates;
    });

    if (locationIndex != -1) {
      savedLocations[locationIndex] =
          '${location.coordinates.latitude};${location.coordinates.longitude};${location.title};${location.description};${location.category}';
    }

    await prefs.setStringList('locations', savedLocations);
  }
}
