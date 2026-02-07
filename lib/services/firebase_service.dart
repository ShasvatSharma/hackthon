import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class CrowdSimulator {
  static void startSimulation() {
    // Har 10 second mein data update hoga
    Stream.periodic(const Duration(seconds: 10)).listen((_) async {
      try {
        var snapshot = await FirebaseFirestore.instance
            .collection('locations')
            .get();

        for (var doc in snapshot.docs) {
          // Data types ko safely handle karne ke liye (int/double mix-up fix)
          int current = (doc['current_crowd'] as num).toInt();
          int capacity = (doc['capacity'] as num).toInt();

          // Thodi bheed badhao ya kam karo (-5 se +5)
          int change = Random().nextInt(11) - 5;

          // Clamp logic: 0 se capacity ke beech hi rahega count
          int newCrowd = (current + change).clamp(0, capacity);

          // Firestore mein update
          await doc.reference.update({'current_crowd': newCrowd});
        }
        print("🔄 Live Crowd Sync: Locations updated successfully.");
      } catch (e) {
        print("❌ Simulation Error: $e");
      }
    });
  }
}
