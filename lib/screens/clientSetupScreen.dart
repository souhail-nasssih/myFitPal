import 'package:flutter/material.dart';
import 'package:myfitpal/screens/components/Logo.dart';
import 'package:myfitpal/screens/components/TextFieldWidget.dart';

class Clientsetup extends StatefulWidget {
  const Clientsetup({super.key});

  @override
  State<Clientsetup> createState() => _ClientsetupState();
}

class _ClientsetupState extends State<Clientsetup> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _goalController = TextEditingController();
  DateTime? _selectedBirthday;
  String? _selectedGender;

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
                          'Client Setup',
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
                          // keyboardType: TextInputType.name, // Type de clavier pour le nom
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.phone,
                          labelText: 'Phone Number',
                          controller: _phoneNumberController,
                          // keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.location_on,
                          labelText: 'Location',
                          controller: _locationController,
                          // keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        TextFieldWidget(
                          icon: Icons.cake,
                          labelText: 'Age',
                          controller: _ageController,
                          // keyboardType: TextInputType.number,
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
                          // keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Logique d'inscription
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
                        // const SocialIcons(), // Réutilisation des icônes sociales
                        const SizedBox(height: 10),
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
