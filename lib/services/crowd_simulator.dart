import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

/// [CrowdSimulator] - The Virtual IoT Sensor Engine.
/// Ye file ek "Digital Twin" ki tarah kaam karti hai jo real-time sensors
/// ki absence mein Firestore data ko simulate karti hai.
class CrowdSimulator {
  static Timer? _timer;

  /// Starts the automated crowd synchronization engine.
  static void startSimulation() {
    print("🚀 [IOT ENGINE] Initializing Live Crowd Simulation...");

    // Har 8-10 second mein "Sensor Data" mimic karega
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _runSimulationCycle();
    });
  }

  static Future<void> _runSimulationCycle() async {
    try {
      final hour = DateTime.now().hour;
      final snapshot = await FirebaseFirestore.instance
          .collection('locations')
          .get();

      // Batch update use karenge efficiency ke liye
      WriteBatch batch = FirebaseFirestore.instance.batch();

      for (var doc in snapshot.docs) {
        if (!doc.data().containsKey('current_crowd')) continue;

        int current = (doc['current_crowd'] as num).toInt();
        int capacity = (doc['capacity'] as num).toInt();

        // --- SMART SIMULATION LOGIC ---
        // 1. Peak Hour Bias: 12PM-5PM bheed badhne ke chances zyada honge
        // 2. Night Bias: 10PM-6AM bheed kam hone ke chances zyada honge
        int trendBias = 0;
        if (hour >= 11 && hour <= 17) trendBias = 2; // Peak time bheed badhao
        if (hour >= 22 || hour <= 6) trendBias = -4; // Raat ko bheed kam karo

        // Random change between -5 to +7 + trendBias
        int change = (Random().nextInt(13) - 5) + trendBias;

        int newCrowd = (current + change).clamp(0, capacity);

        // Update with Timestamp for analytics
        batch.update(doc.reference, {
          'current_crowd': newCrowd,
          'last_sync': FieldValue.serverTimestamp(),
          'trend': change >= 0 ? 'increasing' : 'decreasing',
        });
      }

      await batch.commit();
      print(
        "📊 [IOT ENGINE] Batch Update Complete. Sync Time: ${DateTime.now()}",
      );
    } catch (e) {
      print("⚠️ [IOT ENGINE] Error syncing virtual sensors: $e");
    }
  }

  static void stopSimulation() {
    _timer?.cancel();
    print("🛑 [IOT ENGINE] Simulation Stopped.");
  }
}
