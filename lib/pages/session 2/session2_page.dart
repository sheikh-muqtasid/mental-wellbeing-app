import 'package:flutter/material.dart';

class Session2Page extends StatelessWidget {
  const Session2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background color
      appBar: AppBar(
        title: const Text(
          'Session 2: Healthy Routines',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white), // White text for app bar
        ),
        backgroundColor: const Color(0xFF4D6C6C), // Main color: muted green
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section title with light text for readability
            const Text(
              'Daily Routine Log:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Light text on dark background
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Make a list of activities that you have to complete in the next three days.',
              style: TextStyle(
                  fontSize: 16, color: Colors.white70), // Slightly lighter text
            ),
            const SizedBox(height: 20),

            // Button to navigate to task logging page
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/task_logging');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                    0xFFB17A6E), // Accent color: soft brownish-orange
                minimumSize:
                    const Size(double.infinity, 50), // Full-width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Rounded corners
                ),
              ),
              child: const Text(
                'Start Logging',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white), // White text on button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
