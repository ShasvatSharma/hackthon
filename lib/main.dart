import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for Login
import 'package:google_sign_in/google_sign_in.dart'; // Added for Google Login
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import 'dart:math';
import 'firebase_options.dart';

// ===========================================================================
// MAIN ENTRY POINT
// ===========================================================================
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase Init Error: $e");
  }
  runApp(const SmartTourismApp());
}

class SmartTourismApp extends StatelessWidget {
  const SmartTourismApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Tourism IQ Pro',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF020617),
        primaryColor: Colors.cyanAccent,
        cardTheme: CardThemeData(
          color: const Color(0xFF1E293B),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ===========================================================================
// 1. SPLASH SCREEN (UPDATED WITH AUTH CHECK)
// ===========================================================================
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() async {
    // 3 seconds delay for branding
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is already logged in
    User? user = FirebaseAuth.instance.currentUser;

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            user != null ? const MainNavigationHub() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Color(0xFF1E293B), Color(0xFF020617)],
            radius: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.auto_awesome_motion_rounded,
              size: 100,
              color: Colors.cyanAccent,
            ),
            const SizedBox(height: 30),
            Text(
              "SMART TOURISM IQ",
              style: GoogleFonts.orbitron(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "AI-POWERED DESTINATION MANAGEMENT",
              style: TextStyle(color: Colors.white38, letterSpacing: 1.2),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(
              color: Colors.cyanAccent,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// 2. LOGIN SCREEN (UPDATED TO GOOGLE SIGN-IN)
// ===========================================================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainNavigationHub()),
          );
        }
      }
    } catch (e) {
      debugPrint("Login Error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Login Failed: $e")));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Access Hub",
                style: GoogleFonts.orbitron(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign in to access Command Center",
                style: TextStyle(color: Colors.white54),
              ),
              const SizedBox(height: 60),
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.cyanAccent)
                  : ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: const Icon(Icons.g_mobiledata, size: 35),
                      label: const Text("SIGN IN WITH GOOGLE"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        minimumSize: const Size(double.infinity, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// 3. MAIN NAVIGATION HUB (EXACTLY AS PROVIDED)
// ===========================================================================
class MainNavigationHub extends StatefulWidget {
  const MainNavigationHub({super.key});
  @override
  State<MainNavigationHub> createState() => _MainNavigationHubState();
}

class _MainNavigationHubState extends State<MainNavigationHub> {
  int _index = 0;
  final List<Widget> _screens = [
    const SmartDashboard(),
    const ExploreMapScreen(),
    const SOSScreen(),
    const AdminPanel(),
  ];

  @override
  void initState() {
    super.initState();
    _startSimulation();
  }

  void _startSimulation() {
    Timer.periodic(const Duration(seconds: 15), (timer) async {
      try {
        var zones = await FirebaseFirestore.instance.collection('zones').get();
        for (var doc in zones.docs) {
          await doc.reference.update({'density': Random().nextInt(100)});
        }
      } catch (e) {
        debugPrint("AI Simulator Active...");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.cyanAccent,
        unselectedItemColor: Colors.white24,
        backgroundColor: const Color(0xFF0F172A),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics_rounded),
            label: "Live Hub",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_rounded),
            label: "Explore",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emergency_rounded),
            label: "SOS",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.admin_panel_settings),
            label: "Admin",
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// 4. SMART DASHBOARD (LIVE HUB) (EXACTLY AS PROVIDED)
// ===========================================================================
class SmartDashboard extends StatelessWidget {
  const SmartDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "SMART DASHBOARD",
          style: GoogleFonts.orbitron(fontSize: 16),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('zones').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          var zones = snapshot.data!.docs;
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: zones.length,
            itemBuilder: (context, index) {
              var data = zones[index].data() as Map<String, dynamic>;
              int density = data['density'] ?? 0;
              Color color = density > 75
                  ? Colors.redAccent
                  : (density > 45 ? Colors.orangeAccent : Colors.greenAccent);

              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: color.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['name'],
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "$density%",
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    LinearProgressIndicator(
                      value: density / 100,
                      color: color,
                      backgroundColor: Colors.white10,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.query_stats, size: 14, color: color),
                        const SizedBox(width: 5),
                        Text(
                          density > 75 ? "Heavy Traffic" : "Clear Flow",
                          style: TextStyle(fontSize: 12, color: color),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailScreen(
                                name: data['name'],
                                density: density,
                              ),
                            ),
                          ),
                          child: const Text(
                            "VIEW INSIGHTS >",
                            style: TextStyle(color: Colors.cyanAccent),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ===========================================================================
// 5. EXPLORE MAP (ACTIVE NAVIGATION) (EXACTLY AS PROVIDED)
// ===========================================================================
class ExploreMapScreen extends StatefulWidget {
  const ExploreMapScreen({super.key});
  @override
  State<ExploreMapScreen> createState() => _ExploreMapScreenState();
}

class _ExploreMapScreenState extends State<ExploreMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  Future<void> _openGoogleMaps(double lat, double lng) async {
    final String url = "google.navigation:q=$lat,$lng&mode=d";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Maps app not found!")),
      );
    }
  }

  void _showNavSheet(String name, double lat, double lng) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: GoogleFonts.orbitron(
                fontSize: 22,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "AI has calculated the most efficient route based on current live crowd density.",
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _openGoogleMaps(lat, lng),
              icon: const Icon(Icons.navigation_rounded),
              label: const Text("NAVIGATE NOW"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(27.1751, 78.0421),
          zoom: 14,
        ),
        onMapCreated: (c) => _controller.complete(c),
        markers: {
          Marker(
            markerId: const MarkerId('taj'),
            position: const LatLng(27.1751, 78.0421),
            onTap: () => _showNavSheet("Taj Mahal", 27.1751, 78.0421),
          ),
          Marker(
            markerId: const MarkerId('fort'),
            position: const LatLng(27.1795, 78.0211),
            onTap: () => _showNavSheet("Agra Fort", 27.1795, 78.0211),
          ),
        },
      ),
    );
  }
}

