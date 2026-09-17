import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:user_app/global/global.dart';
import 'package:user_app/models/address.dart';
import 'package:user_app/widgets/simple_Appbar.dart';
import 'package:user_app/widgets/text_field.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({super.key});

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _flatNumber = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _completeAddress =
  TextEditingController();
  final TextEditingController _locationController =
  TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<Placemark>? placemarks;
  Position? position;

  Future<void> getUserLocationAddress() async {
    try {
      LocationPermission permission =
      await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(
          msg: "Location permission is required.",
        );
        return;
      }

      Position newPosition =
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      position = newPosition;

      placemarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      if (placemarks == null || placemarks!.isEmpty) {
        Fluttertoast.showToast(
          msg: "Unable to find your address.",
        );
        return;
      }

      Placemark pMarks = placemarks![0];

      final String fullAddress =
          '${pMarks.subThoroughfare ?? ''} '
          '${pMarks.thoroughfare ?? ''}, '
          '${pMarks.subLocality ?? ''} '
          '${pMarks.locality ?? ''}, '
          '${pMarks.subAdministrativeArea ?? ''}, '
          '${pMarks.administrativeArea ?? ''} '
          '${pMarks.postalCode ?? ''}, '
          '${pMarks.country ?? ''}';

      _locationController.text = fullAddress;

      _flatNumber.text =
      '${pMarks.subThoroughfare ?? ''} '
          '${pMarks.thoroughfare ?? ''}, '
          '${pMarks.subLocality ?? ''} '
          '${pMarks.locality ?? ''}, '
          '${pMarks.subAdministrativeArea ?? ''}';

      _city.text =
      '${pMarks.locality ?? ''}, '
          '${pMarks.postalCode ?? ''}';

      _state.text =
      '${pMarks.administrativeArea ?? ''}, '
          '${pMarks.country ?? ''}';

      _completeAddress.text = fullAddress;

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: "Address detected successfully.",
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Unable to get your location.",
      );
    }
  }

  Future<void> saveAddress(BuildContext context) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (position == null) {
      Fluttertoast.showToast(
        msg: "Please use Get My Address first.",
      );
      return;
    }

    final String? uid =
    sharedPreferences?.getString("uid");

    if (uid == null || uid.isEmpty) {
      Fluttertoast.showToast(
        msg: "User session not found.",
      );
      return;
    }

    try {
      final Map<String, dynamic> model = Address(
        name: _name.text.trim(),
        state: _state.text.trim(),
        fullAddress: _completeAddress.text.trim(),
        phoneNumber: _phoneNumber.text.trim(),
        flatNumber: _flatNumber.text.trim(),
        city: _city.text.trim(),
        lat: position!.latitude.toString(),
        lng: position!.longitude.toString(),
      ).toJson();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(uid)
          .collection("userAddress")
          .doc(
        DateTime.now()
            .millisecondsSinceEpoch
            .toString(),
      )
          .set(model);

      if (!mounted) return;

      Fluttertoast.showToast(
        msg: "New Address has been saved.",
      );

      Navigator.pop(context);
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Unable to save address.",
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _phoneNumber.dispose();
    _flatNumber.dispose();
    _city.dispose();
    _state.dispose();
    _completeAddress.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "FoodHub",
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          saveAddress(context);
        },
        label: const Text(
          "Save Now",
        ),
        backgroundColor: const Color(0xFF1976D2),
        icon: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 100,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 6,
              ),

              const Align(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Save New Address",
                    style: TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(
                  Icons.person_pin_circle,
                  color: Color(0xFF1565C0),
                  size: 35,
                ),
                title: TextField(
                  controller: _locationController,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: const InputDecoration(
                    hintText: "What's your address",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              ElevatedButton.icon(
                onPressed: getUserLocationAddress,
                icon: const Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                label: const Text(
                  "Get My Address",
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: _name,
                    ),
                    MyTextField(
                      hint: "Phone Number",
                      controller: _phoneNumber,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: _city,
                    ),
                    MyTextField(
                      hint: "State",
                      controller: _state,
                    ),
                    MyTextField(
                      hint: "Address Line",
                      controller: _flatNumber,
                    ),
                    MyTextField(
                      hint: "Complete Address",
                      controller: _completeAddress,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}