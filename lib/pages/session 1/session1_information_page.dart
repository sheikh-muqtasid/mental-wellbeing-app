import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stress Management App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => Session1InformationPage(),
        '/diary': (context) => DiaryPage(),
      },
    );
  }
}

class DiaryPage extends StatelessWidget {
  const DiaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'My Diary',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF4D6C6C),
      ),
      body: Center(
        child: Text(
          'Your journal entries will appear here',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

class Session1InformationPage extends StatefulWidget {
  const Session1InformationPage({super.key});

  @override
  _Session1InformationPageState createState() =>
      _Session1InformationPageState();
}

class _Session1InformationPageState extends State<Session1InformationPage> {
  final TextEditingController _journalController = TextEditingController();

  TableRow _buildTableRow(List<String> columns) {
    return TableRow(
      children: columns
          .map(
            (column) => Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                column,
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
          .toList(),
    );
  }

  Future<void> _loadJournal() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection('stress_journals')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        setState(() {
          _journalController.text = doc['journal_text'] ?? '';
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading journal: $e')),
      );
    }
  }

  Future<void> _saveJournal() async {
    if (_journalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something before saving!')),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('stress_journals').add({
        'journal_text': _journalController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Journal saved successfully!')),
      );

      Navigator.pushNamed(context, '/session1_diary');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save journal: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadJournal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Stress Management Information',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Color(0xFF4D6C6C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Managing Stress: ',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              color: Color(0xFF2D2D2D),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Stress is the feeling of being overwhelmed or under pressure, often caused by demanding situations or challenges that make you feel tense, anxious, or worried. Stress can be both positive and negative (distress).',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stress vs. Distress:',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              color: Color(0xFF2D2D2D),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Table(
                border: TableBorder.all(color: Colors.white.withOpacity(0.5)),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                },
                children: [
                  _buildTableRow(['Stress', 'Distress']),
                  _buildTableRow([
                    'A normal reaction to environmental or internal stimuli that can be helpful in some cases. For example, stress can motivate you to be more productive and adaptable.',
                    'Distress, on the other hand, specifically refers to negative stress that can have a harmful impact on your well-being and overall health.'
                  ])
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              '5 A s of Stress Management:',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              color: Color(0xFF2D2D2D),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Table(
                border: TableBorder.all(color: Colors.white.withOpacity(0.5)),
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(4),
                },
                children: [
                  _buildTableRow(['A', 'Description']),
                  _buildTableRow([
                    '1. Alter',
                    'Identify situations that can be changed to minimize stress. Adjust your schedule to create a balance between work, family, and personal time.'
                  ]),
                  _buildTableRow([
                    '2. Adapt',
                    'Acknowledge that changes and unexpected events can happen. Take a deep breath, stay calm, and adjust to the situation.'
                  ]),
                  _buildTableRow([
                    '3. Avoid',
                    'Recognize avoidable stress triggers and take control of your environment to reduce stress levels.'
                  ]),
                  _buildTableRow([
                    '4. Accept',
                    'Embrace mindfulness and accept that stress is a part of life. Focus on what you can control and let go of what you cannot.'
                  ]),
                  _buildTableRow([
                    '5. Active',
                    'Engage in physical and mental activities to keep your brain and body active. Exercise regularly to improve memory, mood, and sleep while reducing stress and anxiety.'
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Stress Journal:',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Write about what you are stressed about and how you are handling it. Reflect on the stress management techniques you will use to cope.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _journalController,
              maxLines: 8,
              decoration: InputDecoration(
                hintText: 'Write your stress journal here...',
                filled: true,
                fillColor: Color(0xFF2D2D2D),
                hintStyle: const TextStyle(color: Colors.white60),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.5), width: 1),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveJournal,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Save Journal',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
