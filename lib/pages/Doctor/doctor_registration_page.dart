import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mental_wellbeing/pages/Doctor/doctor_home_page.dart'; // Import the home page

class DoctorRegistrationPage extends StatefulWidget {
  const DoctorRegistrationPage({super.key});

  @override
  State<DoctorRegistrationPage> createState() => _DoctorRegistrationPageState();
}

class _DoctorRegistrationPageState extends State<DoctorRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController();
  final _specialisationController = TextEditingController();
  final _slotController = TextEditingController();
  final _emailController = TextEditingController();
  final _bookingDetailsController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _languagesController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _certificationsController = TextEditingController();
  final _membershipsController = TextEditingController();
  final _patientReviewsController = TextEditingController();
  final _profilePictureController = TextEditingController();

  void _submitDoctorInfo() async {
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          await FirebaseFirestore.instance
              .collection('doctors')
              .doc(user.uid)
              .set({
            'name': _nameController.text,
            'contact': _contactController.text,
            'specialisation': _specialisationController.text,
            'available_slots': [_slotController.text],
            'email': _emailController.text,
            'bookingDetails': _bookingDetailsController.text,
            'qualification': _qualificationController.text,
            'experience': _experienceController.text,
            'languages_spoken': _languagesController.text,
            'insurance_accepted': _insuranceController.text,
            'certifications': _certificationsController.text,
            'memberships': _membershipsController.text,
            'patient_reviews': _patientReviewsController.text,
            'profile_picture': _profilePictureController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Doctor Info Saved Successfully')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DoctorHomePage()),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving data: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Registration')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Doctor Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration:
                      const InputDecoration(labelText: 'Contact Number'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your contact number'
                      : null,
                ),
                TextFormField(
                  controller: _specialisationController,
                  decoration:
                      const InputDecoration(labelText: 'Specialisation'),
                  validator: (value) => value!.isEmpty
                      ? 'Please enter your specialisation'
                      : null,
                ),
                TextFormField(
                  controller: _slotController,
                  decoration: const InputDecoration(
                      labelText: 'Available Slot (e.g. 10:00 AM)'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an available slot' : null,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your email' : null,
                ),
                TextFormField(
                  controller: _bookingDetailsController,
                  decoration:
                      const InputDecoration(labelText: 'Booking Details'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter booking details' : null,
                ),
                TextFormField(
                  controller: _qualificationController,
                  decoration:
                      const InputDecoration(labelText: 'Qualifications'),
                ),
                TextFormField(
                  controller: _experienceController,
                  decoration:
                      const InputDecoration(labelText: 'Years of Experience'),
                ),
                TextFormField(
                  controller: _languagesController,
                  decoration:
                      const InputDecoration(labelText: 'Languages Spoken'),
                ),
                TextFormField(
                  controller: _insuranceController,
                  decoration:
                      const InputDecoration(labelText: 'Insurance Accepted'),
                ),
                TextFormField(
                  controller: _certificationsController,
                  decoration:
                      const InputDecoration(labelText: 'Certifications'),
                ),
                TextFormField(
                  controller: _membershipsController,
                  decoration: const InputDecoration(
                      labelText: 'Professional Memberships'),
                ),
                TextFormField(
                  controller: _patientReviewsController,
                  decoration:
                      const InputDecoration(labelText: 'Patient Reviews'),
                ),
                TextFormField(
                  controller: _profilePictureController,
                  decoration:
                      const InputDecoration(labelText: 'Profile Picture URL'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitDoctorInfo,
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
