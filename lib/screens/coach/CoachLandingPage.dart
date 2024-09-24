import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/screens/client/pages/SettingsTab.dart';
import 'package:myfitpal/screens/coach/HomeSceenCoach.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfitpal/screens/coach/playning.dart';
import 'ProfileCoachTab.dart';

class CoachLandingPage extends StatefulWidget {
  const CoachLandingPage({super.key});

  @override
  _CoachLandingPageState createState() => _CoachLandingPageState();
}

class _CoachLandingPageState extends State<CoachLandingPage> {
  int _selectedIndex = 0;
  User? _currentUser;
  Map<String, dynamic>? _coachData;

  // Liste des pages de l'application
  final List<Widget> _pages = [
    const HomeScreenCoach(),
    const CoachPlanningPage(), // Ajout de la page de planning ici
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
      body: _coachData == null
          ? const Center(child: CircularProgressIndicator())
          : _pages[_selectedIndex], // Affiche la page sélectionnée
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Planning', // Correction de l'orthographe
          ),
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
        selectedItemColor: ColorsHelper.colorBlueText,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
