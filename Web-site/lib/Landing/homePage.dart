import 'package:flutter/material.dart';
import '../Navbar/navbar.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:footer/footer.dart';
import 'package:footer/footer_view.dart';
import '../Footer/footer.dart';
import '../google_map_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LandingPage(),
    );
  }
}

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF060C46), // Start color
              Color(0xFF2395AC), // End color
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Navbar(),
            Expanded(
              child: Row(
                children: [
                  // Left: Google Map
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: GoogleMapPanel(),
                    ),
                  ),

                  // Right side: Live Update Panel
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    width: 250,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const LiveUpdatePanel(),
                  ),
                ],
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}

class LiveUpdatePanel extends StatefulWidget {
  const LiveUpdatePanel({super.key});

  @override
  State<LiveUpdatePanel> createState() => _LiveUpdatePanelState();
}

class _LiveUpdatePanelState extends State<LiveUpdatePanel> {
  int todayReported = 125; // Hardcoded or you can fetch based on today's date
  int activeCases = 0;
  int solvedCases = 0; // Optional: Fetch separately if needed

  @override
  void initState() {
    super.initState();
    fetchActiveCases();
    fetchSolvedCaseCount();
  }

  Future<void> fetchActiveCases() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('accident_reports').get();

      setState(() {
        activeCases = snapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching accident reports: $e');
    }
  }

  void fetchSolvedCaseCount() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('solved_reports').get();
    setState(() {
      solvedCases = snapshot.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    String currentDate = DateFormat('yyyy/MM/dd').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Live Update',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w100,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Date',
          style: GoogleFonts.inter(color: Colors.white.withOpacity(0.8)),
        ),
        Text(
          currentDate,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        const SizedBox(height: 24),
        InfoBox(
          color: Colors.yellow,
          title: 'Today reported',
          value: todayReported.toString(),
          textColor: Colors.black,
        ),
        const SizedBox(height: 16),
        InfoBox(
          color: Colors.red,
          title: 'Active cases',
          value: activeCases.toString(),
          textColor: Colors.white,
        ),
        const SizedBox(height: 16),
        InfoBox(
          color: Colors.green,
          title: 'Solved',
          value: solvedCases.toString(),
          textColor: Colors.white,
        ),
      ],
    );
  }
}

class InfoBox extends StatelessWidget {
  final Color color;
  final String title;
  final String value;
  final Color textColor;

  const InfoBox({
    super.key,
    required this.color,
    required this.title,
    required this.value,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
