import 'dart:async';

import 'package:flutter/material.dart';

import '../authentication/auth_screen.dart';
import '../global/global.dart';
import '../mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  Timer? _timer;

  // ---------------------------------------------------------
  // START SPLASH TIMER
  // ---------------------------------------------------------

  void startTimer() {
    _timer = Timer(
      const Duration(seconds: 2),
          () {
        if (!mounted) return;

        final Widget nextScreen =
        firebaseAuth.currentUser != null
            ? const HomeScreen()
            : const AuthScreen();

        // IMPORTANT:
        // Replace splash instead of pushing another route.
        // This prevents the splash screen from appearing
        // when the user presses the Back button.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => nextScreen,
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------
  // INIT
  // ---------------------------------------------------------

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  // ---------------------------------------------------------
  // DISPOSE TIMER
  // ---------------------------------------------------------

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 180,
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'FoodHub',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontSize: 46,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Rider Delivery App',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Fast, Reliable & Secure Food Delivery',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 35),

                  const CircularProgressIndicator(
                    color: Color(0xFF1565C0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}