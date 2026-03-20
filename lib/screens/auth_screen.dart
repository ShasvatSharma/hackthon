import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;

  void _submit() async {
    if (_email.text.isEmpty || _pass.text.length < 6) {
      _showError("Enter valid email & 6+ digit password");
      return;
    }

    setState(() => isLoading = true);
    String? error;
    
    if (isLogin) {
      error = await AuthService().login(_email.text.trim(), _pass.text.trim());
    } else {
      error = await AuthService().register(_email.text.trim(), _pass.text.trim());
    }

    if (error == null) {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => const HomeScreen()));
    } else {
      _showError(error);
    }
    setState(() => isLoading = false);
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF020617),
      body: Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.shield_outlined, color: Colors.cyanAccent, size: 50),
            const SizedBox(height: 20),
            Text(isLogin ? "TOURIST LOGIN" : "RESERVE ACCOUNT", 
                style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
            const Text("Authorized Access Only - Smart Jaipur IQ", style: TextStyle(color: Colors.white38, fontSize: 12)),
            const SizedBox(height: 40),
            
            _buildInput(_email, "Command Email", Icons.alternate_email),
            const SizedBox(height: 15),
            _buildInput(_pass, "Security Key", Icons.lock_outline, obscure: true),
            
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.cyanAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
                onPressed: isLoading ? null : _submit,
                child: isLoading ? const CircularProgressIndicator(color: Colors.black) : Text(isLogin ? "AUTHORIZE" : "INITIALIZE", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
            
            Center(
              child: TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin ? "New Explorer? Create Account" : "Existing User? Sign In", style: const TextStyle(color: Colors.white54)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController ctrl, String hint, IconData icon, {bool obscure = false}) {
    return TextField(
      controller: ctrl,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.cyanAccent, size: 20),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }
}