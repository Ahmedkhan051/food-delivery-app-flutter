import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_app/widgets/custom_text_field.dart';
import 'package:user_app/widgets/error_Dialog.dart';
import 'package:user_app/widgets/loading_dialog.dart';
import 'package:user_app/mainScreens/home_screen.dart';

import '../global/global.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey =
  GlobalKey<FormState>();

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  final TextEditingController passwordController =
  TextEditingController();

  final TextEditingController
  confirmePasswordController =
  TextEditingController();

  XFile? imageXFile;

  final ImagePicker _picker = ImagePicker();

  // ---------------------------------------------------------
  // SELECT PROFILE IMAGE
  // ---------------------------------------------------------

  Future<void> _getImage() async {
    try {
      final XFile? selectedImage =
      await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (selectedImage != null) {
        if (!mounted) return;

        setState(() {
          imageXFile = selectedImage;
        });
      }
    } catch (error) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message:
            "Unable to select image: $error",
          );
        },
      );
    }
  }

  // ---------------------------------------------------------
  // FORM VALIDATION
  // ---------------------------------------------------------

  Future<void> formValidation() async {
    final String name =
    nameController.text.trim();

    final String email =
    emailController.text.trim();

    final String password =
        passwordController.text;

    final String confirmPassword =
        confirmePasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Please enter all required information.",
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
            message:
            "Please enter a valid email address.",
          );
        },
      );

      return;
    }

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Passwords do not match.",
          );
        },
      );

      return;
    }

    if (password.length < 6) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Password must contain at least 6 characters.",
          );
        },
      );

      return;
    }

    await registerLocally();
  }

  // ---------------------------------------------------------
  // CREATE FOODHUB ACCOUNT
  // ---------------------------------------------------------

  Future<void> registerLocally() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog(
          message:
          "Creating FoodHub Account...",
        );
      },
    );

    try {
      final SharedPreferences prefs =
      await SharedPreferences.getInstance();

      // -----------------------------------------------------
      // KEEP THE EXISTING FOODHUB USER ID SYSTEM
      // -----------------------------------------------------

      final String localUid =
      DateTime.now()
          .millisecondsSinceEpoch
          .toString();

      // -----------------------------------------------------
      // SAVE LOCAL USER DATA
      // -----------------------------------------------------

      await prefs.setString(
        "uid",
        localUid,
      );

      await prefs.setString(
        "email",
        emailController.text
            .trim()
            .toLowerCase(),
      );

      await prefs.setString(
        "password",
        passwordController.text,
      );

      await prefs.setString(
        "name",
        nameController.text.trim(),
      );

      await prefs.setString(
        "photo",
        imageXFile != null
            ? imageXFile!.path
            : "",
      );

      await prefs.setStringList(
        "userCart",
        ['garbageValue'],
      );

      await prefs.setBool(
        "isDemoUser",
        true,
      );

      await prefs.setBool(
        "isLoggedIn",
        true,
      );

      // -----------------------------------------------------
      // UPDATE GLOBAL SHARED PREFERENCES
      // -----------------------------------------------------

      sharedPreferences = prefs;

      // -----------------------------------------------------
      // CREATE USER DOCUMENT IN FIRESTORE
      // -----------------------------------------------------
      //
      // This is the important addition for the Admin Portal.
      //
      // The same localUid is used as the Firestore document ID
      // so the existing User App order system continues to use
      // the same user identity.
      //
      // Admin Verified Users looks for:
      //
      // users/{uid}
      // status = "Approved"
      //
      // -----------------------------------------------------

      await FirebaseFirestore.instance
          .collection("users")
          .doc(localUid)
          .set(
        {
          "uid": localUid,

          "name":
          nameController.text.trim(),

          "email":
          emailController.text
              .trim()
              .toLowerCase(),

          "photo":
          imageXFile != null
              ? imageXFile!.path
              : "",

          "status": "Approved",

          "createdAt":
          FieldValue.serverTimestamp(),

          "updatedAt":
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      // -----------------------------------------------------
      // CLOSE LOADING DIALOG
      // -----------------------------------------------------

      if (!mounted) return;

      Navigator.pop(context);

      // -----------------------------------------------------
      // SUCCESS MESSAGE
      // -----------------------------------------------------

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "FoodHub account created successfully!",
          ),
          duration:
          Duration(seconds: 2),
        ),
      );

      // -----------------------------------------------------
      // OPEN HOME SCREEN
      // -----------------------------------------------------

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
          const HomeScreen(),
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
            message:
            "Registration failed: $error",
          );
        },
      );
    }
  }

  // ---------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmePasswordController.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          15,
          12,
          15,
          30,
        ),
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),

            // -------------------------------------------------
            // PROFILE PHOTO
            // -------------------------------------------------

            InkWell(
              onTap: _getImage,
              borderRadius:
              BorderRadius.circular(100),

              child: CircleAvatar(
                radius: 72,
                backgroundColor:
                Colors.white,

                backgroundImage:
                imageXFile == null
                    ? null
                    : FileImage(
                  File(
                    imageXFile!.path,
                  ),
                ),

                child:
                imageXFile == null
                    ? const Icon(
                  Icons.add_a_photo,
                  size: 48,
                  color:
                  Color(0xFF42A5F5),
                )
                    : null,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              "Add Profile Photo (Optional)",
              style: TextStyle(
                color:
                Color(0xFF0D47A1),
                fontSize: 14,
                fontWeight:
                FontWeight.w500,
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // -------------------------------------------------
            // FORM
            // -------------------------------------------------

            Form(
              key: _formKey,

              child: Column(
                children: [
                  _buildField(
                    icon:
                    Icons.person_outline,
                    controller:
                    nameController,
                    hintText:
                    "Name",
                    obscureText:
                    false,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  _buildField(
                    icon:
                    Icons.email_outlined,
                    controller:
                    emailController,
                    hintText:
                    "Email",
                    obscureText:
                    false,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  _buildField(
                    icon:
                    Icons.lock_outline,
                    controller:
                    passwordController,
                    hintText:
                    "Password",
                    obscureText:
                    true,
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  _buildField(
                    icon:
                    Icons.lock_outline,
                    controller:
                    confirmePasswordController,
                    hintText:
                    "Confirm Password",
                    obscureText:
                    true,
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 25,
            ),

            // -------------------------------------------------
            // CREATE ACCOUNT BUTTON
            // -------------------------------------------------

            SizedBox(
              width:
              double.infinity,
              height: 55,

              child:
              ElevatedButton(
                onPressed:
                formValidation,

                style:
                ElevatedButton.styleFrom(
                  backgroundColor:
                  const Color(
                    0xFF1976D2,
                  ),

                  foregroundColor:
                  Colors.white,

                  elevation: 5,

                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      15,
                    ),
                  ),
                ),

                child:
                const Text(
                  "CREATE ACCOUNT",
                  style: TextStyle(
                    color:
                    Colors.white,
                    fontSize: 16,
                    fontWeight:
                    FontWeight.bold,
                    letterSpacing:
                    0.8,
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 15,
            ),

            const Text(
              "Create your FoodHub account and start ordering delicious food.",
              textAlign:
              TextAlign.center,

              style: TextStyle(
                color:
                Color(0xFF546E7A),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // CUSTOM TEXT FIELD
  // ---------------------------------------------------------

  Widget _buildField({
    required IconData icon,
    required TextEditingController
    controller,
    required String hintText,
    required bool obscureText,
  }) {
    return Container(
      decoration:
      BoxDecoration(
        color:
        Colors.white,

        borderRadius:
        BorderRadius.circular(
          15,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(
              0.08,
            ),
            blurRadius: 8,
            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      child:
      CustomTextField(
        data: icon,
        controller:
        controller,
        hintText:
        hintText,
        isObsecre:
        obscureText,
      ),
    );
  }
}