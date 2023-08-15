import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInfo {
  LatLng coordinates;
  String title;
  String description;
  String category;

  LocationInfo({
    required this.coordinates,
    required this.title,
    required this.description,
    required this.category
  });

  Map<String, dynamic> toMap() {
    return {
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
      'title': title,
      'description': description,
      'category': category
    };
  }

  static LocationInfo fromMap(Map<String, dynamic> map) {
    return LocationInfo(
      coordinates: LatLng(map['latitude'], map['longitude']),
      title: map['title'],
      description: map['description'],
      category: map['category']
    );
  }
}