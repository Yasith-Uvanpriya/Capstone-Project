// lib/Footer/footer.dart
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFooter extends StatelessWidget {
  const CustomFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Footer(
      backgroundColor: Color(0xFF000000).withOpacity(0.1),
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  height: 45.0,
                  width: 70.0,
                  child: Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45.0,
                  width: 80.0,
                  child: Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Analysis',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45.0,
                  width: 80.0,
                  child: Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'History',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45.0,
                  width: 80.0,
                  child: Center(
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const SizedBox(width: 20), // Left padding
              Expanded(child: Divider(color: Colors.grey, thickness: 1)),
              const SizedBox(width: 20), // Right padding
            ],
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(Icons.shield, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  "Accident Detector",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w100,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
