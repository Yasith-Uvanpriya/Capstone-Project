import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Footer/footer.dart';
import '../Navbar/navbar.dart';

void main() {
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
  // Controllers for Start and End date fields
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();

  // Function to show the date picker
  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // current date as default
      firstDate: DateTime(2000), // earliest date allowed
      lastDate: DateTime(2100), // latest date allowed
    );

    // If a date is selected, set it to the controller
    if (pickedDate != null) {
      setState(() {
        controller.text =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
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
            const Navbar(), // Top navigation bar

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

                    // Date Inputs (Start and End)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Start Date Field
                          Flexible(
                            child: TextField(
                              controller: _startDateController,
                              readOnly: true, // Disable manual typing
                              onTap:
                                  () => _selectDate(
                                    context,
                                    _startDateController,
                                  ), // Show calendar on tap
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

                          // End Date Field
                          Flexible(
                            child: TextField(
                              controller: _endDateController,
                              readOnly: true, // Disable manual typing
                              onTap:
                                  () => _selectDate(
                                    context,
                                    _endDateController,
                                  ), // Show calendar on tap
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

                    // Analyze Button
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        backgroundColor: Color(0xFF0077FF),
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

            // Footer
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
