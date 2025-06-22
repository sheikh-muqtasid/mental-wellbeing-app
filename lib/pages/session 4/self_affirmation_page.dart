import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../session_diary_page.dart';

class SelfAffirmationPage extends StatefulWidget {
  const SelfAffirmationPage({super.key});

  final List<String> affirmations = const [
    'I am more than this',
    'I can handle this',
    'I am capable',
    'I am beautiful',
  ];

  @override
  _SelfAffirmationPageState createState() => _SelfAffirmationPageState();
}

class _SelfAffirmationPageState extends State<SelfAffirmationPage> {
  final List<bool> _completedAffirmations = List.filled(4, false);

  Future<void> _loadAffirmationProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < widget.affirmations.length; i++) {
      _completedAffirmations[i] = prefs.getBool('affirmation$i') ?? false;
    }
    setState(() {});
  }

  Future<void> _saveAffirmationProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < widget.affirmations.length; i++) {
      prefs.setBool('affirmation$i', _completedAffirmations[i]);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Your progress has been saved!')),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadAffirmationProgress();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Self-Affirmation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Self-Affirmation Sentences:',
              style: TextStyle(
                fontSize: screenWidth > 600 ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4D6C6C),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Repeat these sentences three times a day to build resilience:',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(221, 10, 10, 10)),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < widget.affirmations.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Checkbox(
                      value: _completedAffirmations[i],
                      onChanged: (bool? value) {
                        setState(() {
                          _completedAffirmations[i] = value!;
                        });
                        _saveAffirmationProgress();
                      },
                      activeColor: const Color(0xFF4D6C6C),
                    ),
                    Expanded(
                      child: Text(
                        '- ${widget.affirmations[i]}',
                        style: TextStyle(
                          fontSize: screenWidth > 600 ? 18 : 16,
                          color: const Color(0xFF4D6C6C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SessionDiaryPage(sessionNumber: 4),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Go to Diary Page',
                style: TextStyle(
                  fontSize: screenWidth > 600 ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
