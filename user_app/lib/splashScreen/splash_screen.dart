import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_app/authentication/auth_screen.dart';
import 'package:user_app/global/global.dart';
import 'package:user_app/mainScreens/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  Timer? _timer;

  Future<void> startTimer() async {
    _timer = Timer(
      const Duration(seconds: 2),
          () async {
        if (!mounted) return;

        final SharedPreferences prefs =
        await SharedPreferences.getInstance();

        final bool isDemoUser =
            prefs.getBool("isDemoUser") ?? false;

        final bool isLoggedIn =
            prefs.getBool("isLoggedIn") ?? false;

        final bool userIsLoggedIn =
            firebaseAuth.currentUser != null ||
                (isDemoUser && isLoggedIn);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => userIsLoggedIn
                ? const HomeScreen()
                : const AuthScreen(),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF90CAF9),
              Color(0xFF42A5F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/images/welcome.png',
                    errorBuilder: (
                        context,
                        error,
                        stackTrace,
                        ) {
                      return const Icon(
                        Icons.fastfood,
                        size: 120,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        'Order Food Online With FoodHub',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Train",
                          letterSpacing: 3,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Delicious Food Delivered To Your Door",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: "Signatra",
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}