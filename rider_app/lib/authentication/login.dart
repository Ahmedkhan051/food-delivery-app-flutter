import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rider_app/widgets/error_dialog.dart';
import '../mainScreens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  // ---------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------

  Future<void> allowAdminToLogin() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showMessage("Please enter your email and password.");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final UserCredential authResult =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? currentUser = authResult.user;

      if (currentUser == null) {
        _showMessage("Unable to login.");
        return;
      }

      // -----------------------------------------------------
      // VERIFY RIDER RECORD
      // -----------------------------------------------------

      final DocumentSnapshot<Map<String, dynamic>> riderSnapshot =
      await FirebaseFirestore.instance
          .collection("riders")
          .doc(currentUser.uid)
          .get();

      if (!riderSnapshot.exists) {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => const ErrorDialog(
            message: "Rider account record not found.",
          ),
        );

        return;
      }

      final Map<String, dynamic> riderData =
          riderSnapshot.data() ?? {};

      final String status =
          riderData["status"]?.toString() ?? "";

      if (status.toLowerCase() == "blocked") {
        await FirebaseAuth.instance.signOut();

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) => const ErrorDialog(
            message:
            "Your rider account has been blocked. "
                "Please contact the administrator.",
          ),
        );

        return;
      }

      if (!mounted) return;

      // -----------------------------------------------------
      // OPEN RIDER DASHBOARD
      // -----------------------------------------------------

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
            (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      String message;

      switch (error.code) {
        case "user-not-found":
          message =
          "No rider account found with this email.";
          break;

        case "wrong-password":
        case "invalid-credential":
          message =
          "Incorrect email or password.";
          break;

        case "invalid-email":
          message =
          "Please enter a valid email address.";
          break;

        case "user-disabled":
          message =
          "This rider account has been disabled.";
          break;

        case "too-many-requests":
          message =
          "Too many login attempts. Please try again later.";
          break;

        default:
          message =
              error.message ?? "Login failed.";
      }

      _showMessage(message);
    } catch (_) {
      _showMessage(
        "Unable to login. Please try again.",
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // ---------------------------------------------------------
  // MESSAGE
  // ---------------------------------------------------------

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF1565C0),
      ),
    );
  }

  // ---------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
            ),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    // -------------------------------------------------
                    // RIDER IMAGE
                    // -------------------------------------------------

                    Image.asset(
                      'assets/images/rider.png',
                      height: 180,
                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return const Icon(
                          Icons.delivery_dining,
                          size: 150,
                          color: Color(0xFF1565C0),
                        );
                      },
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      "FoodHub Rider",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      "Rider Login",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // -------------------------------------------------
                    // EMAIL
                    // -------------------------------------------------

                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(
                          Icons.email_outlined,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder:
                        const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1565C0),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // -------------------------------------------------
                    // PASSWORD
                    // -------------------------------------------------

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword =
                              !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder:
                        const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color(0xFF1565C0),
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // -------------------------------------------------
                    // LOGIN BUTTON
                    // -------------------------------------------------

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : allowAdminToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child:
                          CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}