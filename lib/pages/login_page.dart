import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/firebase_service.dart';
import 'user_data.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF81A8A1),
        title:
            const Text('Patient Login', style: TextStyle(color: Colors.white)),
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign in with Google to continue',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF4F5B5A),
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  final user =
                      await FirebaseService.signInWithGooglePatient(context);
                  if (user != null) {
                    await UserData.initialize();
                    final doc = await FirebaseFirestore.instance
                        .collection('patients')
                        .doc(user.uid)
                        .get();
                    if (doc.exists && doc.data()?['demographics'] != null) {
                      Navigator.pushReplacementNamed(context, '/user_home');
                    } else {
                      Navigator.pushReplacementNamed(context, '/demographics');
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF6C9A7),
                  minimumSize: const Size(220, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/google_logo.png', height: 24),
                    const SizedBox(width: 10),
                    const Text(
                      'Sign in with Google',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
