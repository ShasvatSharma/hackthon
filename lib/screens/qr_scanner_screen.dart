import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    facing: CameraFacing.back,
  );

  bool _isProcessing = false;

  Future<void> _handleCapture(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        setState(() => _isProcessing = true);
        HapticFeedback.mediumImpact();

        try {
          final docRef = FirebaseFirestore.instance
              .collection('locations')
              .doc(code);
          final docSnap = await docRef.get();

          if (docSnap.exists) {
            await docRef.update({
              'current_crowd': FieldValue.increment(1),
              'last_updated': FieldValue.serverTimestamp(),
            });
            if (mounted) _showSuccess(docSnap.data()?['name'] ?? "Location");
          } else {
            _showError("Invalid QR Code");
          }
        } catch (e) {
          _showError("Database Connection Error");
        } finally {
          if (mounted) setState(() => _isProcessing = false);
        }
      }
    }
  }

  void _showSuccess(String name) {
    if (Navigator.canPop(context)) Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Checked in at $name"),
        backgroundColor: Colors.greenAccent[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: _controller, onDetect: _handleCapture),
          _buildOverlay(),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circularButton(Icons.close, () => Navigator.pop(context)),
                const Text(
                  "SCAN LOCATION QR",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),

                // --- NEW FIX FOR V6.0.0 ---
                // 'torchState' ko 'torchSwitchState' se badal diya gaya hai
                ValueListenableBuilder<TorchState>(
                  valueListenable: _controller.torchState,
                  builder: (context, state, child) {
                    final bool isOn = state == TorchState.on;
                    return _circularButton(
                      isOn ? Icons.flash_on : Icons.flash_off,
                      () => _controller.toggleTorch(),
                    );
                  },
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Align QR code within the frame",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.6),
        BlendMode.srcOut,
      ),
      child: Stack(
        children: [
          Container(color: Colors.transparent),
          Center(
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circularButton(IconData icon, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
