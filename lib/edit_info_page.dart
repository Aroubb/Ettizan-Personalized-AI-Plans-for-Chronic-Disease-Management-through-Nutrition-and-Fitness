import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditInfoPage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> userData;

  const EditInfoPage({Key? key, required this.userId, required this.userData}) : super(key: key);

  @override
  State<EditInfoPage> createState() => _EditInfoPageState();
}

class _EditInfoPageState extends State<EditInfoPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  late String goal;
  late String healthCondition;
  late String foodPreferences;
  late String allergies;
  late double height;
  late double weight;

  @override
  void initState() {
    super.initState();
    goal = widget.userData['goal'] ?? 'Maintain Weight';
    healthCondition = widget.userData['healthCondition'] ?? 'N/A';
    foodPreferences = widget.userData['foodPreferences'] ?? 'N/A';
    allergies = widget.userData['allergies'] ?? 'N/A';
    height = double.tryParse(widget.userData['height'] ?? '0.0') ?? 0.0;
    weight = double.tryParse(widget.userData['weight'] ?? '0.0') ?? 0.0;
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      await _firestore.collection('users').doc(widget.userId).update({
        'goal': goal,
        'healthCondition': healthCondition,
        'foodPreferences': foodPreferences,
        'allergies': allergies,
        'height': height,
        'weight': weight,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveChanges,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildDropdownField(
                'Goal',
                goal,
                ['Lose Weight', 'Gain Weight', 'Maintain Weight'],
                (value) => setState(() => goal = value!),
              ),
              const SizedBox(height: 10),
              _buildDropdownField(
                'Health Condition',
                healthCondition,
                ['N/A', 'Diabetes', 'Hypertension', 'Cholesterol'],
                (value) => setState(() => healthCondition = value!),
              ),
              const SizedBox(height: 10),
              _buildDropdownField(
                'Food Preferences',
                foodPreferences,
                ['N/A', 'Vegetarian', 'Vegan', 'Keto', 'Low Carb', 'Paleo'],
                (value) => setState(() => foodPreferences = value!),
              ),
              const SizedBox(height: 10),
              _buildTextField(
                'Allergies',
                allergies,
                (value) => setState(() => allergies = value),
              ),
              const SizedBox(height: 10),
              _buildNumericField(
                'Height (cm)',
                height.toString(),
                (value) => setState(() => height = double.parse(value)),
              ),
              const SizedBox(height: 10),
              _buildNumericField(
                'Weight (kg)',
                weight.toString(),
                (value) => setState(() => weight = double.parse(value)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String value,
    List<String> options,
    void Function(String?) onChanged,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          items: options.map((option) {
            return DropdownMenuItem(
              value: option,
              child: Text(option),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (value) => value == null || value.isEmpty ? 'Please select $label' : null,
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String initialValue,
    void Function(String) onSaved,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          onSaved: (value) => onSaved(value ?? ''),
          validator: (value) => value == null || value.isEmpty ? 'Please enter $label' : null,
        ),
      ),
    );
  }

  Widget _buildNumericField(
    String label,
    String initialValue,
    void Function(String) onSaved,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            labelText: label,
            border: InputBorder.none,
          ),
          keyboardType: TextInputType.number,
          onSaved: (value) => onSaved(value ?? '0'),
          validator: (value) {
            final numValue = double.tryParse(value ?? '');
            return numValue == null ? 'Please enter a valid $label' : null;
          },
        ),
      ),
    );
  }
}
