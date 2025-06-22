import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';

class ScheduleSessionPage extends StatefulWidget {
  const ScheduleSessionPage({super.key});

  @override
  State<ScheduleSessionPage> createState() => _ScheduleSessionPageState();
}

class _ScheduleSessionPageState extends State<ScheduleSessionPage> {
  String? selectedDoctor;
  String? selectedSlot;
  String? doctorId;

  void _viewDoctorDetails(DocumentSnapshot doctor) {
    setState(() {
      selectedDoctor = doctor['name'];
      doctorId = doctor.id;
      selectedSlot = null;
    });
  }

  Future<void> _makeCall(String contact) async {
    // Sanitize phone number by removing spaces and other non-digit chars
    final sanitizedNumber = contact.replaceAll(RegExp(r'[^0-9+]'), '');
    final Uri phoneUri = Uri(scheme: 'tel', path: sanitizedNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open dialer for $sanitizedNumber')),
      );
    }
  }

  Future<void> _sendEmail(String email) async {
    // Open Gmail compose window for specific email
    final Uri gmailUri =
        Uri.parse('https://mail.google.com/mail/?view=cm&fs=1&to=$email');

    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open Gmail compose for $email')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Schedule Session')),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text('Error loading data.'));
            }

            final doctors = snapshot.data?.docs ?? [];
            if (doctors.isEmpty) {
              return const Center(child: Text('No doctors available.'));
            }

            return Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: doctors.length,
                  itemBuilder: (context, index) {
                    final doctor = doctors[index];
                    final doctorName = doctor['name'] ?? 'No name available';

                    return ListTile(
                      title: Text(doctorName),
                      onTap: () => _viewDoctorDetails(doctor),
                    );
                  },
                ),
                if (selectedDoctor != null) ...[
                  Card(
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Doctor: $selectedDoctor',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Divider(),
                          ListTile(
                            title: Text(
                                'Specialisation: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['specialisation'] ?? 'N/A'}'),
                          ),
                          ListTile(
                            title: Text(
                                'Contact: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['contact'] ?? 'N/A'}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () {
                                final contact = doctors.firstWhere((doc) =>
                                    doc['name'] == selectedDoctor)['contact'];
                                if (contact != null && contact.isNotEmpty) {
                                  _makeCall(contact);
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                                'Email: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['email'] ?? 'N/A'}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.email),
                              onPressed: () {
                                final email = doctors.firstWhere((doc) =>
                                    doc['name'] == selectedDoctor)['email'];
                                if (email != null && email.isNotEmpty) {
                                  _sendEmail(email);
                                }
                              },
                            ),
                          ),
                          ListTile(
                            title: Text(
                                'Qualifications: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['qualification'] ?? 'N/A'}'),
                          ),
                          ListTile(
                            title: Text(
                                'Experience: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['experience'] ?? 'N/A'} years'),
                          ),
                          ListTile(
                            title: Text(
                                'Languages Spoken: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['languages_spoken'] ?? 'N/A'}'),
                          ),
                          ListTile(
                            title: Text(
                                'Insurance Accepted: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['insurance_accepted'] ?? 'N/A'}'),
                          ),
                          ListTile(
                            title: Text(
                                'Certifications: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['certifications'] ?? 'N/A'}'),
                          ),
                          ListTile(
                            title: Text(
                                'Memberships: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['memberships'] ?? 'N/A'}'),
                          ),
                          ListTile(
                            title: Text(
                                'Patient Reviews: ${doctors.firstWhere((doc) => doc['name'] == selectedDoctor)['patient_reviews'] ?? 'N/A'}'),
                          ),
                          const Divider(),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            );
          },
        ),
      ),
      floatingActionButton: selectedSlot == null
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final patientId = FirebaseAuth.instance.currentUser!.uid;

                await FirebaseFirestore.instance.collection('sessions').add({
                  'doctorName': selectedDoctor,
                  'slot': selectedSlot,
                  'patientId': patientId,
                  'doctorId': doctorId,
                  'status': 'scheduled',
                  'timestamp': FieldValue.serverTimestamp(),
                });
              },
              child: const Icon(Icons.check),
            ),
    );
  }
}
