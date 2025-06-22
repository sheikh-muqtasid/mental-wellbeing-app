import 'package:flutter/material.dart';
import 'user_data.dart';

class ConsentFormPage extends StatefulWidget {
  const ConsentFormPage({super.key});

  @override
  State<ConsentFormPage> createState() => _ConsentFormPageState();
}

class _ConsentFormPageState extends State<ConsentFormPage> {
  bool _consentGiven = false;

  void _handleSubmit() async {
    if (_consentGiven) {
      if (UserData.userId != null) {
        await UserData.updateConsent(true);
        Navigator.pushNamed(context, '/sessions');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must agree to proceed.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF81A8A1),
        title: const Text(
          'Consent Form',
          style: TextStyle(color: Color.fromARGB(255, 26, 25, 25)),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFB4D8B4),
              Color(0xFFFEF3E4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              const Text(
                'No personal information will be leaked. Please check the box to agree.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(height: 20),
              CheckboxListTile(
                title: const Text(
                  'I agree to the terms and conditions.',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                value: _consentGiven,
                onChanged: (value) {
                  setState(() {
                    _consentGiven = value!;
                  });
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _handleSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF6C9A7),
                  minimumSize: const Size(220, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 124, 113, 113),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
