import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditExercisePage extends StatefulWidget {
  const EditExercisePage({Key? key}) : super(key: key);

  @override
  State<EditExercisePage> createState() => _EditExercisePageState();
}

class _EditExercisePageState extends State<EditExercisePage> {
  final _formKey = GlobalKey<FormState>();
  String _exerciseName = '';
  String _exerciseType = 'cardio'; // Default exercise type
  int _duration = 30; // Default duration in minutes
  int _calories = 200; // Default calories burned
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // List of exercise types
  final List<String> _exerciseTypes = ['cardio', 'strength', 'yoga'];

  Future<void> _saveExercise() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('exercisePlans').doc(user.uid).collection('exercises').add({
        'name': _exerciseName,
        'type': _exerciseType,
        'duration': _duration,
        'calories': _calories,
        'completed': false, // New exercises start as not completed
      });
      Navigator.pop(context); // Go back to the previous page
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Exercise'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Name Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                onChanged: (value) {
                  setState(() {
                    _exerciseName = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the exercise name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Exercise Type Dropdown
              DropdownButtonFormField<String>(
                value: _exerciseType,
                onChanged: (value) {
                  setState(() {
                    _exerciseType = value!;
                  });
                },
                decoration: const InputDecoration(labelText: 'Exercise Type'),
                items: _exerciseTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type.capitalize()),
                        ))
                    .toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select an exercise type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Duration Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _duration = int.tryParse(value) ?? 30; // Default to 30 if invalid input
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the duration';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Calories Field
              TextFormField(
                decoration: const InputDecoration(labelText: 'Calories Burned'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _calories = int.tryParse(value) ?? 200; // Default to 200 if invalid input
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the calories burned';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Save Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _saveExercise();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text('Save Exercise'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  // Extension method to capitalize the first letter of the exercise type
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
