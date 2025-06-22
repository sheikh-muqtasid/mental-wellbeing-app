import 'package:flutter/material.dart';
import '../session_diary_page.dart';

class GroundingExercisePage extends StatefulWidget {
  const GroundingExercisePage({super.key});

  @override
  _GroundingExercisePageState createState() => _GroundingExercisePageState();
}

class _GroundingExercisePageState extends State<GroundingExercisePage> {
  final List<TextEditingController> _copingControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );

  final List<bool> _isCompleted = List.filled(5, false);

  Widget _buildBox(
      String stepNumber,
      String description,
      TextEditingController controller,
      bool isCompleted,
      ValueChanged<bool?> onChanged) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepNumber,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4D6C6C),
            ),
          ),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter your response...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: isCompleted,
                onChanged: onChanged,
                activeColor: Color(0xFF4D6C6C),
              ),
              const Text('Completed', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Grounding Exercise',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF4D6C6C),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth > 600 ? 24.0 : 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mindfulness Practicing: Grounding',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4D6C6C),
              ),
            ),
            const SizedBox(height: 20),
            for (int i = 0; i < 5; i++)
              _buildBox(
                'Step ${5 - i}:',
                [
                  'Name five things that you can see around you.',
                  'Name four things that you can touch around you.',
                  'Name three things you can hear around you.',
                  'Name two things around you that you can smell.',
                  'Name one thing around you that you can taste.'
                ][i],
                _copingControllers[i],
                _isCompleted[i],
                (bool? value) {
                  setState(() {
                    _isCompleted[i] = value!;
                  });
                },
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const SessionDiaryPage(sessionNumber: 6),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB17A6E),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Go to Diary Page',
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
