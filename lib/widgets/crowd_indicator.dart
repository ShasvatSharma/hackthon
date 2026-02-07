import 'package:flutter/material.dart';

/// [CrowdIndicator] - A high-fidelity occupancy visualizer.
/// Uses semantic coloring and multi-stage logic to communicate crowd density.
class CrowdIndicator extends StatelessWidget {
  final double percent;

  const CrowdIndicator({super.key, required this.percent});

  // --- SMART UI LOGIC ---

  /// Returns a status label based on occupancy percentage.
  String _getStatusLabel() {
    if (percent >= 0.9) return "CRITICAL";
    if (percent >= 0.7) return "CROWDED";
    if (percent >= 0.4) return "MODERATE";
    return "QUIET";
  }

  /// Returns a gradient color palette for the progress bar.
  List<Color> _getGradient() {
    if (percent >= 0.8) return [Colors.redAccent, Colors.deepOrange];
    if (percent >= 0.5) return [Colors.orangeAccent, Colors.amber];
    return [Colors.greenAccent, Colors.teal];
  }

  Color _getBaseColor() {
    if (percent >= 0.8) return Colors.redAccent;
    if (percent >= 0.5) return Colors.orangeAccent;
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    final statusLabel = _getStatusLabel();
    final barGradient = _getGradient();
    final accentColor = _getBaseColor();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Header Row with Dynamic Status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sensors,
                  size: 14,
                  color: accentColor.withOpacity(0.7),
                ),
                const SizedBox(width: 4),
                const Text(
                  "LIVE OCCUPANCY",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.white38,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: accentColor.withOpacity(0.3),
                  width: 0.5,
                ),
              ),
              child: Text(
                statusLabel,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // 2. Modern Progress Bar with Glowing Effect
        Stack(
          children: [
            // Background Track
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            // Animated Progress Fill
            AnimatedContainer(
              duration: const Duration(seconds: 1),
              curve: Curves.easeOutCubic,
              height: 10,
              width:
                  MediaQuery.of(context).size.width *
                  (percent.clamp(0.0, 1.0) * 0.8), // Responsive width
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: barGradient,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        // 3. Percentage Footer
        Align(
          alignment: Alignment.centerRight,
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "${(percent * 100).toInt()}% ",
                  style: TextStyle(
                    color: accentColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
                const TextSpan(
                  text: "Capacity utilized",
                  style: TextStyle(color: Colors.white24, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
