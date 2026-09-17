import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:user_app/mainScreens/home_screen.dart';
import 'package:user_app/widgets/custom_text_field.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';

import '../global/global.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  Future<void> formValidation() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message: "Please enter your email and password.",
          );
        },
      );
      return;
    }

    if (!email.contains("@")) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message: "Please enter a valid email address.",
          );
        },
      );
      return;
    }

    await loginLocally();
  }

  Future<void> loginLocally() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog(
          message: "Checking credentials...",
        );
      },
    );

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      final String enteredEmail =
      emailController.text.trim().toLowerCase();

      final String enteredPassword =
          passwordController.text;

      final String savedEmail =
          prefs.getString("email")?.trim().toLowerCase() ?? "";

      final String savedPassword =
          prefs.getString("password") ?? "";

      final String savedUid =
          prefs.getString("uid") ?? "";

      final bool isDemoUser =
          prefs.getBool("isDemoUser") ?? false;

      if (!mounted) return;

      if (!isDemoUser ||
          savedEmail.isEmpty ||
          savedPassword.isEmpty ||
          savedUid.isEmpty) {
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message:
              "No FoodHub account found. Please register first.",
            );
          },
        );
        return;
      }

      if (enteredEmail != savedEmail ||
          enteredPassword != savedPassword) {
        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Invalid email or password.",
            );
          },
        );
        return;
      }

      // ---------------------------------------------------------
      // LOCAL LOGIN SUCCESSFUL
      // ---------------------------------------------------------

      await prefs.setBool(
        "isLoggedIn",
        true,
      );

      sharedPreferences = prefs;

      // ---------------------------------------------------------
      // FIRESTORE USER SYNC
      //
      // This keeps older local users connected to Firebase
      // without changing the existing local login system.
      // The same UID from SharedPreferences is used.
      // ---------------------------------------------------------

      try {
        final DocumentReference userRef =
        FirebaseFirestore.instance
            .collection("users")
            .doc(savedUid);

        final DocumentSnapshot userSnapshot =
        await userRef.get();

        if (!userSnapshot.exists) {
          await userRef.set({
            "uid": savedUid,
            "name": prefs.getString("name") ?? "",
            "email": savedEmail,
            "photo": prefs.getString("photo") ?? "",
            "status": "Approved",
            "createdAt": FieldValue.serverTimestamp(),
            "updatedAt": FieldValue.serverTimestamp(),
          });
        } else {
          await userRef.set({
            "uid": savedUid,
            "name": prefs.getString("name") ?? "",
            "email": savedEmail,
            "photo": prefs.getString("photo") ?? "",
            "status": "Approved",
            "updatedAt": FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      } catch (firestoreError) {
        // Keep the existing local login working even if
        // Firestore is temporarily unavailable.
        debugPrint(
          "Firestore user sync failed: $firestoreError",
        );
      }

      // Close loading dialog.
      if (!mounted) return;

      Navigator.pop(context);

      // ---------------------------------------------------------
      // GO TO HOME SCREEN
      // ---------------------------------------------------------

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
            (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message: "Login failed: ${error.toString()}",
          );
        },
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          20,
          10,
          20,
          30,
        ),
        child: Column(
          children: [
            const SizedBox(height: 5),

            Container(
              height: 230,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueGrey.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/login.png',
                  height: 210,
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Welcome Back!",
                style: TextStyle(
                  color: Color(0xFF0D47A1),
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 5),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Login to order your favorite food",
                style: TextStyle(
                  color: Color(0xFF455A64),
                  fontSize: 15,
                ),
              ),
            ),

            const SizedBox(height: 22),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CustomTextField(
                      data: Icons.email_outlined,
                      controller: emailController,
                      hintText: 'Email',
                      isObsecre: false,
                    ),
                  ),

                  const SizedBox(height: 15),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: CustomTextField(
                      data: Icons.lock_outline,
                      controller: passwordController,
                      hintText: 'Password',
                      isObsecre: true,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: formValidation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Order delicious food from your favorite restaurants",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF546E7A),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}