import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitpal/screens/client/pages/activity.dart';
import '../screens/onboarding/pathSelection.dart';

class ClientSetupScreen extends StatefulWidget {
  const ClientSetupScreen({super.key});

  @override
  _ClientSetupScreenState createState() => _ClientSetupScreenState();
}

class _ClientSetupScreenState extends State<ClientSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedGender;
  DateTime _selectedBirthday = DateTime.now();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDF6D00),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PathSelectionScreen()),
            );
          },
        ),
        title: const Text('Client Setup', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.deepPurple.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome! Let\'s Set Up Your Profile',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _fullNameController, 'Full Name',
                  'Please enter your full name',
                  const Color(0xFFDF6D00),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _phoneNumberController, 'Phone Number',
                  'Please enter your Phone Number',
                  const Color(0xFFDF6D00),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _locationController, 'Location',
                  'Please enter your Location',
                  const Color(0xFFDF6D00),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  _ageController, 'Age',
                  'Please enter your age',
                  const Color(0xFFDF6D00),
                  TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildBirthdayPicker(),
                const SizedBox(height: 20),
                _buildGenderDropdown(),
                const SizedBox(height: 20),
                _buildTextField(
                  _goalController, 'Fitness Goal',
                  'Please enter your fitness goal',
                  const Color(0xFFDF6D00),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDF6D00),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String validationMessage, Color borderColor, [TextInputType keyboardType = TextInputType.text]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.deepPurple),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validationMessage;
        }
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFDF6D00)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: _selectedGender,
      onChanged: (newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      items: ['Male', 'Female', 'Other'].map((gender) {
        return DropdownMenuItem(
          value: gender,
          child: Text(gender),
        );
      }).toList(),
      validator: (value) => value == null ? 'Please select your gender' : null,
    );
  }

  Widget _buildBirthdayPicker() {
    return GestureDetector(
      onTap: _selectBirthday,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Birthday',
            labelStyle: const TextStyle(color: Colors.black),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Color(0xFFDF6D00)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          controller: TextEditingController(
            text: '${_selectedBirthday.day}/${_selectedBirthday.month}/${_selectedBirthday.year}',
          ),
          validator: (value) => value == null || value.isEmpty ? 'Please select your birthday' : null,
        ),
      ),
    );
  }

  Future<void> _submitData() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      final clientData = {
        'age': int.tryParse(_ageController.text) ?? 0,
        'birthday': _selectedBirthday,
        'email': user.email,
        'fullName': _fullNameController.text,
        'gender': _selectedGender,
        'goal': _goalController.text,
      };

      // Save to Firestore
      await FirebaseFirestore.instance.collection('clients').doc(user.uid).set(clientData);

      // Redirect to ActivityScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ActivityScreen()),
      );
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectBirthday() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedBirthday = selectedDate;
      });
    }
  }
}
