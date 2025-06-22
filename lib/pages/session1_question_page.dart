import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Session1QuestionPage extends StatefulWidget {
  const Session1QuestionPage({super.key});

  @override
  State<Session1QuestionPage> createState() => _Session1QuestionPageState();
}

class _Session1QuestionPageState extends State<Session1QuestionPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> _controllers = [];
  List<Map<String, dynamic>> _questions = [];
  bool _isLoading = true;
  bool _showRetryButton = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchQuestions() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('session1_questions')
          .get();

      final documents = querySnapshot.docs;
      documents.sort((a, b) {
        try {
          final numA = int.parse(a.id.substring(1));
          final numB = int.parse(b.id.substring(1));
          return numA.compareTo(numB);
        } catch (_) {
          return a.id.compareTo(b.id);
        }
      });

      final validQuestions = documents
          .where((doc) =>
              doc.data().containsKey('text') &&
              (doc.data()['text'] as String).isNotEmpty)
          .map((doc) => {'id': doc.id, 'text': doc.data()['text']})
          .toList();

      if (validQuestions.isEmpty) {
        setState(() {
          _errorMessage = 'No valid questions found.';
          _isLoading = false;
          _showRetryButton = true;
        });
        return;
      }

      setState(() {
        _questions = validQuestions;
        _controllers.addAll(List.generate(
            validQuestions.length, (index) => TextEditingController()));
        _isLoading = false;
        _errorMessage = null;
        _showRetryButton = false;
      });

      _loadData();
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load questions.';
        _isLoading = false;
        _showRetryButton = true;
      });
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _controllers.length; i++) {
      final key = 'question_${_questions[i]['id']}';
      _controllers[i].text = prefs.getString(key) ?? '';
    }
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 0; i < _controllers.length; i++) {
      final key = 'question_${_questions[i]['id']}';
      await prefs.setString(key, _controllers[i].text);
    }
  }

  void _handleNextPage(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    int totalScore = _controllers.fold(
        0, (sum, ctrl) => sum + (int.tryParse(ctrl.text) ?? 0));
    final stressLevel = _calculateStressLevel(totalScore);
    await _saveData();

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Your Stress Level'),
        content: Text(
            'Your total score is $totalScore.\n\nYou are experiencing **$stressLevel**.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sessions');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _calculateStressLevel(int score) {
    if (score <= 20) return 'Low Stress';
    if (score <= 40) return 'Moderate Stress';
    if (score <= 60) return 'High Stress';
    return 'Invalid Score';
  }

  Widget _buildQuestionField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFF2D2D2D),
          labelStyle: const TextStyle(color: Colors.white),
          errorStyle: const TextStyle(color: Colors.redAccent),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]$|^10$')),
          LengthLimitingTextInputFormatter(2),
        ],
        style: const TextStyle(color: Colors.white),
        validator: (value) {
          final num = int.tryParse(value ?? '');
          if (num == null || num < 0 || num > 10) {
            return 'Enter 0 to 10';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('Stress Questions',
            style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF4D6C6C),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double maxWidth =
              constraints.maxWidth > 700 ? 700 : constraints.maxWidth * 0.95;

          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_errorMessage ?? 'No questions found',
                      style: const TextStyle(color: Colors.white)),
                  if (_showRetryButton)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                            _errorMessage = null;
                          });
                          _fetchQuestions();
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4D6C6C)),
                        child: const Text('Try Again'),
                      ),
                    )
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Stress Scale (Rate out of 10):',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 20),
                      ..._questions.map((q) {
                        final index = _questions.indexOf(q);
                        return _buildQuestionField(
                            _controllers[index], q['text']);
                      }),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _handleNextPage(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB17A6E),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
