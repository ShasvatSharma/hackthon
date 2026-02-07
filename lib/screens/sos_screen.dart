import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class SOSScreen extends StatefulWidget {
  const SOSScreen({super.key});

  @override
  State<SOSScreen> createState() => _SOSScreenState();
}

class _SOSScreenState extends State<SOSScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  bool _isTriggered = false;
  double _progressValue = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _initiateSOS() async {
    setState(() => _isTriggered = true);
    HapticFeedback.heavyImpact();

    try {
      Position position = await _determinePosition();

      await FirebaseFirestore.instance.collection('sos_alerts').add({
        'user_id': 'Tourist_Alpha_99',
        'user_name': 'Guest Tourist',
        'location': GeoPoint(position.latitude, position.longitude),
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'CRITICAL',
      });

      if (mounted) _showEmergencyDialog();
    } catch (e) {
      debugPrint("SOS Error: $e");
    }
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: _isTriggered
                ? [Colors.red.withOpacity(0.3), const Color(0xFF0F172A)]
                : [const Color(0xFF1E293B), const Color(0xFF0F172A)],
            radius: 1.5,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            _buildHeader(),
            const Spacer(),
            _buildCentralSOSButton(),
            const Spacer(),
            _buildEmergencyContacts(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Icon(Icons.gpp_maybe_rounded, color: Colors.redAccent, size: 60),
        SizedBox(height: 10),
        Text(
          "EMERGENCY HUB",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w900, // Fixed here
            letterSpacing: 3,
          ),
        ),
      ],
    );
  }

  Widget _buildCentralSOSButton() {
    return GestureDetector(
      onLongPressStart: (_) {
        _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
          setState(() {
            _progressValue += 0.025;
            if (_progressValue >= 1.0) {
              _timer?.cancel();
              _initiateSOS();
            }
          });
        });
      },
      onLongPressEnd: (_) {
        _timer?.cancel();
        if (!_isTriggered) setState(() => _progressValue = 0.0);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ScaleTransition(
            scale: Tween(begin: 1.0, end: 1.3).animate(_pulseController),
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.withOpacity(0.1),
              ),
            ),
          ),
          SizedBox(
            height: 220,
            width: 220,
            child: CircularProgressIndicator(
              value: _progressValue,
              strokeWidth: 8,
              color: Colors.redAccent,
              backgroundColor: Colors.white10,
            ),
          ),
          Container(
            height: 160,
            width: 160,
            decoration: BoxDecoration(
              color: _isTriggered ? Colors.white : Colors.red,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _isTriggered ? Icons.check : Icons.touch_app,
                    color: _isTriggered ? Colors.red : Colors.white,
                    size: 40,
                  ),
                  Text(
                    _isTriggered ? "SENT" : "HOLD SOS",
                    style: TextStyle(
                      color: _isTriggered ? Colors.red : Colors.white,
                      fontWeight: FontWeight.w900, // Fixed error here
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContacts() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.local_police, color: Colors.blueAccent),
          Icon(Icons.medical_services, color: Colors.greenAccent),
          Icon(Icons.fire_truck, color: Colors.orangeAccent),
        ],
      ),
    );
  }

  void _showEmergencyDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text(
          "ALERT ACTIVE",
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          "Your live location is being tracked by Jaipur Police.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _isTriggered = false;
                _progressValue = 0.0;
              });
              Navigator.pop(c);
            },
            child: const Text(
              "CANCEL",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
