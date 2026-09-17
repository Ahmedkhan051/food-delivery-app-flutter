import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:seller_app/global/global.dart';
import 'package:seller_app/widgets/custom_text_field.dart';
import 'package:seller_app/widgets/error_Dialog.dart';
import 'package:seller_app/widgets/loading_dialog.dart';
import '../mainScreens/home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmePasswordController =
  TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  XFile? imageXFile;

  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;

  String sellerImageUrl = "";
  String completeAddress = "";

  static const Color darkBlue = Color(0xFF1565C0);
  static const Color mediumBlue = Color(0xFF42A5F5);
  static const Color lightBlue = Color(0xFF90CAF9);

  Future<void> _getImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (selectedImage == null) {
      return;
    }

    if (!mounted) {
      return;
    }

    setState(() {
      imageXFile = selectedImage;
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        showDialog(
          context: context,
          builder: (context) {
            return const ErrorDialog(
              message: "Location permission is required.",
            );
          },
        );

        return;
      }

      final Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      position = newPosition;

      placeMarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      if (placeMarks == null || placeMarks!.isEmpty) {
        return;
      }

      final Placemark pMarks = placeMarks![0];

      completeAddress =
      '${pMarks.subThoroughfare} '
          '${pMarks.thoroughfare}, '
          '${pMarks.subLocality} '
          '${pMarks.locality}, '
          '${pMarks.subAdministrativeArea}, '
          '${pMarks.administrativeArea} '
          '${pMarks.postalCode}, '
          '${pMarks.country}';

      if (!mounted) {
        return;
      }

      locationController.text = completeAddress;

      setState(() {});
    } catch (error) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message: "Unable to get location: $error",
          );
        },
      );
    }
  }

  Future<void> formValidation() async {
    // Profile image is optional.

    if (passwordController.text != confirmePasswordController.text) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message: "Password don't match",
          );
        },
      );

      return;
    }

    if (confirmePasswordController.text.isEmpty ||
        nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        locationController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message: "Please Enter Required info for registration",
          );
        },
      );

      return;
    }

    if (position == null) {
      showDialog(
        context: context,
        builder: (context) {
          return const ErrorDialog(
            message:
            "Please get your current location before registering.",
          );
        },
      );

      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const LoadingDialog(
          message: "Registering Account...",
        );
      },
    );

    try {
      // Upload seller image only when the user selected one.
      if (imageXFile != null) {
        final String fileName =
        DateTime.now().millisecondsSinceEpoch.toString();

        final fStorage.Reference reference =
        fStorage.FirebaseStorage.instance
            .ref()
            .child('sellers')
            .child(fileName);

        final fStorage.UploadTask uploadTask = reference.putFile(
          File(imageXFile!.path),
        );

        final fStorage.TaskSnapshot taskSnapshot =
        await uploadTask.whenComplete(() {});

        sellerImageUrl =
        await taskSnapshot.ref.getDownloadURL();
      }

      await authenticateSellerAndSignUp();
    } catch (error) {
      if (!mounted) return;

      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (context) {
          return ErrorDialog(
            message: "Registration failed: $error",
          );
        },
      );
    }
  }

  Future<void> authenticateSellerAndSignUp() async {
    User? currentUser;

    try {
      final UserCredential credential =
      await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      currentUser = credential.user;
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

      return;
    }

    if (currentUser != null) {
      await saveDataToFireStore(currentUser);

      if (!mounted) return;

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }

  Future<void> saveDataToFireStore(User currentUser) async {
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentUser.uid)
        .set({
      "sellerUID": currentUser.uid,
      "sellerEmail": currentUser.email,
      "sellerName": nameController.text.trim(),
      "sellerAvtar": sellerImageUrl,
      "phone": phoneController.text.trim(),
      "address": completeAddress,
      "status": "Approved",
      "lat": position!.latitude,
      "lng": position!.longitude,
    });

    sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences!.setString(
      "uid",
      currentUser.uid,
    );

    await sharedPreferences!.setString(
      "email",
      currentUser.email.toString(),
    );

    await sharedPreferences!.setString(
      "name",
      nameController.text.trim(),
    );

    await sharedPreferences!.setString(
      "PhotoUrl",
      sellerImageUrl,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    confirmePasswordController.dispose();
    phoneController.dispose();
    locationController.dispose();
    emailController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 10),

          InkWell(
            onTap: _getImage,
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage: imageXFile == null
                  ? null
                  : FileImage(
                File(imageXFile!.path),
              ),
              child: imageXFile == null
                  ? Icon(
                Icons.add_photo_alternate,
                size: MediaQuery.of(context).size.width * 0.20,
                color: mediumBlue,
              )
                  : null,
            ),
          ),

          const SizedBox(height: 15),

          const Text(
            "Create Seller Account",
            style: TextStyle(
              color: darkBlue,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 5),

          const Text(
            "Register your restaurant with FoodHub",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          Form(
            key: _formKey,
            child: Column(
              children: [
                CustomTextField(
                  data: Icons.person,
                  controller: nameController,
                  hintText: 'Name',
                  isObsecre: false,
                ),

                CustomTextField(
                  data: Icons.email,
                  controller: emailController,
                  hintText: 'Email',
                  isObsecre: false,
                ),

                CustomTextField(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: 'Password',
                  isObsecre: true,
                ),

                CustomTextField(
                  data: Icons.lock,
                  controller: confirmePasswordController,
                  hintText: 'Confirm Password',
                  isObsecre: true,
                ),

                CustomTextField(
                  data: Icons.phone,
                  controller: phoneController,
                  hintText: 'Phone',
                  isObsecre: false,
                ),

                CustomTextField(
                  data: Icons.my_location,
                  controller: locationController,
                  hintText: 'Cafe/Restaurant Address',
                  isObsecre: false,
                  enabled: true,
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: getCurrentLocation,
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Get My Current Location',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mediumBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          ElevatedButton(
            onPressed: formValidation,
            style: ElevatedButton.styleFrom(
              backgroundColor: darkBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 55,
                vertical: 18,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}