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
      home: Session1Page(),
    );
  }
}

class Session1Page extends StatefulWidget {
  const Session1Page({super.key});

  @override
  _Session1PageState createState() => _Session1PageState();
}

class _Session1PageState extends State<Session1Page> {
  final TextEditingController _stressLevelController = TextEditingController();
  final TextEditingController _frustrationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _saveData() async {
    FirebaseFirestore.instance.collection('user_data').doc('user_id').set({
      'stress_level': _stressLevelController.text,
      'frustration': _frustrationController.text,
      'timestamp': FieldValue.serverTimestamp(),
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Data saved successfully!'),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save data: $error'),
      ));
    });
  }

  Future<void> _loadUserData() async {
    FirebaseFirestore.instance
        .collection('user_data')
        .doc('user_id')
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          _stressLevelController.text = snapshot['stress_level'] ?? '';
          _frustrationController.text = snapshot['frustration'] ?? '';
        });
      }
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load data: $error'),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text(
          'Session 1: Managing Stress',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Are you feeling stressed or frustrated?',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'In this session, we will help you assess the level of stress you might be experiencing. Answer the questions honestly to understand where you stand.',
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                _saveData();
                Navigator.pushNamed(context, '/session1_information');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Start Session 1',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
