import 'package:flutter/material.dart';
import 'user_data.dart';

class DemographicsPage extends StatefulWidget {
  const DemographicsPage({super.key});

  @override
  State<DemographicsPage> createState() => _DemographicsPageState();
}

class _DemographicsPageState extends State<DemographicsPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _routineController = TextEditingController();

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await UserData.saveDemographics({
          'name': _nameController.text.trim(),
          'age': _ageController.text.trim(),
          'routine': _routineController.text.trim(),
        });
        if (mounted) {
          Navigator.pushNamed(context, '/consent');
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving demographics: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF81A8A1),
        title: const Text('Demographics',
            style: TextStyle(color: Color.fromARGB(255, 19, 18, 18))),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 66, 80, 66),
              Color.fromARGB(255, 128, 115, 98),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Name is required'
                        : null,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _ageController,
                    decoration: const InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Age is required';
                      }
                      final age = int.tryParse(value);
                      if (age == null || age <= 0 || age > 120) {
                        return 'Enter a valid age';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _routineController,
                    decoration: const InputDecoration(
                      labelText: 'Daily Routine',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.schedule),
                      hintText: 'Describe your typical daily activities',
                    ),
                    maxLines: 3,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please describe your routine'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Color(0xFFF6C9A7),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 10,
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
