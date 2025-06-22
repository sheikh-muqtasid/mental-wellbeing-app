import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session6Page extends StatefulWidget {
  const Session6Page({super.key});

  @override
  _Session6PageState createState() => _Session6PageState();
}

class _Session6PageState extends State<Session6Page> {
  final List<TextEditingController> _responseControllers =
      List.generate(5, (index) => TextEditingController());

  Future<void> _loadResponses() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      _responseControllers[i].text = prefs.getString('response$i') ?? '';
    }
  }

  Future<void> _saveResponses() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < 5; i++) {
      prefs.setString('response$i', _responseControllers[i].text);
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Responses saved successfully!')));
  }

  @override
  void initState() {
    super.initState();
    _loadResponses();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Session 6: Mindfulness Practices',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
          children: [
            const Text(
              'Grounding Exercise:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6C6C),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Name things you can see, hear, touch, smell, and taste around you.',
              style:
                  TextStyle(fontSize: 16, color: Color.fromARGB(221, 8, 8, 8)),
            ),
            ElevatedButton(
              onPressed: () {
                _saveResponses();
                Navigator.pushNamed(context, '/grounding_exercise');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Start Grounding',
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
