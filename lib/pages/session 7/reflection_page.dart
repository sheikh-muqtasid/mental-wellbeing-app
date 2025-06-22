import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../session_diary_page.dart';

class ReflectionPage extends StatefulWidget {
  const ReflectionPage({super.key});

  @override
  State<ReflectionPage> createState() => _ReflectionPageState();
}

class _ReflectionPageState extends State<ReflectionPage> {
  final TextEditingController _learningsController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();

  // Load saved reflection data from SharedPreferences
  Future<void> _loadReflectionData() async {
    final prefs = await SharedPreferences.getInstance();
    _learningsController.text = prefs.getString('learnings') ?? '';
    _usageController.text = prefs.getString('usage') ?? '';
  }

  // Save reflection data to SharedPreferences
  Future<void> _saveReflectionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('learnings', _learningsController.text);
    await prefs.setString('usage', _usageController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection saved successfully!')),
    );
  }

  // Submit reflection data and navigate to the next page
  void _submitReflection() {
    if (_learningsController.text.isNotEmpty &&
        _usageController.text.isNotEmpty) {
      // Save the reflections locally
      _saveReflectionData();

      // Print reflection to console in debug mode
      if (kDebugMode) {
        print(
            'Reflection Saved: ${_learningsController.text}, ${_usageController.text}');
      }

      // Navigate to Session 7 Diary page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SessionDiaryPage(sessionNumber: 7),
        ),
      );
    } else {
      // Show a message if both fields are not filled
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please fill in both fields before submitting.")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _loadReflectionData(); // Load saved reflection data when the page is initialized
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reflection and Future Planning',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4D6C6C), // Main color: muted green
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reflection:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6C6C),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'What have you learned from all these activities?',
              style:
                  TextStyle(fontSize: 16, color: Color.fromARGB(221, 7, 7, 7)),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _learningsController,
              decoration: const InputDecoration(
                hintText: 'Enter your learnings here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            const Text(
              'How to use the learnings?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6C6C),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _usageController,
              decoration: const InputDecoration(
                hintText: 'Enter how you plan to use these learnings...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitReflection,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Submit Reflection',
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
