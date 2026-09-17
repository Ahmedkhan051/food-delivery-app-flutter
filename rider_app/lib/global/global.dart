import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

Position? position;

String completeAddress = "";

List<Placemark>? placeMarks;

// Rider delivery earnings
String perParcelDeliveryAmount = "";

// Previous earnings
String previousEarnings = "";
String previousRidersEarnings = "";