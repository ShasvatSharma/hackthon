import 'package:flutter/material.dart';
import 'dart:math' as math;

class PredictionScreen extends StatefulWidget {
  final String locationName;

  // Maine yahan default value daal di hai taaki navigation mein error na aaye
  const PredictionScreen({super.key, this.locationName = "Jaipur Smart IQ"});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen>
    with TickerProviderStateMixin {
  late AnimationController _chartController;
  String _selectedDay = "Today";

  final List<double> _hourlyData = [0.2, 0.3, 0.5, 0.8, 0.9, 0.7, 0.4, 0.2];
  final List<String> _hours = [
    "8AM",
    "10AM",
    "12PM",
    "2PM",
    "4PM",
    "6PM",
    "8PM",
    "10PM",
  ];

  @override
  void initState() {
    super.initState();
    _chartController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAIHeader(),
                  const SizedBox(height: 30),
                  _buildTrendSelector(),
                  const SizedBox(height: 20),
                  _buildVisualChart(),
                  const SizedBox(height: 30),
                  _buildWeatherImpactCard(),
                  const SizedBox(height: 30),
                  const Text(
                    "HOURLY BREAKDOWN",
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildPredictionList(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 120,
      backgroundColor: const Color(0xFF1E293B),
      floating: false,
      pinned: true,
      title: Text(
        widget.locationName,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildAIHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.cyanAccent.withOpacity(0.1),
            Colors.blueAccent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.psychology, color: Colors.cyanAccent, size: 40),
          const SizedBox(width: 20),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "AI FORECAST ACTIVE",
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                Text(
                  "94% Accuracy Rate",
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                SizedBox(height: 5),
                Text(
                  "Predicting crowd shifts based on Jaipur Festival Season & Weather.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ["Today", "Tomorrow", "Weekend"].map((day) {
        bool isSel = _selectedDay == day;
        return GestureDetector(
          onTap: () => setState(() => _selectedDay = day),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: isSel ? Colors.cyanAccent : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              day,
              style: TextStyle(
                color: isSel ? Colors.black : Colors.white60,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildVisualChart() {
    return Container(
      height: 200,
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(25),
      ),
      child: AnimatedBuilder(
        animation: _chartController,
        builder: (context, child) => CustomPaint(
          painter: ChartPainter(
            data: _hourlyData,
            animationValue: _chartController.value,
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherImpactCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orangeAccent.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orangeAccent.withOpacity(0.1)),
      ),
      child: const Row(
        children: [
          Icon(Icons.wb_sunny, color: Colors.orangeAccent),
          SizedBox(width: 15),
          Expanded(
            child: Text(
              "High Temperature (38°C) expected. AI predicts 20% less crowd in open areas during 12PM-4PM.",
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionList() {
    return Column(
      children: List.generate(_hours.length, (index) {
        double val = _hourlyData[index];
        Color color = val > 0.7
            ? Colors.redAccent
            : (val > 0.4 ? Colors.orangeAccent : Colors.greenAccent);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.02),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            children: [
              Text(
                _hours[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                val > 0.7 ? "CRITICAL" : (val > 0.4 ? "MODERATE" : "QUIET"),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ChartPainter extends CustomPainter {
  final List<double> data;
  final double animationValue;
  ChartPainter({required this.data, required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.cyanAccent.withOpacity(0.3), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();
    double dx = size.width / (data.length - 1);

    path.moveTo(0, size.height - (data[0] * size.height * animationValue));
    fillPath.moveTo(0, size.height);
    fillPath.lineTo(0, size.height - (data[0] * size.height * animationValue));

    for (int i = 1; i < data.length; i++) {
      double x = i * dx;
      double y = size.height - (data[i] * size.height * animationValue);
      path.lineTo(x, y);
      fillPath.lineTo(x, y);
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();
    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
