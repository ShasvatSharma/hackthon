import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // Maine length 4 kar di hai naye Issue Reporting tab ke liye
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text(
          "COMMAND CENTER",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 10,
        actions: [
          IconButton(
            icon: const Icon(Icons.bolt, color: Colors.orangeAccent),
            onPressed: () => _showBulkActionSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true, // Scrollable taaki 4 tabs fit ho jayein
          indicatorColor: Colors.cyanAccent,
          labelColor: Colors.cyanAccent,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(icon: Icon(Icons.tune), text: "Control"),
            Tab(icon: Icon(Icons.history), text: "SOS Logs"),
            Tab(icon: Icon(Icons.analytics), text: "Stats"),
            Tab(icon: Icon(Icons.report_problem), text: "Issues"), // Naya Tab
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCrowdControlTab(),
          _buildSOSLogsTab(),
          _buildAnalyticsTab(),
          _buildCivicIssuesTab(), // Naya Function niche hai
        ],
      ),
    );
  }

  // --- TAB 1: CROWD CONTROL ---
  Widget _buildCrowdControlTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('locations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final docs = snapshot.data!.docs;
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            var data = docs[index].data() as Map<String, dynamic>;
            int current = data['current_crowd'] ?? 0;
            int capacity = data['capacity'] ?? 1000;
            double ratio = (current / capacity).clamp(0.0, 1.0);
            return _buildAdminCard(
              docs[index].id,
              data,
              current,
              capacity,
              ratio,
            );
          },
        );
      },
    );
  }

  // --- TAB 2: SOS LOGS ---
  Widget _buildSOSLogsTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('sos_alerts')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final logs = snapshot.data!.docs;
        if (logs.isEmpty)
          return const Center(
            child: Text(
              "No SOS Alerts",
              style: TextStyle(color: Colors.white54),
            ),
          );

        return ListView.builder(
          itemCount: logs.length,
          itemBuilder: (context, index) {
            var log = logs[index].data() as Map<String, dynamic>;
            DateTime? time = (log['timestamp'] as Timestamp?)?.toDate();
            return Card(
              color: Colors.redAccent.withOpacity(0.1),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  child: Icon(Icons.warning, color: Colors.white),
                ),
                title: Text(
                  log['user'] ?? "Unknown Tourist",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "Time: ${time != null ? DateFormat('jm').format(time) : 'Recent'}",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(
                  Icons.location_on,
                  color: Colors.cyanAccent,
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- TAB 3: STATS ---
  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              _buildStatCard("Total Sites", "12", Icons.business, Colors.blue),
              const SizedBox(width: 15),
              _buildStatCard("SOS Active", "3", Icons.emergency, Colors.red),
            ],
          ),
          const SizedBox(height: 15),
          _buildStatCard("Total Footfall", "4.5k", Icons.people, Colors.green),
          const SizedBox(height: 30),
          _buildSystemHealth(),
        ],
      ),
    );
  }

  // --- TAB 4: CIVIC ISSUES (WINNING FEATURE) ---
  Widget _buildCivicIssuesTab() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('civic_issues')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final issues = snapshot.data!.docs;
        if (issues.isEmpty)
          return const Center(
            child: Text(
              "No Reported Issues",
              style: TextStyle(color: Colors.white54),
            ),
          );

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: issues.length,
          itemBuilder: (context, index) {
            var issue = issues[index].data() as Map<String, dynamic>;
            bool isResolved = issue['status'] == 'Resolved';

            return Card(
              color: const Color(0xFF1E293B),
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  Icons.report,
                  color: isResolved ? Colors.greenAccent : Colors.orangeAccent,
                ),
                title: Text(
                  issue['title'] ?? "Civic Issue",
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  "Status: ${issue['status']}",
                  style: TextStyle(
                    color: isResolved ? Colors.greenAccent : Colors.cyanAccent,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white38,
                  ),
                  onPressed: () => FirebaseFirestore.instance
                      .collection('civic_issues')
                      .doc(issues[index].id)
                      .update({'status': 'Resolved'}),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // --- HELPER WIDGETS ---
  Widget _buildAdminCard(
    String id,
    Map<String, dynamic> data,
    int current,
    int capacity,
    double ratio,
  ) {
    bool isHigh = ratio > 0.8;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isHigh ? Colors.redAccent : Colors.white10),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              data['name'] ?? "Location",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Switch(
              value: data['status'] != 'Closed',
              onChanged: (v) => FirebaseFirestore.instance
                  .collection('locations')
                  .doc(id)
                  .update({'status': v ? 'Open' : 'Closed'}),
            ),
          ),
          LinearProgressIndicator(
            value: ratio,
            backgroundColor: Colors.white10,
            color: isHigh ? Colors.redAccent : Colors.cyanAccent,
          ),
          const SizedBox(height: 8),
          Text(
            "$current / $capacity Visitors",
            style: TextStyle(
              color: isHigh ? Colors.redAccent : Colors.white54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String t, String v, IconData i, Color c) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: c.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: c.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(i, color: c),
            const SizedBox(height: 5),
            Text(
              v,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              t,
              style: const TextStyle(fontSize: 10, color: Colors.white54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemHealth() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("AI Prediction Engine", style: TextStyle(color: Colors.white)),
          Text(
            "ACTIVE",
            style: TextStyle(
              color: Colors.greenAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _showBulkActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E293B),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.refresh, color: Colors.cyanAccent),
            title: const Text(
              "Reset All Footfall",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.emergency, color: Colors.redAccent),
            title: const Text(
              "Broadcast SOS",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
