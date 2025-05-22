import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyB-AWdm-aKnAhFDz-AOsY2Rqa7PZV1jIwo",
        authDomain: "projectcapstone-cd867.firebaseapp.com",
        projectId: "projectcapstone-cd867",
        storageBucket: "projectcapstone-cd867.appspot.com",
        messagingSenderId: "951216708050",
        appId: "1:951216708050:web:YOUR_WEB_APP_ID",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(AccidentChart());
}

class AccidentChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Accident Analyzer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.blue.shade50,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          shadowColor: Colors.blue.shade100,
          elevation: 4,
        ),
      ),
      home: AccidentDashboard(
        startDate: DateTime.now().subtract(Duration(days: 30)), // ✅ required
        endDate: DateTime.now(), // ✅ required
      ),
    );
  }
}

class AccidentDashboard extends StatefulWidget {
  final DateTime startDate;
  final DateTime endDate;

  const AccidentDashboard({
    Key? key,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);
  @override
  _AccidentDashboardState createState() => _AccidentDashboardState();
}

class _AccidentDashboardState extends State<AccidentDashboard> {
  Map<String, int> roadCounts = {};
  List<String> predictedRoads = [];
  bool isLoading = true;
  bool predictionLoading = false;

  @override
  void initState() {
    super.initState();
    fetchAndAnalyzeData();
  }

  Future<void> fetchAndAnalyzeData() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('accident_reports').get();

    Map<String, int> counts = {};
    List<Map<String, dynamic>> allData = [];

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final timestampStr = data['timestamp'] as String?;

      if (timestampStr == null) continue;

      // 🔍 Try parsing Firestore timestamp string to DateTime
      try {
        final date = _parseCustomDateFormat(timestampStr);

        if (date.isAfter(widget.startDate) && date.isBefore(widget.endDate)) {
          final road = data['location'] ?? 'Unknown Road';
          counts[road] = (counts[road] ?? 0) + 1;
          allData.add(data);
        }
      } catch (e) {
        print('Date parse error for: $timestampStr → $e');
      }
    }

    setState(() {
      roadCounts = counts;
      isLoading = false;
    });

    await sendToAI(allData);
  }

  Future<void> sendToAI(List<Map<String, dynamic>> data) async {
    setState(() {
      predictionLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.8.112:8000/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"data": data}),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          predictedRoads = List<String>.from(json['top_roads']);
        });
      }
    } catch (e) {
      print("Error contacting AI server: $e");
    }

    setState(() {
      predictionLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedRoads =
        roadCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(title: Text("Accident Analyzer + AI")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "📊 Most Accident-Prone Roads",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Expanded(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY:
                                  sortedRoads.isNotEmpty
                                      ? sortedRoads.first.value.toDouble() + 5
                                      : 5,
                              barGroups: List.generate(sortedRoads.length, (
                                index,
                              ) {
                                final e = sortedRoads[index];
                                return BarChartGroupData(
                                  x: index,
                                  barRods: [
                                    BarChartRodData(
                                      toY: e.value.toDouble(),
                                      color: Colors.blue,
                                      width: 16,
                                    ),
                                  ],
                                );
                              }),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final idx = value.toInt();
                                      if (idx >= sortedRoads.length)
                                        return Container();
                                      return Transform.rotate(
                                        angle: -pi / 4,
                                        child: Text(
                                          sortedRoads[idx].key,
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: true),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "🤖 AI-Predicted Risky Roads",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    predictionLoading
                        ? Center(child: CircularProgressIndicator())
                        : Expanded(
                          child: ListView(
                            children:
                                predictedRoads
                                    .map(
                                      (road) => Card(
                                        margin: EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.warning,
                                            color: Colors.redAccent,
                                          ),
                                          title: Text(road),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                  ],
                ),
              ),
    );
  }
}

DateTime _parseCustomDateFormat(String timestampStr) {
  // Remove 'UTC+5:30' and parse remaining
  final cleaned = timestampStr.replaceAll(' UTC+5:30', '');
  return DateTime.parse(
    DateTime.parse(
      DateTime.tryParse(cleaned) != null ? cleaned : _convertToISO(cleaned),
    ).toIso8601String(),
  );
}

/// Converts "15 May 2025 PMT 18:34:02" into ISO format: "2025-05-15T18:34:02"
String _convertToISO(String raw) {
  final parts = raw.split(' ');
  if (parts.length < 5) throw FormatException("Invalid timestamp");

  final day = parts[0].padLeft(2, '0');
  final month = _monthToNumber(parts[1]);
  final year = parts[2];
  final time = parts[4];

  return "$year-$month-$day" + "T$time"; // ✅ Corrected interpolation
}

String _monthToNumber(String month) {
  const months = {
    'Jan': '01',
    'Feb': '02',
    'Mar': '03',
    'Apr': '04',
    'May': '05',
    'Jun': '06',
    'Jul': '07',
    'Aug': '08',
    'Sep': '09',
    'Oct': '10',
    'Nov': '11',
    'Dec': '12',
  };
  return months[month] ?? '01';
}
