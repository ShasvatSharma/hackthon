import 'package:cloud_firestore/cloud_firestore.dart';

/// [SetupService] - The Database Architect.
/// Ye file Jaipur ke tourism data ko Firestore mein structure karti hai.
/// Iska use sirf tab karein jab data reset ya fresh setup karna ho.
class SetupService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final CollectionReference _locations = _db.collection('locations');

  /// Cleans and rebuilds the entire tourism ecosystem in Firestore.
  static Future<void> createInitialData() async {
    print("🚀 [SETUP] Starting Database Reconstruction...");

    try {
      // 1. CLEAR OLD DATA (Optimized)
      final snapshots = await _locations.get();
      if (snapshots.docs.isNotEmpty) {
        WriteBatch deleteBatch = _db.batch();
        for (var doc in snapshots.docs) {
          deleteBatch.delete(doc.reference);
        }
        await deleteBatch.commit();
        print("🗑️ [SETUP] Cleared ${snapshots.docs.length} legacy documents.");
      }

      // 2. ENHANCED DATA MODEL (Professional Level)
      // Yahan humne dynamic categories aur realistic metadata add kiya hai.
      List<Map<String, dynamic>> monuments = [
        {
          'id': 'amer_fort',
          'name': 'Amer Fort',
          'type': 'Fort/Heritage',
          'lat': 26.9855,
          'lng': 75.8513,
          'capacity': 2500,
          'current_crowd': 450,
          'description':
              'A massive 16th-century fortress on a hilltop, known for its artistic Hindu style elements.',
          'image_url': 'https://example.com/amer.jpg', // Placeholder
          'open_time': '09:00 AM',
          'close_time': '06:00 PM',
          'safety_index': 0.98,
        },
        {
          'id': 'hawa_mahal',
          'name': 'Hawa Mahal',
          'type': 'Palace',
          'lat': 26.9239,
          'lng': 75.8267,
          'capacity': 800,
          'current_crowd': 610,
          'description':
              'The "Palace of Winds" features a unique five-story exterior akin to a honeycomb.',
          'image_url': 'https://example.com/hawa.jpg',
          'open_time': '09:00 AM',
          'close_time': '05:00 PM',
          'safety_index': 0.85,
        },
        {
          'id': 'jal_mahal',
          'name': 'Jal Mahal',
          'type': 'Lake Palace',
          'lat': 26.9535,
          'lng': 75.8462,
          'capacity': 500,
          'current_crowd': 120,
          'description':
              'A stunning Rajput-style palace situated in the middle of Man Sagar Lake.',
          'image_url': 'https://example.com/jal.jpg',
          'open_time': '24/7 View',
          'close_time': 'NA',
          'safety_index': 0.99,
        },
        {
          'id': 'nahargarh',
          'name': 'Nahargarh Fort',
          'type': 'Fort/Viewpoint',
          'lat': 26.9374,
          'lng': 75.8156,
          'capacity': 1200,
          'current_crowd': 890,
          'description':
              'Standing on the edge of the Aravalli Hills, providing the best city skyline views.',
          'image_url': 'https://example.com/nahargarh.jpg',
          'open_time': '10:00 AM',
          'close_time': '08:00 PM',
          'safety_index': 0.75,
        },
        {
          'id': 'city_palace',
          'name': 'City Palace',
          'type': 'Royal Museum',
          'lat': 26.9258,
          'lng': 75.8237,
          'capacity': 1500,
          'current_crowd': 380,
          'description':
              'A complex of courtyards, gardens, and buildings, still the home of the Jaipur royal family.',
          'image_url': 'https://example.com/city.jpg',
          'open_time': '09:30 AM',
          'close_time': '05:00 PM',
          'safety_index': 0.95,
        },
      ];

      // 3. BATCH UPLOAD (Highly Efficient)
      // Ek saath saara data upload hoga, multiple network requests ki tension nahi.
      WriteBatch uploadBatch = _db.batch();

      for (var m in monuments) {
        // Adding creation metadata
        m['last_sync'] = FieldValue.serverTimestamp();
        m['search_keywords'] = [
          m['name'].toLowerCase(),
          m['type'].toLowerCase(),
        ];

        DocumentReference docRef = _locations.doc(m['id']);
        uploadBatch.set(docRef, m);
      }

      await uploadBatch.commit();
      print("✅ [SETUP] Database Jaipur Synced with Enterprise Schema!");
    } catch (e) {
      print("❌ [SETUP] Critical Error during DB Setup: $e");
    }
  }
}
