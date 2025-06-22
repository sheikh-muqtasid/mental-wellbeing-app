import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../session_diary_page.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  final List<TextEditingController> _beliefControllers = List.generate(
    10,
    (index) => TextEditingController(),
  );
  final List<TextEditingController> _circumstanceControllers = List.generate(
    10,
    (index) => TextEditingController(),
  );
  final List<double> _intensityValues = List.filled(10, 0.0);

  Future<void> _loadTrackingData() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 10; i++) {
      _beliefControllers[i].text = prefs.getString('belief$i') ?? '';
      _circumstanceControllers[i].text =
          prefs.getString('circumstance$i') ?? '';
      _intensityValues[i] = prefs.getDouble('intensity$i') ?? 0.0;
    }
    setState(() {});
  }

  // Save tracking data to SharedPreferences
  Future<void> _saveTrackingData() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 10; i++) {
      prefs.setString('belief$i', _beliefControllers[i].text);
      prefs.setString('circumstance$i', _circumstanceControllers[i].text);
      prefs.setDouble('intensity$i', _intensityValues[i]);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tracking data saved successfully!')),
    );
  }

  void _submitTracking() {
    List<Map<String, dynamic>> beliefs = [];
    for (int i = 0; i < 10; i++) {
      if (_beliefControllers[i].text.isNotEmpty) {
        beliefs.add({
          'time': '${i + 6}AM',
          'belief': _beliefControllers[i].text,
          'intensity': _intensityValues[i].toString(),
          'circumstance': _circumstanceControllers[i].text,
        });
      }
    }

    _saveTrackingData();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SessionDiaryPage(sessionNumber: 3),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadTrackingData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tracking Negative Beliefs')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Track your negative belief over time:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Note the intensity (0-10) and circumstances for each time period.',
            ),
            const SizedBox(height: 20),
            Table(
              border: TableBorder.all(color: Colors.black),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 10, 10, 10)),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Time',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Belief (0-10)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Intensity',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Circumstance',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < 10; i++)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${i + 6}AM'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _beliefControllers[i],
                          decoration: const InputDecoration(hintText: 'Belief'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slider(
                          value: _intensityValues[i],
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _intensityValues[i].toString(),
                          onChanged: (double value) {
                            setState(() {
                              _intensityValues[i] = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _circumstanceControllers[i],
                          decoration: const InputDecoration(
                            hintText: 'Circumstance',
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTracking,
              child: const Text('Submit Tracking'),
            ),
          ],
        ),
      ),
    );
  }
}
