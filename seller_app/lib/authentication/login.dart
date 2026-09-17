import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:seller_app/authentication/auth_screen.dart';
import 'package:seller_app/global/global.dart';
import 'package:seller_app/widgets/error_Dialog.dart';
import 'package:seller_app/widgets/loading_dialog.dart';

import '../mainScreens/home_screen.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void formValidation() {
    if (emailController.text.trim().isNotEmpty &&
        passwordController.text.isNotEmpty) {
      loginNow();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message: "Please enter email and password.",
          );
        },
      );
    }
  }

  Future<void> loginNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog(
          message: "Checking Credentials",
        );
      },
    );

    try {
      final UserCredential auth =
      await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final User? currentUser = auth.user;

      if (currentUser == null) {
        if (!mounted) return;

        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Unable to sign in.",
            );
          },
        );

        return;
      }

      await readDataAndSetDataLocally(currentUser);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;

      Navigator.pop(context);

      String message = "Login failed.";

      if (error.code == "user-not-found") {
        message = "No account found for this email.";
      } else if (error.code == "wrong-password" ||
          error.code == "invalid-credential") {
        message = "Incorrect email or password.";
      } else if (error.code == "invalid-email") {
        message = "Please enter a valid email address.";
      } else if (error.code == "user-disabled") {
        message = "This account has been disabled.";
      } else if (error.message != null &&
          error.message!.trim().isNotEmpty) {
        message = error.message!;
      }

      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message: message,
          );
        },
      );
    } catch (error) {
      if (!mounted) return;

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message: error.toString(),
          );
        },
      );
    }
  }

  Future<void> readDataAndSetDataLocally(User currentUser) async {
    try {
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("sellers")
          .doc(currentUser.uid)
          .get();

      if (!snapshot.exists) {
        await firebaseAuth.signOut();

        if (!mounted) return;

        Navigator.pop(context);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthScreen(),
          ),
        );

        await Future.delayed(const Duration(milliseconds: 150));

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "No seller record found.",
            );
          },
        );

        return;
      }

      final dynamic rawData = snapshot.data();

      if (rawData is! Map<String, dynamic>) {
        await firebaseAuth.signOut();

        if (!mounted) return;

        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Invalid seller information.",
            );
          },
        );

        return;
      }

      final Map<String, dynamic> sellerData = rawData;

      final String status =
          sellerData["status"]?.toString() ?? "";

      if (status != "Approved") {
        await firebaseAuth.signOut();

        if (!mounted) return;

        Navigator.pop(context);

        Fluttertoast.showToast(
          msg:
          "Admin has blocked your account\n\nMail to: admin@gmail.com",
        );

        return;
      }

      final String sellerName =
          sellerData["sellerName"]?.toString().trim() ??
              "";

      final String sellerEmail =
      sellerData["sellerEmail"]?.toString().trim().isNotEmpty == true
          ? sellerData["sellerEmail"].toString().trim()
          : currentUser.email ?? "";

      final String sellerAvatar =
          sellerData["sellerAvtar"]?.toString().trim() ?? "";

      final String uid = currentUser.uid;

      if (sharedPreferences == null) {
        if (!mounted) return;

        Navigator.pop(context);

        showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Local storage is unavailable.",
            );
          },
        );

        return;
      }

      await sharedPreferences!.setString("uid", uid);
      await sharedPreferences!.setString("email", sellerEmail);
      await sharedPreferences!.setString("name", sellerName);
      await sharedPreferences!.setString(
        "PhotoUrl",
        sellerAvatar,
      );

      if (!mounted) return;

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message: error.toString(),
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
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Image.asset(
                "assets/images/seller.png",
                height: 270,
              ),
            ),
          ),

          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: "Email",
                  isObsecre: false,
                ),
                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecre: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: formValidation,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF42A5F5),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 50,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Login",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}