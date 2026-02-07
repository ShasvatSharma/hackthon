import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'auth_screen.dart';
import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    _navigateToNext();
  }

  _navigateToNext() async {
    // 3 seconds ka delay taaki animation dikhe
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    // Logic: Agar user pehle se login hai toh seedha Navigation (Home) pe bhejo
    User? user = FirebaseAuth.instance.currentUser;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            user != null ? const MainNavigation() : const AuthScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617), // Deep Space Blue
      body: Stack(
        children: [
          // Background Glow
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.1),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),

          FadeTransition(
            opacity: _fadeAnimation,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Futuristic Logo Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                    ),
                    child: const Icon(
                      Icons.hub_rounded,
                      color: Colors.cyanAccent,
                      size: 60,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // App Name with Orbitron font for Tech feel
                  Text(
                    "JAIPUR SMART IQ",
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Tagline
                  Text(
                    "UNIFIED TOURISM INTELLIGENCE",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.cyanAccent.withOpacity(0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Animated Loader
                  const SizedBox(
                    width: 40,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.white10,
                      color: Colors.cyanAccent,
                      minHeight: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Version Text
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "v2.0.4 | SECURED ACCESS",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.2),
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
