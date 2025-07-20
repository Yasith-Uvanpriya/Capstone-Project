import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Footer/footer.dart';
import '../Navbar/navbar.dart';
import 'package:intl/intl.dart'; // For date formatting

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyB-AWdm-aKnAhFDz-AOsY2Rqa7PZV1jIwo",
      authDomain: "projectcapstone-cd867.firebaseapp.com",
      projectId: "projectcapstone-cd867",
      storageBucket: "projectcapstone-cd867.appspot.com",
      messagingSenderId: "951216708050",
      appId: "1:951216708050:web:YOUR_WEB_APP_ID",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Accident History',
      home: const AccidentHistoryPage(),
    );
  }
}

class AccidentHistoryPage extends StatefulWidget {
  const AccidentHistoryPage({super.key});
  @override
  _AccidentHistoryPageState createState() => _AccidentHistoryPageState();
}

class _AccidentHistoryPageState extends State<AccidentHistoryPage> {
  final TextEditingController timeController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController vehicleNumberController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  Future<void> searchReports() async {
    try {
      String time = timeController.text.trim().toLowerCase();
      String location = locationController.text.trim().toLowerCase();
      String vehicleNumber = vehicleNumberController.text.trim().toLowerCase();
      String startDate = startDateController.text.trim();
      String endDate = endDateController.text.trim();

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('solved_reports').get();

      List<Map<String, dynamic>> results =
          snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).where((
            data,
          ) {
            bool matches = true;

            if (time.isNotEmpty) {
              matches &= (data['time']?.toString().toLowerCase() == time);
            }
            if (location.isNotEmpty) {
              matches &=
                  (data['location']?.toString().toLowerCase() == location);
            }
            if (vehicleNumber.isNotEmpty) {
              matches &=
                  (data['vehicle_numbers']?.toString().toLowerCase() ==
                      vehicleNumber);
            }

            if (startDate.isNotEmpty && endDate.isNotEmpty) {
              try {
                final start = DateTime.parse(startDate);
                final end = DateTime.parse(
                  endDate,
                ).add(const Duration(days: 1));

                // Parse Firestore string timestamp to DateTime
                final format = DateFormat(
                  "d MMM yyyy 'PMT' HH:mm:ss 'UTC+5:30'",
                );
                final timestampStr =
                    data['timestamp']?.toString().replaceAll("PMt", "PMT") ??
                    "";
                final reportDate = format.parse(timestampStr);

                matches &=
                    reportDate.isAfter(start) && reportDate.isBefore(end);
              } catch (e) {
                return false;
              }
            }

            return matches;
          }).toList();

      if (results.isEmpty) {
        showNoResultsDialog();
      } else {
        showResultsDialog(results);
      }
    } catch (e) {
      showErrorDialog(e.toString());
    }
  }

  void showResultsDialog(List<Map<String, dynamic>> results) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Search Results'),
            content: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Accident Type')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Location')),
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Description')),
                ],
                rows:
                    results
                        .map(
                          (report) => DataRow(
                            cells: [
                              DataCell(Text(report['accidentType'] ?? '')),
                              DataCell(Text(report['email'] ?? '')),
                              DataCell(Text(report['location'] ?? '')),
                              DataCell(Text(report['timestamp'] ?? '')),
                              DataCell(Text(report['description'] ?? '')),
                            ],
                          ),
                        )
                        .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void showNoResultsDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('No Results Found'),
            content: const Text('No reports match your search criteria.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  void dispose() {
    timeController.dispose();
    locationController.dispose();
    vehicleNumberController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF01346F),
      body: Column(
        children: [
          const Navbar(),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF01346F), Color(0xFF0C7DA0)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'Images/hourglass.png',
                          height: 150,
                          width: 150,
                        ),
                        Text(
                          'Accident History',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Image.asset(
                          'Images/hourglass2.png',
                          height: 150,
                          width: 150,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Wrap(
                      spacing: 20,
                      runSpacing: 30,
                      alignment: WrapAlignment.center,
                      children: [
                        buildLabeledField('Time', timeController),
                        buildLabeledField('Location', locationController),
                        buildLabeledField(
                          'Vehicle Number',
                          vehicleNumberController,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Wrap(
                      spacing: 20,
                      runSpacing: 20,
                      alignment: WrapAlignment.center,
                      children: [
                        buildLabeledField(
                          'Start',
                          startDateController,
                          isDate: true,
                        ),
                        buildLabeledField(
                          'End',
                          endDateController,
                          isDate: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: searchReports,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052D4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Search',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const CustomFooter(),
        ],
      ),
    );
  }

  Widget buildLabeledField(
    String label,
    TextEditingController controller, {
    bool isDate = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: 250,
          child: TextField(
            controller: controller,
            readOnly: isDate,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              suffixIcon:
                  isDate
                      ? const Icon(Icons.calendar_today, color: Colors.grey)
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onTap: () async {
              if (isDate) {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  controller.text =
                      pickedDate.toIso8601String().split('T')[0]; // yyyy-MM-dd
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
