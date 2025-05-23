import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(TestNavBarApp());

class TestNavBarApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(child: Navbar()), // test only the NavBar widget
      ),
    );
  }
}

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF000000).withOpacity(0.1),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
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
          Row(
            children: [
              _navItem("Home"),
              _navItem("Analysis"),
              _navItem("History"),
              _navItem("Logout"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _navItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        onTap: () {},
        child: Text(
          title,
          style: GoogleFonts.lato(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
