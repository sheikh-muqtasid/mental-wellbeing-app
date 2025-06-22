import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import 'sessions_page.dart';

class SessionDiaryPage extends StatefulWidget {
  final int sessionNumber;

  const SessionDiaryPage({super.key, required this.sessionNumber});

  @override
  SessionDiaryPageState createState() => SessionDiaryPageState();
}

class SessionDiaryPageState extends State<SessionDiaryPage> {
  final TextEditingController _diaryController = TextEditingController();
  String? _existingDiaryEntry;
  final Logger _logger = Logger();

  final List<String> _motivationalMessages = [
    'You are stronger than you think. Keep pushing forward!',
    'Every step you take brings you closer to your goal.',
    'Stay positive, work hard, and make it happen!',
    'Believe in yourself. You are capable of amazing things.',
    'Keep going. You are making progress every day!',
    'Your effort today will pay off tomorrow. Stay focused.',
    'Don’t give up. Great things take time and patience.'
  ];

  @override
  void initState() {
    super.initState();
  }

  void _loadDiaryEntry() async {
    String? diaryEntry =
        await _getDiaryEntryFromFirestore(widget.sessionNumber);
    if (diaryEntry != null) {
      _diaryController.text = diaryEntry;
      setState(() {
        _existingDiaryEntry = diaryEntry;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _loadDiaryEntry();
  }

  Future<String?> _getDiaryEntryFromFirestore(int sessionNumber) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('diaryEntries')
          .doc('userId')
          .collection('sessions')
          .doc(sessionNumber.toString())
          .get();
      if (snapshot.exists) {
        return snapshot['text'];
      }
      return null;
    } catch (e) {
      _logger.e('Error fetching diary entry: $e');
      return null;
    }
  }

  // Save diary entry to Firestore
  Future<void> _saveDiaryEntry() async {
    try {
      await FirebaseFirestore.instance
          .collection('diaryEntries')
          .doc('userId')
          .collection('sessions')
          .doc(widget.sessionNumber.toString())
          .set({
        'text': _diaryController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
      _navigateToSessionsPage();
    } catch (e) {
      _logger.e('Error saving diary entry: $e');
    }
  }

  Future<void> _deleteDiaryEntry() async {
    try {
      await FirebaseFirestore.instance
          .collection('diaryEntries')
          .doc('userId')
          .collection('sessions')
          .doc(widget.sessionNumber.toString())
          .delete();
      _navigateToSessionsPage();
    } catch (e) {
      _logger.e('Error deleting diary entry: $e');
    }
  }

  void _navigateToSessionsPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SessionsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Session ${widget.sessionNumber} Diary'),
        backgroundColor: const Color(0xFF2F4F4F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              _motivationalMessages[widget.sessionNumber - 1],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B2F1D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _diaryController,
              decoration: InputDecoration(
                hintText: 'Write about your experience in this session...',
                filled: true,
                fillColor: const Color(0xFFF2F1E1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              maxLines: 8,
              style: const TextStyle(fontSize: 16, color: Color(0xFF4B2F1D)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveDiaryEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDE8C55),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              child: const Text('Save Diary'),
            ),
            const SizedBox(height: 20),
            if (_existingDiaryEntry != null)
              ElevatedButton(
                onPressed: _deleteDiaryEntry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9E9E9E),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Delete Diary'),
              ),
          ],
        ),
      ),
    );
  }
}
