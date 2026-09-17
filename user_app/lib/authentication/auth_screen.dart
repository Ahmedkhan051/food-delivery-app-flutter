import 'package:flutter/material.dart';
import 'package:user_app/authentication/login.dart';
import 'package:user_app/authentication/register.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
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
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            'FoodHub',
            style: TextStyle(
              fontSize: 50,
              color: Colors.white,
              fontFamily: "Train",
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.login,
                  color: Colors.white,
                ),
                text: 'Login',
              ),
              Tab(
                icon: Icon(
                  Icons.person_add,
                  color: Colors.white,
                ),
                text: 'Register',
              ),
            ],
            indicatorColor: Colors.white,
            indicatorWeight: 4,
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFB3E5FC),
                Color(0xFFE3F2FD),
              ],
            ),
          ),
          child: const TabBarView(
            children: [
              LoginScreen(),
              RegisterScreen(),
            ],
          ),
        ),
      ),
    );
  }
}