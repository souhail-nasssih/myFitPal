import 'package:flutter/material.dart';
import 'package:myfitpal/auth/ClientSetupScreen.dart';
import 'package:myfitpal/auth/CoachSetupScreen.dart';
import 'package:myfitpal/auth/login_screen.dart';
import 'package:myfitpal/helpers/helpers.dart';
// import 'package:fitness_app/widgets/MainScreen.dart';

class PathSelectionScreen extends StatefulWidget {
  const PathSelectionScreen({super.key});

  @override
  _PathSelectionScreenState createState() => _PathSelectionScreenState();
}

class _PathSelectionScreenState extends State<PathSelectionScreen> {
  int _selectedValue = 0; // Default selection

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorsHelper.backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Expanded(
                flex: 1, // Allocating 50% height
                child: Image.asset(
                  'images/7.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 1, // Allocating 50% height
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Select your path:',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: ColorsHelper.secondaryColor),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Client',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: _selectedValue == 0
                                    ? ColorsHelper.primaryColor
                                    : ColorsHelper.secondaryColor,
                              ),
                            ),
                            Radio<int>(
                              value: 0,
                              groupValue: _selectedValue,
                              activeColor: ColorsHelper.primaryColor,
                              onChanged: (int? value) {
                                setState(() {
                                  _selectedValue = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Column(
                          children: [
                            Text(
                              'Coach',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: _selectedValue == 1
                                    ? ColorsHelper.primaryColor
                                    : Colors.black,
                              ),
                            ),
                            Radio<int>(
                              value: 1,
                              groupValue: _selectedValue,
                              activeColor: ColorsHelper.primaryColor,
                              onChanged: (int? value) {
                                setState(() {
                                  _selectedValue = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedValue == 0) {
                          // Navigate to Client Setup Screen if Client is selected
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ClientSetupScreen()),
                          );
                        } else if (_selectedValue == 1) {
                          // Navigate to Coach Setup Screen if Coach is selected
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CoachSetupScreen()),
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.black),
                      ),
                      child: const Text(
                        'Get Started',
                        style: TextStyle(color: ColorsHelper.colorTextWhite),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        // Navigate to Login Screen
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      child: const Text(
                        'Already have an account? Login',
                        style: TextStyle(
                          fontSize: 16,
                          color: ColorsHelper.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
