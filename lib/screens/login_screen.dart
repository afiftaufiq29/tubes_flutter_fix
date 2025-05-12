import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tubes_flutter/screens/home_screen.dart';
import 'package:tubes_flutter/screens/register_screen.dart';
import 'package:lottie/lottie.dart'; // Add this import

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  bool _showLoginForm = false;
  bool _showTitle = false;
  bool _exitToLeft = false;

  @override
  void initState() {
    super.initState();
    // Pastikan semua animasi dimulai dengan benar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _showTitle = true);
      });
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _showLoginForm = true);
      });
    });
  }

  Future<void> _login(BuildContext context) async {
    setState(() => _isLoading = true);

    final phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan nomor HP')),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    if (phoneNumber == '+628123456789') {
      // Save user data
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'user_data',
          json.encode({
            'name': 'John Doe',
            'email': 'user@example.com',
            'phone': phoneNumber,
            'joinDate': DateTime.now().toString(),
          }));

      setState(() => _exitToLeft = true);
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nomor HP tidak terdaftar')),
      );
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background color fallback jika gambar tidak ada
          Container(color: Colors.orange[100]),

          // Background image dengan error handling yang lebih baik
          Positioned.fill(
            child: Image.asset(
              'assets/images/background_images/bg_login.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.orange[200],
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey[600],
                    ),
                  ),
                );
              },
            ),
          ),

          // Blur effect
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Container(color: Colors.black.withOpacity(0.3)),
          ),

          // Konten utama
          SafeArea(
            child: AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              left: _exitToLeft ? -MediaQuery.of(context).size.width : 0,
              right: _exitToLeft ? MediaQuery.of(context).size.width : 0,
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  AnimatedOpacity(
                    opacity: _showTitle ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    child: Transform(
                      transform:
                          Matrix4.translationValues(0, _showTitle ? 0 : 20, 0),
                      child: const Text(
                        'MASAKAN NUSANTARA',
                        style: TextStyle(
                          fontSize: 28, // Diperbesar
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.black45,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.5),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: animation,
                          curve: Curves.easeOutQuart,
                        )),
                        child: FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                      );
                    },
                    child: _showLoginForm
                        ? _buildLoginForm(context)
                        : const SizedBox(key: ValueKey('empty')),
                  ),
                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),

          // Loading overlay with Lottie animation
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        key: const ValueKey('loginForm'),
        padding: const EdgeInsets.all(24.0), // Padding diperbesar
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9), // Opacity ditingkatkan
          borderRadius: BorderRadius.circular(20), // Border radius diperbesar
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25), // Shadow lebih terlihat
              blurRadius: 25,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor HP',
                hintText: 'Contoh: +628123456789',
                prefixIcon: const Icon(Icons.phone, color: Colors.orange),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[400]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.orange[400]!, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : () => _login(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[600], // Warna lebih cerah
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 8, // Elevation ditingkatkan
                  shadowColor: Colors.orange.withOpacity(0.6),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      ),
              child: RichText(
                text: TextSpan(
                  text: 'Belum punya akun? ',
                  style: TextStyle(color: Colors.grey[700]),
                  children: const [
                    TextSpan(
                      text: 'Daftar',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Stack(
      children: [
        // Blur effect behind the loading
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),

        // Center the loading animation
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/loading_hand.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              const Text(
                'Kalem aa',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 5,
                      color: Colors.black45,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }
}
