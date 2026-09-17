import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../global/global.dart';

class UserLocation {
  final Geocoding _geocoding = Geocoding();

  Future<bool> getCurrentLocation() async {
    try {
      // -------------------------------------------------------
      // CHECK LOCATION SERVICE
      // -------------------------------------------------------

      final bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return false;
      }

      // -------------------------------------------------------
      // CHECK / REQUEST PERMISSION
      // -------------------------------------------------------

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        return false;
      }

      // -------------------------------------------------------
      // GET CURRENT LOCATION
      // -------------------------------------------------------
      //
      // Geolocator 14 uses LocationSettings instead of the
      // deprecated desiredAccuracy parameter.
      //

      const LocationSettings locationSettings =
      LocationSettings(
        accuracy: LocationAccuracy.high,
      );

      final Position newPosition =
      await Geolocator.getCurrentPosition(
        locationSettings: locationSettings,
      );

      // -------------------------------------------------------
      // SAVE POSITION GLOBALLY
      // -------------------------------------------------------

      position = newPosition;

      // -------------------------------------------------------
      // REVERSE GEOCODING
      // -------------------------------------------------------

      placeMarks =
      await _geocoding.placemarkFromCoordinates(
        position!.latitude,
        position!.longitude,
      );

      // -------------------------------------------------------
      // BUILD COMPLETE ADDRESS
      // -------------------------------------------------------

      if (placeMarks != null &&
          placeMarks!.isNotEmpty) {
        final Placemark pMarks =
            placeMarks!.first;

        final List<String> addressParts = [
          if ((pMarks.subThoroughfare ?? '')
              .trim()
              .isNotEmpty)
            pMarks.subThoroughfare!.trim(),

          if ((pMarks.thoroughfare ?? '')
              .trim()
              .isNotEmpty)
            pMarks.thoroughfare!.trim(),

          if ((pMarks.subLocality ?? '')
              .trim()
              .isNotEmpty)
            pMarks.subLocality!.trim(),

          if ((pMarks.locality ?? '')
              .trim()
              .isNotEmpty)
            pMarks.locality!.trim(),

          if ((pMarks.subAdministrativeArea ??
              '')
              .trim()
              .isNotEmpty)
            pMarks.subAdministrativeArea!.trim(),

          if ((pMarks.administrativeArea ?? '')
              .trim()
              .isNotEmpty)
            pMarks.administrativeArea!.trim(),

          if ((pMarks.postalCode ?? '')
              .trim()
              .isNotEmpty)
            pMarks.postalCode!.trim(),

          if ((pMarks.country ?? '')
              .trim()
              .isNotEmpty)
            pMarks.country!.trim(),
        ];

        completeAddress =
            addressParts.join(', ');
      }

      return true;
    } catch (_) {
      return false;
    }
  }
}