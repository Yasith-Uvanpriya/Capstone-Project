import 'package:flutter/material.dart';
import 'map_page.dart';
import 'accident_reporting_page.dart';
import 'call_police.dart'; // Import the map page

void main() {
  runApp(AcciaLertApp());
}

class AcciaLertApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AcciaLert',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0A0A23), Color(0xFF2C2C54)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                // Top icons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Icon(Icons.menu, color: Colors.white),
                    Icon(Icons.notifications_none, color: Colors.white),
                  ],
                ),
                const SizedBox(height: 30),

                // Title
                const Text(
                  'AcciaLert',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                // Image
                Image.asset(
                  'assests/map_img.png', // Make sure this file exists
                  height: 200,
                ),

                const SizedBox(height: 40),

                // Buttons
                CustomButton(
                  text: 'Quick Reporting',
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccidentReportPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: 'Call Police',
                  onPressed: () => callNearestPoliceStation(context),
                ),
                const SizedBox(height: 15),

                // Directions button that navigates to MapPage
                CustomButton(
                  text: 'Directions',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapSample()),
                    );
                  },
                ),

                const Spacer(),

                // Bottom text
                Column(
                  children: const [
                    Text(
                      'Online accident reporter in Sri Lanka',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Sri Lanka Police',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor; // Already declared

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor = Colors.white, // ✅ Provide a default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: textColor), // ✅ Apply the text color here
      ),
    );
  }
}
