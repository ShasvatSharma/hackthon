import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../models/location_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _pulseController;
  String _searchQuery = "";
  String _selectedCategory = "All";
  final List<String> _categories = [
    "All",
    "Fort",
    "Palace",
    "Market",
    "Temple",
    "Garden",
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _triggerSOS() async {
    HapticFeedback.heavyImpact();
    await FirebaseFirestore.instance.collection('sos_alerts').add({
      'user': 'TOURIST_ID_882',
      'timestamp': FieldValue.serverTimestamp(),
      'status': 'CRITICAL',
    });
    _showCustomToast("🚨 EMERGENCY BROADCASTED", Colors.redAccent);
  }

  Future<void> _reportIssue() async {
    HapticFeedback.selectionClick();
    String? selectedType;
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildReportingSheet((type) {
        selectedType = type;
        Navigator.pop(context);
      }),
    );
    if (selectedType != null) {
      await FirebaseFirestore.instance.collection('civic_issues').add({
        'title': selectedType,
        'status': 'Pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
      _showCustomToast("✅ AI Logged: $selectedType", Colors.cyanAccent);
    }
  }

  void _showCustomToast(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildFuturisticHeader(),
              _buildSearchSection(),
              _buildCategoryPills(),
              _buildLiveWeatherCard(),
              _buildLocationListHeader(),
              _buildLocationGrid(),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          _buildBottomActionPanel(),
        ],
      ),
    );
  }

  Widget _buildFuturisticHeader() {
    return SliverAppBar(
      expandedHeight: 100,
      pinned: true,
      backgroundColor: const Color(0xFF020617),
      flexibleSpace: const FlexibleSpaceBar(
        title: Text(
          "JAIPUR SMART IQ",
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Scan Monuments...",
            hintStyle: const TextStyle(color: Colors.white24),
            prefixIcon: const Icon(Icons.search, color: Colors.cyanAccent),
            filled: true,
            fillColor: Colors.white.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPills() {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 40,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          itemCount: _categories.length,
          itemBuilder: (context, i) {
            bool isSel = _selectedCategory == _categories[i];
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = _categories[i]),
              child: Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: isSel
                      ? Colors.cyanAccent
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    _categories[i],
                    style: TextStyle(
                      color: isSel ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLiveWeatherCard() {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "24°C | Clear Sky",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            Icon(Icons.wb_sunny, color: Colors.orangeAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationListHeader() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          "LIVE CROWD TELEMETRY",
          style: TextStyle(color: Colors.white54, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildLocationGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('locations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const SliverToBoxAdapter(
            child: Center(child: CircularProgressIndicator()),
          );
        var docs = snapshot.data!.docs
            .where(
              (d) => d['name'].toString().toLowerCase().contains(_searchQuery),
            )
            .toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final loc = TouristLocation.fromFirestore(
                docs[index].id,
                docs[index].data() as Map<String, dynamic>,
              );
              return _buildProCard(loc);
            },
            childCount: docs.length, // FIX: itemCount ki jagah childCount
          ),
        );
      },
    );
  }

  Widget _buildProCard(TouristLocation loc) {
    double ratio = (loc.currentCrowd / loc.capacity).clamp(0.0, 1.0);
    Color statusColor = ratio > 0.8
        ? Colors.redAccent
        : (ratio > 0.5 ? Colors.orangeAccent : Colors.greenAccent);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: ratio,
            color: statusColor,
            backgroundColor: Colors.white10,
          ),
          const SizedBox(height: 10),
          Text(
            "${loc.currentCrowd} Visitors",
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionPanel() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _reportIssue,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
              ),
              child: const Text(
                "REPORT ISSUE",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _triggerSOS,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("SOS"),
          ),
        ],
      ),
    );
  }

  Widget _buildReportingSheet(Function(String) onSelect) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF1E293B),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: const Text(
              "Garbage Issue",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => onSelect("Garbage"),
          ),
          ListTile(
            title: const Text(
              "Street Light",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => onSelect("Light"),
          ),
        ],
      ),
    );
  }
}
