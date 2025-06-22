import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session4Page extends StatefulWidget {
  const Session4Page({super.key});

  @override
  _Session4PageState createState() => _Session4PageState();
}

class _Session4PageState extends State<Session4Page> {
  bool _isAffirmationCompleted = false;

  Future<void> _loadAffirmationProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isAffirmationCompleted = prefs.getBool('affirmationCompleted') ?? false;
    });
  }

  Future<void> _saveAffirmationProgress() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('affirmationCompleted', _isAffirmationCompleted);
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
          'Session 4: Building Resilience',
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
              'Self-Affirmation:',
              style: TextStyle(
                fontSize: screenWidth > 600 ? 22 : 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4D6C6C),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Repeat self-affirmation sentences three times a day.',
              style: TextStyle(
                  fontSize: screenWidth > 600 ? 18 : 16,
                  color: const Color.fromARGB(221, 15, 15, 15)),
            ),
            const SizedBox(height: 20),
            _isAffirmationCompleted
                ? const Text(
                    'You have completed your affirmations for today!',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  )
                : const Text(
                    'You have not completed your affirmations for today.',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isAffirmationCompleted = true;
                });
                _saveAffirmationProgress();

                Navigator.pushNamed(context, '/self_affirmation');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                _isAffirmationCompleted
                    ? 'Start Affirmation'
                    : 'Start Affirmation',
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
