import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Footfall Control")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('locations').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          return ListView(
            children: snapshot.data!.docs.map((doc) {
              return ListTile(
                title: Text(doc['name']),
                subtitle: Text("Crowd: ${doc['current_crowd']}"),
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: (doc['current_crowd'] as int).toDouble(),
                    max: (doc['capacity'] as int).toDouble(),
                    onChanged: (val) {
                      doc.reference.update({'current_crowd': val.toInt()});
                    },
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
