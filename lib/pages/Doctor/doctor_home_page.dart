import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'doctor_info_page.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String doctorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          Column(
            children: [
              AppBar(
                backgroundColor: Color(0xFF81A8A1),
                title: const Text(
                  'Doctor Dashboard',
                  style: TextStyle(color: Color.fromARGB(255, 51, 45, 45)),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.logout,
                        color: Color.fromARGB(255, 41, 36, 36)),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacementNamed(context, '/welcome');
                    },
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('doctors')
                            .doc(doctorId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || !snapshot.data!.exists) {
                            return const Center(
                                child: Text("No data found for this doctor."));
                          }

                          final doctorData =
                              snapshot.data!.data() as Map<String, dynamic>;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Name: ${doctorData['name'] ?? 'N/A'}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Email: ${doctorData['email'] ?? 'N/A'}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Booking Details: ${doctorData['bookingDetails'] ?? 'N/A'}",
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                              const SizedBox(height: 20),
                            ],
                          );
                        },
                      ),
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: const Text('Schedule Session'),
                          subtitle:
                              const Text('Schedule sessions with patients'),
                          leading: const Icon(Icons.calendar_today),
                          onTap: () {
                            Navigator.pushNamed(context, '/schedule_session');
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: const Text('My Information'),
                          subtitle:
                              const Text('View and update your information'),
                          leading: const Icon(Icons.person),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const DoctorInfoPage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
