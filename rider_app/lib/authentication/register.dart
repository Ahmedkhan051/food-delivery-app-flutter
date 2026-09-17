import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:rider_app/global/global.dart';
import 'package:rider_app/mainScreens/home_screen.dart';
import 'package:rider_app/widgets/custom_text_field.dart';
import 'package:rider_app/widgets/error_dialog.dart';
import 'package:rider_app/widgets/loading_dialog.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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

  final TextEditingController phoneController =
  TextEditingController();

  final TextEditingController locationController =
  TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // ---------------------------------------------------------
  // GEOCODING
  // ---------------------------------------------------------

  final Geocoding _geocoding =
  Geocoding();

  XFile? imageXFile;

  Position? position;

  List<Placemark>? placeMarks;

  String riderImageUrl = "";

  String completeAddress = "";

  // ---------------------------------------------------------
  // PICK PROFILE IMAGE
  // ---------------------------------------------------------

  Future<void> _getImage() async {
    try {
      final XFile? pickedImage =
      await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 75,
      );

      if (pickedImage == null ||
          !mounted) {
        return;
      }

      setState(() {
        imageXFile = pickedImage;
      });
    } catch (error) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => ErrorDialog(
          message:
          "Unable to select image: $error",
        ),
      );
    }
  }

  // ---------------------------------------------------------
  // GET CURRENT LOCATION
  // ---------------------------------------------------------

  Future<void> getCurrentLocation() async {
    try {
      // -------------------------------------------------------
      // CHECK LOCATION SERVICE
      // -------------------------------------------------------

      final bool serviceEnabled =
      await Geolocator
          .isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) =>
          const ErrorDialog(
            message:
            "Please enable location services.",
          ),
        );

        return;
      }

      // -------------------------------------------------------
      // CHECK PERMISSION
      // -------------------------------------------------------

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
        await Geolocator
            .requestPermission();
      }

      if (permission ==
          LocationPermission.denied) {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) =>
          const ErrorDialog(
            message:
            "Location permission is required.",
          ),
        );

        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) =>
          const ErrorDialog(
            message:
            "Location permission is permanently denied. "
                "Please enable it from app settings.",
          ),
        );

        return;
      }

      // -------------------------------------------------------
      // GET CURRENT POSITION
      // -------------------------------------------------------
      //
      // Geolocator 14 uses LocationSettings instead of
      // the deprecated desiredAccuracy parameter.
      //

      const LocationSettings locationSettings =
      LocationSettings(
        accuracy:
        LocationAccuracy.high,
      );

      final Position newPosition =
      await Geolocator
          .getCurrentPosition(
        locationSettings:
        locationSettings,
      );

      position = newPosition;

      // -------------------------------------------------------
      // REVERSE GEOCODING
      // -------------------------------------------------------

      placeMarks =
      await _geocoding
          .placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      // -------------------------------------------------------
      // BUILD ADDRESS
      // -------------------------------------------------------

      if (placeMarks != null &&
          placeMarks!.isNotEmpty) {
        final Placemark pMarks =
            placeMarks!.first;

        completeAddress = [
          pMarks.subThoroughfare,
          pMarks.thoroughfare,
          pMarks.subLocality,
          pMarks.locality,
          pMarks.subAdministrativeArea,
          pMarks.administrativeArea,
          pMarks.postalCode,
          pMarks.country,
        ]
            .where(
              (value) =>
          value != null &&
              value.trim().isNotEmpty,
        )
            .map(
              (value) => value!.trim(),
        )
            .join(", ");
      } else {
        completeAddress =
        "${position!.latitude}, "
            "${position!.longitude}";
      }

      // -------------------------------------------------------
      // SHOW ADDRESS IN FIELD
      // -------------------------------------------------------

      if (!mounted) return;

      setState(() {
        locationController.text =
            completeAddress;
      });
    } catch (_) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) =>
        const ErrorDialog(
          message:
          "Unable to get current location.",
        ),
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
    passwordController.text.trim();

    final String confirmPassword =
    confirmePasswordController
        .text
        .trim();

    final String phone =
    phoneController.text.trim();

    final String location =
    locationController.text.trim();

    // -------------------------------------------------------
    // REQUIRED FIELDS
    // -------------------------------------------------------

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        phone.isEmpty ||
        location.isEmpty) {
      showDialog(
        context: context,
        builder: (_) =>
        const ErrorDialog(
          message:
          "Please enter all required information.",
        ),
      );

      return;
    }

    // -------------------------------------------------------
    // PASSWORD LENGTH
    // -------------------------------------------------------

    if (password.length < 6) {
      showDialog(
        context: context,
        builder: (_) =>
        const ErrorDialog(
          message:
          "Password must contain at least 6 characters.",
        ),
      );

      return;
    }

    // -------------------------------------------------------
    // PASSWORD MATCH
    // -------------------------------------------------------

    if (password !=
        confirmPassword) {
      showDialog(
        context: context,
        builder: (_) =>
        const ErrorDialog(
          message:
          "Passwords do not match.",
        ),
      );

      return;
    }

    // -------------------------------------------------------
    // LOCATION REQUIRED
    // -------------------------------------------------------

    if (position == null) {
      showDialog(
        context: context,
        builder: (_) =>
        const ErrorDialog(
          message:
          "Please get your current location first.",
        ),
      );

      return;
    }

    // -------------------------------------------------------
    // SHOW LOADING
    // -------------------------------------------------------

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) =>
      const LoadingDialog(
        message:
        "Registering Account...",
      ),
    );

    await authenticateRiderAndSignUp();
  }

  // ---------------------------------------------------------
  // CREATE RIDER ACCOUNT
  // ---------------------------------------------------------

  Future<void>
  authenticateRiderAndSignUp() async {
    try {
      final UserCredential authResult =
      await firebaseAuth
          .createUserWithEmailAndPassword(
        email:
        emailController.text.trim(),
        password:
        passwordController.text.trim(),
      );

      final User? currentUser =
          authResult.user;

      if (currentUser == null) {
        if (mounted) {
          Navigator.pop(context);
        }

        if (!mounted) return;

        showDialog(
          context: context,
          builder: (_) =>
          const ErrorDialog(
            message:
            "Unable to create rider account.",
          ),
        );

        return;
      }

      // -------------------------------------------------------
      // DISPLAY NAME
      // -------------------------------------------------------

      await currentUser
          .updateDisplayName(
        nameController.text.trim(),
      );

      // -------------------------------------------------------
      // SAVE RIDER DATA
      // -------------------------------------------------------

      await saveDataToFireStore(
        currentUser,
      );

      if (!mounted) return;

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
          const HomeScreen(),
        ),
      );
    } on FirebaseAuthException catch (
    error) {
      if (mounted) {
        Navigator.pop(context);
      }

      String message;

      switch (error.code) {
        case "email-already-in-use":
          message =
          "An account already exists with this email.";
          break;

        case "invalid-email":
          message =
          "Please enter a valid email address.";
          break;

        case "weak-password":
          message =
          "Please use a stronger password.";
          break;

        default:
          message =
              error.message ??
                  "Registration failed.";
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) =>
            ErrorDialog(
              message: message,
            ),
      );
    } catch (_) {
      if (mounted) {
        Navigator.pop(context);
      }

      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) =>
        const ErrorDialog(
          message:
          "Unable to complete registration. "
              "Please try again.",
        ),
      );
    }
  }

  // ---------------------------------------------------------
  // SAVE RIDER DATA TO FIRESTORE
  // ---------------------------------------------------------

  Future<void> saveDataToFireStore(
      User currentUser,
      ) async {
    final String riderName =
    nameController.text.trim();

    final String riderEmail =
        currentUser.email ??
            emailController.text.trim();

    final String riderPhone =
    phoneController.text.trim();

    // -------------------------------------------------------
    // RIDER DOCUMENT
    // -------------------------------------------------------

    await FirebaseFirestore.instance
        .collection("riders")
        .doc(currentUser.uid)
        .set(
      {
        "riderUID":
        currentUser.uid,

        "riderEmail":
        riderEmail,

        "riderName":
        riderName,

        // Profile picture remains optional.
        "riderAvtar":
        riderImageUrl,

        "phone":
        riderPhone,

        "address":
        completeAddress.isNotEmpty
            ? completeAddress
            : locationController.text
            .trim(),

        "status":
        "Approved",

        "lat":
        position!.latitude,

        "lng":
        position!.longitude,

        // Initial rider location object.
        "location": {
          "lat":
          position!.latitude,
          "lng":
          position!.longitude,
        },

        // No active delivery immediately after registration.
        "activeOrderId":
        "",

        "activeOrderStatus":
        "Available",

        "locationUpdatedAt":
        FieldValue.serverTimestamp(),

        "createdAt":
        FieldValue.serverTimestamp(),

        "updatedAt":
        FieldValue.serverTimestamp(),
      },
    );

    // -------------------------------------------------------
    // SHARED PREFERENCES
    // -------------------------------------------------------

    sharedPreferences ??=
    await SharedPreferences
        .getInstance();

    await sharedPreferences!
        .setString(
      "uid",
      currentUser.uid,
    );

    await sharedPreferences!
        .setString(
      "email",
      riderEmail,
    );

    await sharedPreferences!
        .setString(
      "name",
      riderName,
    );

    await sharedPreferences!
        .setString(
      "PhotoUrl",
      riderImageUrl,
    );
  }

  // ---------------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------------

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmePasswordController
        .dispose();
    phoneController.dispose();
    locationController.dispose();
    emailController.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------

  @override
  Widget build(
      BuildContext context,
      ) {
    final double screenWidth =
        MediaQuery.of(context)
            .size
            .width;

    return SingleChildScrollView(
      child: Column(
        children: [

          const SizedBox(height: 15),

          // =================================================
          // PROFILE PHOTO
          // =================================================

          InkWell(
            onTap: _getImage,
            borderRadius:
            BorderRadius.circular(
              100,
            ),
            child: CircleAvatar(
              radius:
              screenWidth * 0.20,

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
                  ? Icon(
                Icons
                    .add_a_photo_outlined,
                size:
                screenWidth *
                    0.18,
                color:
                Colors.grey,
              )
                  : null,
            ),
          ),

          const SizedBox(height: 15),

          // =================================================
          // FORM
          // =================================================

          Form(
            key: _formKey,
            child: Column(
              children: [

                CustomTextField(
                  data:
                  Icons.person_outline,
                  controller:
                  nameController,
                  hintText:
                  "Name",
                  isObsecre:
                  false,
                ),

                CustomTextField(
                  data:
                  Icons.email_outlined,
                  controller:
                  emailController,
                  hintText:
                  "Email",
                  isObsecre:
                  false,
                ),

                CustomTextField(
                  data:
                  Icons.lock_outline,
                  controller:
                  passwordController,
                  hintText:
                  "Password",
                  isObsecre:
                  true,
                ),

                CustomTextField(
                  data:
                  Icons.lock_outline,
                  controller:
                  confirmePasswordController,
                  hintText:
                  "Confirm Password",
                  isObsecre:
                  true,
                ),

                CustomTextField(
                  data:
                  Icons.phone_outlined,
                  controller:
                  phoneController,
                  hintText:
                  "Phone",
                  isObsecre:
                  false,
                ),

                CustomTextField(
                  data:
                  Icons.location_on_outlined,
                  controller:
                  locationController,
                  hintText:
                  "My Current Location",
                  isObsecre:
                  false,
                  enabled:
                  true,
                ),

                const SizedBox(
                  height: 10,
                ),

                SizedBox(
                  width: 400,
                  height: 52,
                  child:
                  ElevatedButton.icon(
                    onPressed:
                    getCurrentLocation,

                    icon:
                    const Icon(
                      Icons.my_location,
                      color:
                      Colors.white,
                    ),

                    label:
                    const Text(
                      "Get My Current Location",
                      style:
                      TextStyle(
                        color:
                        Colors.white,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    style:
                    ElevatedButton
                        .styleFrom(
                      backgroundColor:
                      const Color(
                        0xFF42A5F5,
                      ),
                      foregroundColor:
                      Colors.white,
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius
                            .circular(
                          30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // =================================================
          // SIGN UP
          // =================================================

          ElevatedButton(
            onPressed:
            formValidation,

            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              const Color(
                0xFF1565C0,
              ),
              foregroundColor:
              Colors.white,
              padding:
              const EdgeInsets.symmetric(
                horizontal: 55,
                vertical: 18,
              ),
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                  12,
                ),
              ),
            ),

            child:
            const Text(
              "Sign Up",
              style:
              TextStyle(
                color:
                Colors.white,
                fontWeight:
                FontWeight.bold,
                fontSize: 17,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}