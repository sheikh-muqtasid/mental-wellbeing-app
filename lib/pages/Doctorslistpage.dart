import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Doctors'),
        backgroundColor: Color(0xFF81A8A1),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data.'));
          }

          final doctors = snapshot.data?.docs ?? [];

          return ListView.builder(
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              final doctorName = doctor['name'];
              final doctorSpecialization = doctor['specialization'];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(doctorName),
                  subtitle: Text('Specialization: $doctorSpecialization'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/doctorDetail',
                      arguments: doctor,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
