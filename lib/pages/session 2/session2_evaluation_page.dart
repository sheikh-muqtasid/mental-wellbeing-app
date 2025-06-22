import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session2EvaluationPage extends StatefulWidget {
  const Session2EvaluationPage({super.key});

  @override
  State<Session2EvaluationPage> createState() => _Session2EvaluationPageState();
}

class _Session2EvaluationPageState extends State<Session2EvaluationPage> {
  final TextEditingController _evaluationController = TextEditingController();
  bool _isSaving = false;
  bool _isProcessing = false;

  // Session 2 specific motivational message
  final String _motivationMessage =
      "Every step you take brings you closer to your goal. "
      "Recognize your progress, no matter how small!";

  @override
  void initState() {
    super.initState();
    _loadSavedEvaluation();
  }

  Future<void> _loadSavedEvaluation() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _evaluationController.text =
            prefs.getString('session2_evaluation') ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading saved evaluation: $e')),
      );
    }
  }

  Future<void> _saveEvaluation() async {
    if (_evaluationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your evaluation before saving!')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('session2_evaluation', _evaluationController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Evaluation saved successfully!')),
      );

      // Navigate to diary page after saving
      Navigator.pushNamed(context, '/session1_diary');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save evaluation: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _proceedWithTaskEvaluation() async {
    setState(() => _isProcessing = true);
    try {
      // Add any task evaluation processing logic here
      await Future.delayed(const Duration(milliseconds: 300));

      // Navigate to sessions page
      Navigator.pushNamed(context, '/sessions');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error processing evaluation: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final isPortrait = screenSize.height > screenSize.width;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          'Session 2: Task Evaluation',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
          ),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 16 : constraints.maxWidth * 0.1,
                vertical: 16,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Motivation Card
                      _buildMotivationCard(isSmallScreen),
                      const SizedBox(height: 24),

                      // Evaluation Title and Instructions
                      _buildEvaluationHeader(isSmallScreen),
                      const SizedBox(height: 16),

                      // Evaluation Text Field
                      Expanded(
                        child: _buildEvaluationTextField(),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      _buildActionButtons(isSmallScreen, isPortrait),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMotivationCard(bool isSmallScreen) {
    return Card(
      color: const Color(0xFF2D2D2D),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(
              Icons.emoji_objects,
              size: 32,
              color: Color(0xFFB17A6E),
            ),
            const SizedBox(height: 8),
            Text(
              'Today\'s Motivation',
              style: TextStyle(
                fontSize: isSmallScreen ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _motivationMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationHeader(bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Evaluation',
          style: TextStyle(
            fontSize: isSmallScreen ? 22 : 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Please evaluate the status of your tasks after three days:',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 18,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildEvaluationTextField() {
    return TextField(
      controller: _evaluationController,
      decoration: InputDecoration(
        hintText: 'Describe your progress, challenges, and insights...',
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF2D2D2D),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
      style: const TextStyle(color: Colors.white),
      maxLines: null,
      expands: true,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _buildActionButtons(bool isSmallScreen, bool isPortrait) {
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: Size(double.infinity, isSmallScreen ? 50 : 56),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
    );

    if (isPortrait) {
      return Column(
        children: [
          ElevatedButton(
            onPressed: _isSaving ? null : _saveEvaluation,
            style: buttonStyle.copyWith(
              backgroundColor: WidgetStateProperty.all(const Color(0xFFB17A6E)),
            ),
            child: _isSaving
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Save to Diary',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _isProcessing ? null : _proceedWithTaskEvaluation,
            style: buttonStyle.copyWith(
              backgroundColor: WidgetStateProperty.all(const Color(0xFF4D6C6C)),
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Continue to Sessions',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: _isSaving ? null : _saveEvaluation,
              style: buttonStyle.copyWith(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFFB17A6E)),
              ),
              child: _isSaving
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Save to Diary',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _isProcessing ? null : _proceedWithTaskEvaluation,
              style: buttonStyle.copyWith(
                backgroundColor:
                    WidgetStateProperty.all(const Color(0xFF4D6C6C)),
              ),
              child: _isProcessing
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      'Continue to Sessions',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ],
      );
    }
  }
}
