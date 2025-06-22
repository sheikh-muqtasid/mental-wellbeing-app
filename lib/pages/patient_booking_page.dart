import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PatientBookingPage extends StatefulWidget {
  const PatientBookingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PatientBookingPageState createState() => _PatientBookingPageState();
}

class _PatientBookingPageState extends State<PatientBookingPage> {
  String? _selectedDoctor;
  String? _selectedSlot;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF81A8A1),
        title:
            const Text('Book a Session', style: TextStyle(color: Colors.white)),
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
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('doctors').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Something went wrong.'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No doctors available.'));
            }

            List<Doctor> doctors = snapshot.data!.docs.map((doc) {
              return Doctor.fromFirestore(doc);
            }).toList();

            return ListView.builder(
              itemCount: doctors.length,
              itemBuilder: (context, index) {
                Doctor doctor = doctors[index];
                return Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(doctor.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text('Specialization: ${doctor.specialization}'),
                    onTap: () async {
                      _selectedDoctor = doctor.name;
                      _selectedSlot = await _selectSlot(doctor.slots);
                      setState(() {});
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
      bottomSheet: _selectedDoctor == null
          ? const SizedBox.shrink()
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance.collection('sessions').add({
                    'doctor': _selectedDoctor,
                    'slot': _selectedSlot,
                    'patient': 'Patient Name',
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Session booked!')));
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color(0xFFF6C9A7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 10,
                ),
                child:
                    const Text('Book Session', style: TextStyle(fontSize: 18)),
              ),
            ),
    );
  }

  Future<String?> _selectSlot(List<String> slots) async {
    String? selectedSlot;
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Slot'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: slots.map((slot) {
              return ListTile(
                title: Text(slot),
                onTap: () {
                  selectedSlot = slot;
                  Navigator.pop(context, selectedSlot);
                },
              );
            }).toList(),
          ),
        );
      },
    );
    return selectedSlot;
  }
}

class Doctor {
  final String name;
  final String specialization;
  final List<String> slots;

  Doctor({
    required this.name,
    required this.specialization,
    required this.slots,
  });

  factory Doctor.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Doctor(
      name: data['name'],
      specialization: data['specialization'],
      slots: List<String>.from(data['slots']),
    );
  }
}
