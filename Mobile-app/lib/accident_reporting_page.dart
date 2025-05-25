import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

void main() => runApp(const MaterialApp(home: AccidentReportPage()));

class AccidentReportPage extends StatefulWidget {
  const AccidentReportPage({super.key});

  @override
  State<AccidentReportPage> createState() => _AccidentReportPageState();
}

class _AccidentReportPageState extends State<AccidentReportPage> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _accidentTypeController = TextEditingController();
  File? _selectedImage;
  File? _selectedVideo;
  double? _latitude;
  double? _longitude;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedVideo = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadFileToFirebase(File file, String folder) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final storageRef = FirebaseStorage.instance.ref().child(
        '$folder/$fileName',
      );

      final uploadTask = await storageRef.putFile(file);
      final downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Firebase upload error: $e');
      return null;
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied)
        return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _latitude = position.latitude;
    _longitude = position.longitude;

    List<Placemark> placemarks = await placemarkFromCoordinates(
      _latitude!,
      _longitude!,
    );

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String address =
          '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
      setState(() {
        _locationController.text = address;
      });
    }
  }

  Future<void> _submitReport() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must be logged in to submit.')),
      );
      return;
    }

    String? imageUrl;
    String? videoUrl;

    if (_selectedImage != null) {
      imageUrl = await _uploadFileToFirebase(_selectedImage!, 'images');
    }

    if (_selectedVideo != null) {
      videoUrl = await _uploadFileToFirebase(_selectedVideo!, 'videos');
    }

    // Get lat/lng from the location address
    try {
      List<Location> locations = await locationFromAddress(
        _locationController.text,
      );
      if (locations.isNotEmpty) {
        _latitude = locations.first.latitude;
        _longitude = locations.first.longitude;
      }
    } catch (e) {
      print('Geocoding failed: $e');
    }

    String formattedTimestamp = DateFormat(
      "dd MMM yyyy at HH:mm:ss 'UTC+5:30'",
    ).format(DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)));

    await FirebaseFirestore.instance.collection('accident_reports').add({
      'userId': user.uid,
      'email': user.email,
      'location': _locationController.text,
      'accidentType': _accidentTypeController.text,
      'timestamp': formattedTimestamp,
      'imageEvidence': imageUrl,
      'videoEvidence': videoUrl,
      'latitude': _latitude,
      'longitude': _longitude,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Submission Successful!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 5),
      ),
    );

    _locationController.clear();
    _accidentTypeController.clear();
    setState(() {
      _selectedImage = null;
      _selectedVideo = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000428), Color(0xFF004e92)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    prefixIcon: Icon(Icons.location_on),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _accidentTypeController,
                  decoration: const InputDecoration(
                    labelText: 'Accident Type',
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Upload Evidence",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: const Icon(Icons.videocam, color: Colors.white),
                      onPressed: _pickVideo,
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.image, color: Colors.white),
                      onPressed: _pickImage,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('Submit', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
