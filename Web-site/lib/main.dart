import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(AccidentDetectorApp());
}

class AccidentDetectorApp extends StatelessWidget {
  const AccidentDetectorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset('Images/traffic-jam.jpg', fit: BoxFit.cover),
                Container(color: Colors.black.withOpacity(0.5)),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Accident\nDetector!',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.thasadith(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w100,
                            fontSize: 55,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Icon(Icons.shield, size: 60, color: Colors.amber),
                      const SizedBox(height: 20),
                      Text(
                        'Online accident detector in Sri Lanka',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.thasadith(
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Sri Lanka Police',
                        style: GoogleFonts.thasadith(
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Right Side - Login Form
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF060C46), Color(0xFF2395AC)],
                ),
              ),
              child: Center(
                child: Container(
                  width: 400,
                  height: 450,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFD9D9D9).withOpacity(.1),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Login',
                        style: GoogleFonts.inter(
                          fontSize: 30,
                          fontWeight: FontWeight.w100,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 75),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'User name',
                            hintStyle: GoogleFonts.inter(),
                            filled: true,
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Passwords',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0077FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Enter',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
