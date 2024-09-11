import 'package:flutter/material.dart';
import 'package:myfitpal/screens/client/pages/SettingsTab.dart';
import 'ProfileCoachTab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CoachLandingPage extends StatefulWidget {
  const CoachLandingPage({super.key});

  @override
  _CoachLandingPageState createState() => _CoachLandingPageState();
}

class _CoachLandingPageState extends State<CoachLandingPage> {
  int _selectedIndex = 0;
  User? _currentUser;
  Map<String, dynamic>? _coachData;

  final List<Widget> _pages = [
    const ProfileCoachTab(),
    const SettingsTab(),
  ];

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFDF6D00),
        title: const Text(
          'Coach Dashboard',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('/login'); // Replace with your login route
            },
          ),
        ],
      ),
      body: _coachData == null
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFDF6D00),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
