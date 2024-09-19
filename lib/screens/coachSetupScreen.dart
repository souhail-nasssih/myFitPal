import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Pour Timestamp
import 'package:myfitpal/screens/components/Logo.dart';
import 'package:myfitpal/screens/components/TextFieldWidget.dart';

class Coahsetup extends StatefulWidget {
  const Coahsetup({super.key});

  @override
  State<Coahsetup> createState() => _CoahsetupState();
}

class _CoahsetupState extends State<Coahsetup> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _certificationsController =
      TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pricingController = TextEditingController();

  DateTime? _selectedBirthday;
  String? _selectedGender;
  final List<String> _selectedActivities =
      []; // Pour stocker les activités sélectionnées

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 230, 0, 80),
            ),
          ),
          const Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Logo(), // Réutilisation du logo
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.68,
            minChildSize: 0.68,
            maxChildSize: 0.95,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 30.0,
                      right: 30.0,
                      top: MediaQuery.of(context).viewInsets.top + 30.0,
                      bottom: MediaQuery.of(context).viewInsets.bottom + 20.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        const Text(
                          'Coach Setup',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE60050),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.person,
                          labelText: 'Full Name',
                          controller: _fullNameController,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.phone,
                          labelText: 'Phone Number',
                          controller: _phoneNumberController,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.location_on,
                          labelText: 'Location',
                          controller: _locationController,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.cake,
                          labelText: 'Age',
                          controller: _ageController,
                        ),
                        const SizedBox(height: 20),
                        _buildBirthdayPicker(),
                        const SizedBox(height: 20),
                        _buildGenderDropdown(),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.fitness_center,
                          labelText: 'Fitness Goal',
                          controller: _goalController,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.email,
                          labelText: 'Email',
                          controller: _emailController,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.attach_money,
                          labelText: 'Pricing',
                          controller: _pricingController,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.location_city,
                          labelText: 'City',
                          controller: _cityController,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.description,
                          labelText: 'Certifications',
                          controller: _certificationsController,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            final clientData = {
                              'fullName': _fullNameController.text,
                              'phoneNumber': _phoneNumberController.text,
                              'location': _locationController.text,
                              'age': int.tryParse(_ageController.text) ?? 0,
                              'birthday': Timestamp.fromDate(
                                _selectedBirthday ?? DateTime.now(),
                              ),
                              'gender': _selectedGender,
                              'fitnessGoal': _goalController.text,
                              'email': _emailController.text,
                              'pricing':
                                  int.tryParse(_pricingController.text) ?? 0,
                              'city': _cityController.text,
                              'certifications': _certificationsController.text,
                              'activities': _selectedActivities,
                            };

                            // Ajoutez ici la logique pour envoyer les données au backend, par exemple à Firestore
                            FirebaseFirestore.instance
                                .collection('clients')
                                .add(clientData)
                                .then((_) {
                              // Optionnel: Affichez un message de succès ou redirigez l'utilisateur
                            }).catchError((error) {
                              // Optionnel: Gérez les erreurs
                              print("Error adding client: $error");
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: const Color(0xFFE60050),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account?",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/login');
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFFE60050),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBirthdayPicker() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null && pickedDate != _selectedBirthday) {
          setState(() {
            _selectedBirthday = pickedDate;
          });
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'Birthday',
          labelStyle: TextStyle(color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFFDF6D00)),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          _selectedBirthday == null
              ? 'Select your birthday'
              : '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}',
          style: TextStyle(
              color: _selectedBirthday == null ? Colors.grey : Colors.black),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      hint: const Text('Select Gender'),
      onChanged: (String? newValue) {
        setState(() {
          _selectedGender = newValue;
        });
      },
      items: <String>['Male', 'Female', 'Other']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: TextStyle(color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFDF6D00)),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
