import 'package:flutter/material.dart';
import 'dart:math' as math;

/// [TouristLocation] - The architectural brain of the data.
class TouristLocation {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final int capacity;
  final int currentCrowd;
  final String description;
  final String statusText; // This is what Firestore has
  final String type;
  final String imageUrl;

  TouristLocation({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.capacity,
    required this.currentCrowd,
    required this.description,
    required this.statusText,
    this.type = 'Monument',
    this.imageUrl = 'https://via.placeholder.com/300',
  });

  // --- 🔥 THE FIX FOR YOUR ERROR ---
  // HomeScreen expects '.status', but you named it 'statusText'.
  // This getter maps it so the code doesn't break.
  String get status => statusText;

  // --- CALCULATED PROPERTIES ---

  double get crowdPercentage => (currentCrowd / capacity).clamp(0.0, 1.0);

  Color get statusColor {
    final ratio = crowdPercentage;
    if (ratio >= 0.85) return const Color(0xFFFF3131); // Red
    if (ratio >= 0.6) return const Color(0xFFFF914D); // Orange
    return const Color(0xFF00BF63); // Green
  }

  // Distance Logic (Haversine Formula)
  double calculateDistance(double userLat, double userLng) {
    const double p = 0.017453292519943295; // Pi/180
    final a =
        0.5 -
        math.cos((lat - userLat) * p) / 2 +
        math.cos(userLat * p) *
            math.cos(lat * p) *
            (1 - math.cos((lng - userLng) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km
  }

  // --- FIREBASE FACTORY ---
  factory TouristLocation.fromFirestore(String id, Map<String, dynamic> data) {
    return TouristLocation(
      id: id,
      name: data['name'] ?? 'Unknown Site',
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      capacity: (data['capacity'] as num).toInt(),
      currentCrowd: (data['current_crowd'] as num).toInt(),
      description: data['description'] ?? '',
      statusText: data['status'] ?? 'Safe', // Maps to the getter above
      type: data['type'] ?? 'Monument',
      imageUrl: data['image_url'] ?? 'https://via.placeholder.com/300',
    );
  }
}
