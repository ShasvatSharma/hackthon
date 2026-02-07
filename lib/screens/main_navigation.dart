import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// --- FIXED IMPORTS ---
import 'home_screen.dart';
import 'map_screen.dart';
import 'sos_screen.dart';
import 'qr_scanner_screen.dart';
import 'admin_screen.dart';
import 'prediction_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _touristPoints = 150;
  String _userRank = "Gold Explorer";

  // --- FIXED SCREENS LIST ---
  final List<Widget> _screens = [
    const HomeScreen(),
    const MapScreen(),
    const SOSScreen(),
    const PredictionScreen(), // <-- Yahan 'ForecastScreen' ki jagah 'PredictionScreen' likha hai
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (_selectedIndex == index) return;
    HapticFeedback.selectionClick();
    _fadeController.reset();
    setState(() => _selectedIndex = index);
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: const Color(0xFF0F172A),
      appBar: _buildProfessionalAppBar(context),
      drawer: _buildSmartDrawer(context),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _screens[_selectedIndex],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildCentralActionButton(context),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  PreferredSizeWidget _buildProfessionalAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFF1E293B),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Smart Tourism IQ",
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
          ),
          Text(
            _userRank,
            style: const TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
      actions: [
        _buildPointsChip(),
        IconButton(
          icon: const Icon(Icons.insights_rounded, color: Colors.cyanAccent),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const AdminScreen()),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildPointsChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.cyanAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.stars, color: Colors.amber, size: 16),
            const SizedBox(width: 6),
            Text(
              "$_touristPoints pts",
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: const Color(0xFF1E293B),
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home_rounded, "Home", 0),
            _navItem(Icons.map_rounded, "Map", 1),
            const SizedBox(width: 40),
            _navItem(Icons.emergency_rounded, "SOS", 2),
            _navItem(Icons.auto_graph_rounded, "Forecast", 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onDestinationSelected(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isSelected ? Colors.cyanAccent : Colors.white38,
            size: 26,
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.cyanAccent : Colors.white38,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCentralActionButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.cyanAccent,
      shape: const CircleBorder(),
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (c) => const QRScannerScreen()),
      ),
      child: const Icon(
        Icons.qr_code_scanner_rounded,
        color: Color(0xFF0F172A),
        size: 30,
      ),
    );
  }

  Widget _buildSmartDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0F172A),
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Color(0xFF1E293B)),
            accountName: const Text("Tourist Explorer"),
            accountEmail: Text("Points: $_touristPoints | Rank: $_userRank"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.cyanAccent,
              child: Icon(Icons.person),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
            title: const Text(
              "Exit App",
              style: TextStyle(color: Colors.white),
            ),
            onTap: () => SystemNavigator.pop(),
          ),
        ],
      ),
    );
  }
}
