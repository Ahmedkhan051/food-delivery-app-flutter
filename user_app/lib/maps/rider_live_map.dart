import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RiderLiveMap extends StatefulWidget {
  final String orderId;
  final double? initialLatitude;
  final double? initialLongitude;

  const RiderLiveMap({
    super.key,
    required this.orderId,
    this.initialLatitude,
    this.initialLongitude,
  });

  @override
  State<RiderLiveMap> createState() => _RiderLiveMapState();
}

class _RiderLiveMapState extends State<RiderLiveMap> {
  GoogleMapController? _mapController;
  StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>?
  _orderSubscription;

  LatLng? _riderPosition;

  final Set<Marker> _markers = <Marker>{};

  bool _mapReady = false;
  bool _locationActive = false;

  String _riderName = '';
  String _riderStage = 'Waiting for Rider';

  @override
  void initState() {
    super.initState();

    if (widget.initialLatitude != null &&
        widget.initialLongitude != null) {
      _riderPosition = LatLng(
        widget.initialLatitude!,
        widget.initialLongitude!,
      );
      _updateMarker();
    }

    _listenToOrder();
  }

  void _listenToOrder() {
    _orderSubscription = FirebaseFirestore.instance
        .collection('orders')
        .doc(widget.orderId)
        .snapshots()
        .listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      if (!snapshot.exists) return;

      final Map<String, dynamic>? data = snapshot.data();

      if (data == null) return;

      final dynamic latitudeValue = data['riderLat'];
      final dynamic longitudeValue = data['riderLng'];

      final double? latitude = latitudeValue is num
          ? latitudeValue.toDouble()
          : double.tryParse(latitudeValue?.toString() ?? '');

      final double? longitude = longitudeValue is num
          ? longitudeValue.toDouble()
          : double.tryParse(longitudeValue?.toString() ?? '');

      final bool locationActive =
          data['riderLocationActive'] == true;

      final String riderName =
      (data['riderName'] ?? '').toString();

      final String riderStage =
      (data['riderStage'] ?? 'Waiting for Rider').toString();

      if (!mounted) return;

      setState(() {
        _locationActive = locationActive;
        _riderName = riderName;
        _riderStage = riderStage;

        if (latitude != null && longitude != null) {
          _riderPosition = LatLng(latitude, longitude);
        }

        _updateMarker();
      });

      if (_mapReady && _riderPosition != null) {
        _moveCamera(_riderPosition!);
      }
    });
  }

  void _updateMarker() {
    _markers.clear();

    if (_riderPosition == null) return;

    _markers.add(
      Marker(
        markerId: const MarkerId('rider'),
        position: _riderPosition!,
        infoWindow: InfoWindow(
          title: _riderName.isEmpty ? 'Delivery Rider' : _riderName,
          snippet: _riderStage,
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueAzure,
        ),
      ),
    );
  }

  Future<void> _moveCamera(LatLng position) async {
    final GoogleMapController? controller = _mapController;

    if (controller == null) return;

    await controller.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _mapReady = true;

    if (_riderPosition != null) {
      _moveCamera(_riderPosition!);
    }
  }

  @override
  void dispose() {
    _orderSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LatLng fallbackPosition = _riderPosition ??
        const LatLng(
          19.0760,
          72.8777,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.location_on,
              color: Colors.blue,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Live Rider Location',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: _locationActive
                    ? Colors.green.withValues(alpha: 0.12)
                    : Colors.grey.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.circle,
                    size: 9,
                    color: _locationActive
                        ? Colors.green
                        : Colors.grey,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _locationActive ? 'LIVE' : 'OFFLINE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: _locationActive
                          ? Colors.green
                          : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        if (_riderName.isNotEmpty)
          Text(
            'Rider: $_riderName',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

        Text(
          'Stage: $_riderStage',
          style: const TextStyle(
            fontSize: 13,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 12),

        Container(
          height: 320,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: fallbackPosition,
              zoom: 14,
            ),
            onMapCreated: _onMapCreated,
            markers: _markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            compassEnabled: true,
            mapToolbarEnabled: true,
          ),
        ),

        if (_riderPosition == null)
          const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Text(
              'Rider location has not been shared yet.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),

        if (_locationActive)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.sync,
                  size: 16,
                  color: Colors.green,
                ),
                SizedBox(width: 6),
                Text(
                  'Rider location updates automatically.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}