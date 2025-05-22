import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double R = 6371; // Earth radius in kilometers
  double dLat = _deg2rad(lat2 - lat1);
  double dLon = _deg2rad(lon2 - lon1);
  double a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

double _deg2rad(double deg) => deg * (pi / 180);

Future<void> callNearestPoliceStation(BuildContext context) async {
  try {
    // Step 1: Check location services
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    // Step 2: Request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied.')),
      );
      return;
    }

    // Step 3: Get current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    double userLat = position.latitude;
    double userLon = position.longitude;
    print('User location: $userLat, $userLon');

    // Step 4: Fetch police station data
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('police_numbers').get();

    if (snapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No police stations in database.')),
      );
      return;
    }

    double? minDistance;
    Map<String, dynamic>? nearestPolice;
    const double maxAcceptableDistanceKm = 50; // Optional filter

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      print('Checking station: ${data['phone']}');

      double? lat = _toDouble(data['latitude']);
      double? lon = _toDouble(data['longitude']);

      if (lat == null || lon == null) {
        print('Invalid lat/lon in document: ${doc.id}');
        continue;
      }

      double distance = calculateDistance(userLat, userLon, lat, lon);
      print('Distance to station: $distance km');

      if ((minDistance == null || distance < minDistance) &&
          distance < maxAcceptableDistanceKm) {
        minDistance = distance;
        nearestPolice = data;
      }
    }

    // Step 5: Launch phone call
    if (nearestPolice != null && nearestPolice['phone'] != null) {
      final phoneNumber = nearestPolice['phone'];
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      if (await canLaunchUrl(phoneUri)) {
        await launchUrl(phoneUri);
      } else {
        throw 'Could not launch phone dialer';
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No nearby police station found.')),
      );
    }
  } catch (e) {
    print('Error: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Error: $e')));
  }
}

// Convert dynamic to double safely
double? _toDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value);
  return null;
}
