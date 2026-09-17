import 'package:url_launcher/url_launcher.dart';

class MapUtils {
  MapUtils._();

  static Future<void> launchMapFromSourceToDestination(
      double? sourceLat,
      double? sourceLng,
      double? destinationLat,
      double? destinationLng,
      ) async {
    if (sourceLat == null ||
        sourceLng == null ||
        destinationLat == null ||
        destinationLng == null) {
      throw Exception(
        "Location coordinates are not available.",
      );
    }

    final Uri mapUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1'
          '&origin=$sourceLat,$sourceLng'
          '&destination=$destinationLat,$destinationLng'
          '&travelmode=driving',
    );

    try {
      final bool launched =
      await launchUrl(
        mapUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception(
          "Could not open Google Maps.",
        );
      }
    } catch (_) {
      throw Exception(
        "Could not open the map.",
      );
    }
  }
}