import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MapSample()));
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  late GoogleMapController mapController;
  LatLng? _currentPosition;
  LatLng? _destination;
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  List<LatLng> _routePoints = [];
  bool _showDelayWarning = false;

  TextEditingController _searchController = TextEditingController();
  static const String _apiKey =
      'AIzaSyDCmTcfOw6OkEHi6ZyPfAR1Bc2JJEC6OSw'; // Replace this

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
  }

  Future<void> _handleLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
      if (status.isDenied) {
        _showMessage('Location permission denied');
        return;
      }
    }

    if (status.isPermanentlyDenied) {
      _showMessage('Permission permanently denied. Open settings.');
      await openAppSettings();
      return;
    }

    _determinePosition();
  }

  void _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMessage('Location permission denied.');
        return;
      }
    }

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _searchAndSetDestination(String location) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=$location&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'].isEmpty) {
          _showMessage("Location not found.");
          return;
        }

        final lat = data['results'][0]['geometry']['location']['lat'];
        final lng = data['results'][0]['geometry']['location']['lng'];
        setState(() {
          _destination = LatLng(lat, lng);
          _showDelayWarning = false;
        });

        _getDirections();
      } else {
        _showMessage("Error searching location.");
      }
    } catch (e) {
      _showMessage("Failed to connect to Google Maps API: $e");
    }
  }

  Future<void> _getDirections() async {
    if (_currentPosition == null || _destination == null) return;

    final origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final destination = '${_destination!.latitude},${_destination!.longitude}';
    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&key=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['routes'].isEmpty) {
          _showMessage('No route found');
          return;
        }

        final points = data['routes'][0]['overview_polyline']['points'];
        _routePoints = _decodePolyline(points);

        await _checkAccidentsOnRoute();

        setState(() {
          _polylines = {
            Polyline(
              polylineId: PolylineId('route'),
              points: _routePoints,
              color: Colors.blue,
              width: 5,
            ),
          };
        });

        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            _getLatLngBounds(_currentPosition!, _destination!),
            50,
          ),
        );
      } else {
        _showMessage('Failed to get directions');
      }
    } catch (e) {
      _showMessage('Error getting directions: $e');
    }
  }

  Future<void> _checkAccidentsOnRoute() async {
    if (_routePoints.isEmpty) return;

    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('accident_reports').get();

      Set<Marker> accidentMarkers = {};
      bool hasAccidentOnRoute = false;

      for (var doc in snapshot.docs) {
        if (doc.data().containsKey('latitude') &&
            doc.data().containsKey('longitude')) {
          final lat = double.tryParse(doc['latitude'].toString());
          final lng = double.tryParse(doc['longitude'].toString());

          if (lat == null || lng == null) continue;

          final pos = LatLng(lat, lng);

          accidentMarkers.add(
            Marker(
              markerId: MarkerId('accident-${doc.id}'),
              position: pos,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
              infoWindow: InfoWindow(
                title: 'Accident Reported',
                snippet: 'Reported near this area',
                onTap: () {
                  _showMessage('⚠️ Accident marker tapped');
                },
              ),
            ),
          );

          for (var routePoint in _routePoints) {
            double distance = Geolocator.distanceBetween(
              lat,
              lng,
              routePoint.latitude,
              routePoint.longitude,
            );
            if (distance < 100) {
              hasAccidentOnRoute = true;
              break;
            }
          }
        }
      }

      setState(() {
        _markers = accidentMarkers;
        _showDelayWarning = hasAccidentOnRoute;
      });

      if (hasAccidentOnRoute) {
        _showMessage(
          "⚠️ Accident reported along your route. Your journey may be delayed.",
        );
      }
    } catch (e) {
      _showMessage('Error fetching accident data: $e');
    }
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length, lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : result >> 1;
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  LatLngBounds _getLatLngBounds(LatLng start, LatLng end) {
    return LatLngBounds(
      southwest: LatLng(
        start.latitude < end.latitude ? start.latitude : end.latitude,
        start.longitude < end.longitude ? start.longitude : end.longitude,
      ),
      northeast: LatLng(
        start.latitude > end.latitude ? start.latitude : end.latitude,
        start.longitude > end.longitude ? start.longitude : end.longitude,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF060C46),
        title: Text('Direction', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body:
          _currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition!,
                      zoom: 15.0,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    markers: _markers,
                    polylines: _polylines,
                  ),
                  Positioned(
                    top: 10,
                    left: 15,
                    right: 15,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Enter destination',
                          suffixIcon: IconButton(
                            icon: Icon(Icons.search),
                            onPressed:
                                () => _searchAndSetDestination(
                                  _searchController.text,
                                ),
                          ),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (value) => _searchAndSetDestination(value),
                      ),
                    ),
                  ),
                  if (_showDelayWarning)
                    Positioned(
                      top: 70,
                      left: 15,
                      right: 15,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "⚠️ Accident on route - possible delays",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
    );
  }
}
