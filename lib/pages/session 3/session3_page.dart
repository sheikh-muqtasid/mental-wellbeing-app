import 'package:flutter/material.dart';

class Session3Page extends StatelessWidget {
  const Session3Page({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Session 3: Positive Thinking',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
        elevation: 6.0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
          children: [
            const Text(
              'Tracking Negative Beliefs:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Track a negative belief throughout the day and note its intensity and circumstances.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/tracking');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'Start Tracking',
                style: TextStyle(
                  fontSize: screenWidth > 600 ? 20 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
