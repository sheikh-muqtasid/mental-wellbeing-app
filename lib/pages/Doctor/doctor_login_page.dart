import 'package:flutter/material.dart';
import '../../models/firebase_service.dart';
import 'doctor_registration_page.dart';
import 'doctor_home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorLoginPage extends StatelessWidget {
  const DoctorLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF81A8A1),
        title: const Text(
          'Doctor Login',
          style: TextStyle(color: Colors.white),
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
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        await FirebaseService.signInWithGoogleDoctor(context);
                    if (user != null) {
                      final doctorId = FirebaseAuth.instance.currentUser!.uid;
                      final doctorDoc = await FirebaseFirestore.instance
                          .collection('doctors')
                          .doc(doctorId)
                          .get();

                      if (doctorDoc.exists && doctorDoc.data() != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DoctorHomePage()),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DoctorRegistrationPage()),
                        );
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
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
