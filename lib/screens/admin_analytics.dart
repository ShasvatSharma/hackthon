import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminAnalytics extends StatelessWidget {
  const AdminAnalytics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("City Footfall Analytics")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('locations').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());

          List<BarChartGroupData> barGroups = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            var doc = snapshot.data!.docs[i];
            barGroups.add(
              BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: (doc['current_crowd'] as num).toDouble(),
                    color: Colors.deepPurpleAccent,
                    width: 20,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Live Visitor Count Comparison",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 300,
                  child: BarChart(BarChartData(barGroups: barGroups)),
                ),
                const SizedBox(height: 20),
                const Card(
                  color: Colors.white10,
                  child: ListTile(
                    leading: Icon(Icons.auto_awesome, color: Colors.amber),
                    title: Text("AI Forecast"),
                    subtitle: Text(
                      "Weekend footfall expected to rise by 40% due to local festivals.",
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
