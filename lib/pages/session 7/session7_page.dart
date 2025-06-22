import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session7Page extends StatefulWidget {
  const Session7Page({super.key});

  @override
  _Session7PageState createState() => _Session7PageState();
}

class _Session7PageState extends State<Session7Page> {
  final TextEditingController _learningsController = TextEditingController();
  final TextEditingController _usageController = TextEditingController();

  Future<void> _loadReflectionData() async {
    final prefs = await SharedPreferences.getInstance();
    _learningsController.text = prefs.getString('learnings') ?? '';
    _usageController.text = prefs.getString('usage') ?? '';
  }

  Future<void> _saveReflectionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('learnings', _learningsController.text);
    await prefs.setString('usage', _usageController.text);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reflection saved successfully!')),
    );
  }

  void _startReflection() {
    _saveReflectionData();
    Navigator.pushNamed(context, '/reflection');
  }

  @override
  void initState() {
    super.initState();
    _loadReflectionData();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Session 7: Reflection and Future Planning',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
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
              'Reflect on what you have learned from all the activities and how to use these learnings.',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(179, 26, 25, 25)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startReflection,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Reflection',
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
