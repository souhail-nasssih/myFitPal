import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileCoachTab extends StatefulWidget {
  const ProfileCoachTab({super.key});

  @override
  _ProfileCoachTabState createState() => _ProfileCoachTabState();
}

class _ProfileCoachTabState extends State<ProfileCoachTab> {
  User? _currentUser;
  Map<String, dynamic>? _coachData;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      _fetchCoachData();
    }
  }

  Future<void> _fetchCoachData() async {
    final email = _currentUser?.email;
    if (email != null) {
      try {
        final coachDocs = await FirebaseFirestore.instance
            .collection('coaches')
            .where('email', isEqualTo: email)
            .get();
        if (coachDocs.docs.isNotEmpty) {
          setState(() {
            _coachData = coachDocs.docs.first.data();
          });
        } else {
          print('No coach found with email: $email');
        }
      } catch (e) {
        print('Error fetching coach data: $e');
      }
    } else {
      print('No current user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _coachData == null
        ? const Center(child: CircularProgressIndicator())
        : Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(_coachData?['profileImageUrl'] ?? ''),
          ),
          const SizedBox(height: 20),
          Text('Name: ${_coachData?['fullName'] ?? 'N/A'}'),
          Text('Email: ${_coachData?['email'] ?? 'N/A'}'),
          Text('Location: ${_coachData?['location'] ?? 'N/A'}'),
          Text('Pricing: \$${_coachData?['pricing'] ?? 'N/A'}'),
          Text('Sports: ${( _coachData?['sports'] as List<dynamic>?)?.join(', ') ?? 'N/A'}'),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