// ===========================================================================
// 6. SOS EMERGENCY SYSTEM (EXACTLY AS PROVIDED)
// ===========================================================================
class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});
  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> {
  bool _isHolding = false;

  void _triggerSOS() async {
    await FirebaseFirestore.instance.collection('sos_logs').add({
      'status': 'CRITICAL',
      'user': FirebaseAuth.instance.currentUser?.displayName ?? 'Tourist_091',
      'timestamp': FieldValue.serverTimestamp(),
    });
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🚨 SOS SIGNAL SENT!"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "EMERGENCY PROTOCOL",
              style: GoogleFonts.orbitron(
                color: Colors.redAccent,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 80),
            GestureDetector(
              onLongPressStart: (_) => setState(() => _isHolding = true),
              onLongPressEnd: (_) => setState(() => _isHolding = false),
              onLongPress: _triggerSOS,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  color: _isHolding ? Colors.red : Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                    width: _isHolding ? 15 : 4,
                  ),
                  boxShadow: _isHolding
                      ? [const BoxShadow(color: Colors.red, blurRadius: 80)]
                      : [],
                ),
                child: Center(
                  child: Text(
                    _isHolding ? "SENDING..." : "SOS",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Hold for 2 seconds for immediate assistance",
              style: TextStyle(color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================
// 7. ADMIN CONTROL PANEL (EXACTLY AS PROVIDED)
// ===========================================================================
class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("COMMAND CENTER")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('sos_logs')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return const Center(child: CircularProgressIndicator());
          var logs = snapshot.data!.docs;
          if (logs.isEmpty)
            return const Center(
              child: Text("All systems operational. No active SOS."),
            );

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: logs.length,
            itemBuilder: (context, index) {
              var log = logs[index].data() as Map<String, dynamic>;
              return Card(
                color: Colors.red.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.redAccent,
                  ),
                  title: Text("Alert: ${log['status']}"),
                  subtitle: Text(
                    "Time: ${log['timestamp']?.toDate() ?? 'Pending'}\nUser: ${log['user'] ?? 'Unknown'}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ===========================================================================
// 8. PLACE DETAIL SCREEN (AI INSIGHTS) (EXACTLY AS PROVIDED)
// ===========================================================================
class PlaceDetailScreen extends StatelessWidget {
  final String name;
  final int density;
  const PlaceDetailScreen({
    super.key,
    required this.name,
    required this.density,
  });

  @override
  Widget build(BuildContext context) {
    Color color = density > 75 ? Colors.redAccent : Colors.greenAccent;
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "PREDICTIVE ANALYSIS",
              style: GoogleFonts.orbitron(color: color, fontSize: 12),
            ),
            const SizedBox(height: 20),
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: CustomPaint(painter: AIPathPainter(density, color)),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border(left: BorderSide(color: color, width: 8)),
              ),
              child: Text(
                density > 75
                    ? "AI Suggestion: High congestion. Recommend alternative heritage site or delay visit."
                    : "AI Suggestion: Minimal queue detected. Ideal time for high-quality photography.",
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AIPathPainter extends CustomPainter {
  final int d;
  final Color c;
  AIPathPainter(this.d, this.c);
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = c
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    var path = Path()
      ..moveTo(0, size.height * 0.9)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * (1 - d / 100),
        size.width,
        size.height * 0.2,
      );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
