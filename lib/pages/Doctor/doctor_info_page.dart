import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorInfoPage extends StatefulWidget {
  const DoctorInfoPage({super.key});

  @override
  State<DoctorInfoPage> createState() => _DoctorInfoPageState();
}

class _DoctorInfoPageState extends State<DoctorInfoPage> {
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

  @override
  void initState() {
    super.initState();
    _loadDoctorData();
  }

  void _loadDoctorData() async {
    final doctorId = FirebaseAuth.instance.currentUser!.uid;
    final doctorDoc = await FirebaseFirestore.instance
        .collection('doctors')
        .doc(doctorId)
        .get();

    if (doctorDoc.exists) {
      var doctorData = doctorDoc.data()!;
      _nameController.text = doctorData['name'] ?? '';
      _contactController.text = doctorData['contact'] ?? '';
      _specialisationController.text = doctorData['specialisation'] ?? '';
      _slotController.text = doctorData['available_slots']?.join(', ') ?? '';
      _emailController.text = doctorData['email'] ?? '';
      _bookingDetailsController.text = doctorData['bookingDetails'] ?? '';
      _qualificationController.text = doctorData['qualification'] ?? '';
      _experienceController.text = doctorData['experience'] ?? '';
      _languagesController.text = doctorData['languages_spoken'] ?? '';
      _insuranceController.text = doctorData['insurance_accepted'] ?? '';
      _certificationsController.text = doctorData['certifications'] ?? '';
      _membershipsController.text = doctorData['memberships'] ?? '';
      _patientReviewsController.text = doctorData['patient_reviews'] ?? '';
      _profilePictureController.text = doctorData['profile_picture'] ?? '';
    }
  }

  void _saveDoctorInfo() async {
    if (_formKey.currentState!.validate()) {
      final doctorId = FirebaseAuth.instance.currentUser!.uid;

      try {
        await FirebaseFirestore.instance
            .collection('doctors')
            .doc(doctorId)
            .update({
          'name': _nameController.text,
          'contact': _contactController.text,
          'specialisation': _specialisationController.text,
          'available_slots': _slotController.text
              .split(',')
              .map((slot) => slot.trim())
              .toList(),
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
          const SnackBar(content: Text('Doctor Info Updated Successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Information')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Doctor Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                ),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number (with country code)',
                    hintText: '+91XXXXXXXXXX',
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your contact number';
                    }
                    final pattern = RegExp(r'^\+\d{7,15}$');
                    if (!pattern.hasMatch(value)) {
                      return 'Enter a valid number with country code (e.g. +1XXXXXXXXXX)';
                    }
                    return null;
                  },
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
                  onPressed: _saveDoctorInfo,
                  child: const Text('Save Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
