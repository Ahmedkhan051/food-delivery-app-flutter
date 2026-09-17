import 'package:url_launcher/url_launcher.dart';

class MapsUtils {
  MapsUtils._();

  static Future<void> openMapWithPosition(
      String latitude,
      String longitude,
      ) async {
    final String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    try {
      final Uri uri = Uri.parse(googleMapUrl);

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('Could not open Google Maps.');
      }
    } catch (_) {
      throw Exception('Could not open the map.');
    }
  }

  static Future<void> openMapWithAddress(String fullAddress) async {
    final String query = Uri.encodeComponent(fullAddress);

    final String googleMapUrl =
        'https://www.google.com/maps/search/?api=1&query=$query';

    try {
      final Uri uri = Uri.parse(googleMapUrl);

      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        throw Exception('Could not open Google Maps.');
      }
    } catch (_) {
      throw Exception('Could not open the map.');
    }
  }
}