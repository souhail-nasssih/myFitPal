import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfitpal/screens/coach/CoachLandingPage.dart';

import '../screens/onboarding/pathSelection.dart';

class CoachSetupScreen extends StatefulWidget {
  const CoachSetupScreen({super.key});

  @override
  _CoachSetupScreenState createState() => _CoachSetupScreenState();
}

class _CoachSetupScreenState extends State<CoachSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _certificationsController =
      TextEditingController();
  final TextEditingController _pricingController = TextEditingController();

  final TextEditingController _cityController = TextEditingController();
  DateTime _selectedBirthday = DateTime.now();
  final List<String> _selectedActivities = []; // List to hold multiple activity IDs
  List<QueryDocumentSnapshot> _activities = []; // Store the activities data
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchActivities(); // Fetch the activities when the screen initializes
  }

  Future<void> _fetchActivities() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('activity').get();
      setState(() {
        _activities = snapshot.docs; // Store activities data in the state
      });
    } catch (e) {
      // Handle error (e.g., show a message if there’s an error fetching activities)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching activities: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Setup'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.deepPurple),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const PathSelectionScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Coach Setup',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _fullNameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _certificationsController,
                  decoration: const InputDecoration(
                    labelText: 'Certifications',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your certifications';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _pricingController,
                  decoration: const InputDecoration(
                    labelText: 'Pricing',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your pricing';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 20),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your city';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Date Picker for Birthday
                Text(
                    'Birthday: ${_selectedBirthday.toLocal().toString().split(' ')[0]}'),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedBirthday,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null &&
                        selectedDate != _selectedBirthday) {
                      setState(() {
                        _selectedBirthday = selectedDate;
                      });
                    }
                  },
                  child: const Text('Select Date'),
                ),
                const SizedBox(height: 20),
                // Multi-select for Activities
                const Text('Select Activities'),
                _activities.isEmpty
                    ? const CircularProgressIndicator() // Show loading indicator until activities are fetched
                    : Column(
                        children: _activities.map((activity) {
                          final activityId = activity.id;
                          final activityName =
                              activity['activityName'] ?? 'Activity';

                          return CheckboxListTile(
                            title: Text(activityName),
                            value: _selectedActivities.contains(activityId),
                            onChanged: (isChecked) {
                              setState(() {
                                if (isChecked!) {
                                  _selectedActivities.add(activityId);
                                } else {
                                  _selectedActivities.remove(activityId);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
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

      final coachData = {
        'fullName': _fullNameController.text,
        'activityIDs':
            _selectedActivities, // Store selected activities as a list

        'birthday': Timestamp.fromDate(_selectedBirthday),
        'certifications': _certificationsController.text,
        'city': _cityController.text,
        'email': _emailController.text,
        'pricing': int.tryParse(_pricingController.text) ?? 0,
      };

      await FirebaseFirestore.instance
          .collection('coaches')
          .doc(user.uid)
          .set(coachData);

      // Navigate to CoachLandingPage after successful setup
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) =>
              const CoachLandingPage(), // Ensure this page is correctly imported
        ),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('An error occurred while saving your data: $e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
