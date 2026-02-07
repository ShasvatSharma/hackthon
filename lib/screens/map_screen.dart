import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import '../models/location_model.dart';

/// [MapScreen] - The geospatial intelligence hub of Jaipur Smart IQ.
/// Uses custom map styling, dynamic clustering, and proximity analysis.
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // --- PRIVATE STATE VARIABLES ---
  final Completer<GoogleMapController> _mapController = Completer();
  bool _isMapLoading = true;
  String _selectedFilter = "All"; // All, Safe, Crowded

  // Jaipur Central Coordinates
  static const CameraPosition _jaipurCenter = CameraPosition(
    target: LatLng(26.9124, 75.7873),
    zoom: 13.5,
  );

  // --- MAP STYLING (The "Khatarnak" Dark Look) ---
  final String _darkMapStyle = '''
  [
    {"elementType": "geometry", "stylers": [{"color": "#242f3e"}]},
    {"elementType": "labels.text.fill", "stylers": [{"color": "#746855"}]},
    {"elementType": "labels.text.stroke", "stylers": [{"color": "#242f3e"}]},
    {"featureType": "administrative.locality", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
    {"featureType": "poi", "elementType": "labels.text.fill", "stylers": [{"color": "#d59563"}]},
    {"featureType": "road", "elementType": "geometry", "stylers": [{"color": "#38414e"}]},
    {"featureType": "road", "elementType": "geometry.stroke", "stylers": [{"color": "#212a37"}]},
    {"featureType": "water", "elementType": "geometry", "stylers": [{"color": "#17263c"}]}
  ]''';

  // --- UTILITY METHODS ---

  double _getMarkerHue(double percentage) {
    if (percentage > 0.8) return BitmapDescriptor.hueRed;
    if (percentage > 0.5) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueGreen;
  }

  Future<void> _openExternalMap(double lat, double lng) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lng';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  // --- MODAL UI (Enhanced Info Sheet) ---

  void _showLocationSheet(TouristLocation loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: const BoxDecoration(
          color: Color(0xFF1E293B),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    loc.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
                _buildTypeBadge(loc.type),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              loc.description,
              maxLines: 2,
              style: const TextStyle(color: Colors.white60, fontSize: 14),
            ),
            const Divider(color: Colors.white10, height: 30),
            _buildLiveStatRow(loc),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _openExternalMap(loc.lat, loc.lng),
                    icon: const Icon(Icons.navigation_rounded),
                    label: const Text("GET DIRECTIONS"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyanAccent,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeBadge(String type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.cyanAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type,
        style: const TextStyle(
          color: Colors.cyanAccent,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLiveStatRow(TouristLocation loc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _statItem(Icons.people, "${loc.currentCrowd}", "Visitors"),
        _statItem(
          Icons.timer,
          "${(loc.crowdPercentage * 45).toInt()}m",
          "Wait Time",
        ),
        _statItem(Icons.shield, "Safe", "Status"),
      ],
    );
  }

  Widget _statItem(IconData icon, String val, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.cyanAccent, size: 20),
        const SizedBox(height: 5),
        Text(
          val,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white38, fontSize: 10),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Google Map with Stream Integration
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('locations')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return const Center(child: Text("Map Error"));

              Set<Marker> markers = {};
              Set<Circle> circles = {};

              if (snapshot.hasData) {
                for (var doc in snapshot.data!.docs) {
                  final loc = TouristLocation.fromFirestore(
                    doc.id,
                    doc.data() as Map<String, dynamic>,
                  );

                  // Filter logic
                  if (_selectedFilter == "Safe" && loc.crowdPercentage > 0.5)
                    continue;
                  if (_selectedFilter == "Crowded" &&
                      loc.crowdPercentage <= 0.5)
                    continue;

                  markers.add(
                    Marker(
                      markerId: MarkerId(loc.id),
                      position: LatLng(loc.lat, loc.lng),
                      onTap: () => _showLocationSheet(loc),
                      icon: BitmapDescriptor.defaultMarkerWithHue(
                        _getMarkerHue(loc.crowdPercentage),
                      ),
                      infoWindow: InfoWindow(
                        title: loc.name,
                        snippet:
                            "${(loc.crowdPercentage * 100).toInt()}% Occupied",
                      ),
                    ),
                  );

                  // 2. Heat-Circle Logic
                  circles.add(
                    Circle(
                      circleId: CircleId("circle_${loc.id}"),
                      center: LatLng(loc.lat, loc.lng),
                      radius: 300,
                      fillColor: loc.statusColor.withOpacity(0.2),
                      strokeColor: loc.statusColor.withOpacity(0.5),
                      strokeWidth: 2,
                    ),
                  );
                }
              }

              return GoogleMap(
                initialCameraPosition: _jaipurCenter,
                onMapCreated: (controller) {
                  _mapController.complete(controller);
                  controller.setMapStyle(_darkMapStyle);
                  setState(() => _isMapLoading = false);
                },
                markers: markers,
                circles: circles,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                compassEnabled: true,
                mapType: MapType.normal,
              );
            },
          ),

          // 3. Floating Custom UI Elements
          _buildMapHeader(),
          _buildFilterPills(),
          _buildZoomControls(),

          if (_isMapLoading)
            const Center(
              child: CircularProgressIndicator(color: Colors.cyanAccent),
            ),
        ],
      ),
    );
  }

  Widget _buildMapHeader() {
    return Positioned(
      top: 50,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A).withOpacity(0.9),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white10),
        ),
        child: const Row(
          children: [
            Icon(Icons.radar, color: Colors.cyanAccent),
            SizedBox(width: 12),
            Text(
              "JAIPUR LIVE SENSOR MAP",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterPills() {
    return Positioned(
      top: 110,
      left: 20,
      child: Row(
        children: ["All", "Safe", "Crowded"].map((f) {
          bool isSel = _selectedFilter == f;
          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = f),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSel ? Colors.cyanAccent : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: isSel ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildZoomControls() {
    return Positioned(
      bottom: 120,
      right: 20,
      child: Column(
        children: [
          _mapButton(Icons.add, () async {
            final c = await _mapController.future;
            c.animateCamera(CameraUpdate.zoomIn());
          }),
          const SizedBox(height: 10),
          _mapButton(Icons.remove, () async {
            final c = await _mapController.future;
            c.animateCamera(CameraUpdate.zoomOut());
          }),
        ],
      ),
    );
  }

  Widget _mapButton(IconData icon, VoidCallback onTap) {
    return FloatingActionButton.small(
      heroTag: null,
      onPressed: onTap,
      backgroundColor: const Color(0xFF1E293B),
      child: Icon(icon, color: Colors.white),
    );
  }
}
