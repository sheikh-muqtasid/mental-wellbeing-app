import 'package:flutter/material.dart';
import 'package:mental_wellbeing/pages/session_diary_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session5Page extends StatefulWidget {
  const Session5Page({super.key});

  @override
  _Session5PageState createState() => _Session5PageState();
}

class _Session5PageState extends State<Session5Page> {
  final List<TextEditingController> _copingControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  final List<bool> _isPositive = List.filled(5, false);

  Future<void> _loadCopingMechanisms() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      _copingControllers[i].text = prefs.getString('copingMechanism$i') ?? '';
      _isPositive[i] = prefs.getBool('isPositive$i') ?? false;
    }
    setState(() {});
  }

  Future<void> _saveCopingMechanisms() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      prefs.setString('copingMechanism$i', _copingControllers[i].text);
      prefs.setBool('isPositive$i', _isPositive[i]);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coping mechanisms saved successfully!')),
    );
  }

  void _submitAndNavigate() {
    // Save data first
    _saveCopingMechanisms();

    // Then navigate to diary page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SessionDiaryPage(sessionNumber: 5),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCopingMechanisms();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Session 5: Coping Mechanisms',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
          children: [
            const Text(
              'Coping Mechanisms:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6C6C),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'List the ways you handle stress and evaluate them as positive or negative.',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(134, 14, 13, 13)),
            ),
            const SizedBox(height: 20),
            Table(
              border:
                  TableBorder.all(color: const Color.fromARGB(255, 27, 27, 27)),
              columnWidths: {
                0: FlexColumnWidth(screenWidth > 600 ? 1 : 0.8),
                1: FlexColumnWidth(screenWidth > 600 ? 2 : 1),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 226, 225, 225)),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'No.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Coping Mechanism',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < 5; i++)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${i + 1}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _copingControllers[i],
                          decoration: const InputDecoration(
                            hintText: 'Enter coping mechanism',
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Mark each as positive or negative:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6C6C),
              ),
            ),
            const SizedBox(height: 10),
            Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: {
                0: FlexColumnWidth(screenWidth > 600 ? 1 : 0.8),
                1: FlexColumnWidth(screenWidth > 600 ? 1 : 0.8),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 214, 212, 212)),
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Positive',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Negative',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                for (int i = 0; i < 5; i++)
                  TableRow(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Checkbox(
                          value: _isPositive[i],
                          onChanged: (bool? value) {
                            setState(() {
                              _isPositive[i] = value!;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Checkbox(
                          value: !_isPositive[i],
                          onChanged: (bool? value) {
                            setState(() {
                              _isPositive[i] = !value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitAndNavigate,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Submit and Go to Diary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
