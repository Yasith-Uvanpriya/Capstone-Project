import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/Accident_Analyzer/accident_analyzer.dart';
import '../Footer/footer.dart';
import '../Navbar/navbar.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AccidentAnalyzerApp());
}

class AccidentAnalyzerApp extends StatelessWidget {
  const AccidentAnalyzerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Accident Analyzer',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    bool isStart,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        if (isStart) {
          _startDate = pickedDate;
        } else {
          _endDate = pickedDate;
        }
      });
    }
  }

  void _showAnalyzerPopup(BuildContext context) {
    if (_startDate != null && _endDate != null) {
      showDialog(
        context: context,
        builder:
            (_) => Dialog(
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 40,
              ),
              backgroundColor: Colors.white,
              child: Container(
                width: double.infinity,
                height: 600,
                padding: const EdgeInsets.all(8),
                child: AccidentDashboard(
                  startDate: _startDate!, // ✅ Required parameter
                  endDate: _endDate!, // ✅ Required parameter
                ),
              ),
            ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF060C46), Color(0xFF2395AC)],
          ),
        ),
        child: Column(
          children: [
            const Navbar(),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Accident Analyzer",
                      style: GoogleFonts.inter(
                        fontSize: 55,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Enter Time Period",
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _startDateController,
                              readOnly: true,
                              onTap:
                                  () => _selectDate(
                                    context,
                                    _startDateController,
                                    true,
                                  ),
                              decoration: InputDecoration(
                                labelText: "Start",
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: const Color(
                                  0xFFD9D9D9,
                                ).withOpacity(0.1),
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Flexible(
                            child: TextField(
                              controller: _endDateController,
                              readOnly: true,
                              onTap:
                                  () => _selectDate(
                                    context,
                                    _endDateController,
                                    false,
                                  ),
                              decoration: InputDecoration(
                                labelText: "End",
                                labelStyle: const TextStyle(
                                  color: Colors.white,
                                ),
                                filled: true,
                                fillColor: const Color(
                                  0xFFD9D9D9,
                                ).withOpacity(0.1),
                                suffixIcon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (_startDate != null && _endDate != null) {
                          _showAnalyzerPopup(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select both dates"),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        backgroundColor: const Color(0xFF0077FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Analyze",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
