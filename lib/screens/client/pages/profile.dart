import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfitpal/auth/login_screen.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/layouts/base_app_bar.dart';
import 'package:myfitpal/layouts/bottom_bar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? _userName;
  String? _bio;
  String? _location;
  String? _pricing;


  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  // Fetch user information from Firestore based on logged-in user ID
  Future<void> _getUserData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('clients') // Ensure this matches your Firestore setup
            .doc(userId)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          setState(() {
            _userName = userData['fullname'] ?? 'Unknown User';
            _bio = userData['bio'] ?? 'No bio available';
            _location = userData['location'] ?? 'Unknown location';
            _pricing = userData['pricing'] != null
                ? '\$${userData['pricing']}/H'
                : 'Pricing not available';
          });
        } else {
          print('User document does not exist');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('No user is currently logged in');
    }
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Profile',
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(10)),
            const Padding(padding: EdgeInsets.all(10)),
            const SizedBox(height: 16),
            Text(
              _userName ?? 'Unknown User',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _bio ?? 'No bio available',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: ColorsHelper.colorGreyT,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.location_on, color: ColorsHelper.colorGreyT),
                const SizedBox(width: 8),
                Text(
                  _location ?? 'Unknown location',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.attach_money, color: ColorsHelper.colorGreyT),
                const SizedBox(width: 8),
                Text(
                  _pricing ?? 'Pricing not available',
                  style: TextStyle(
                    fontSize: 16,
                    color: ColorsHelper.colorGreyT,
                  ),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _logout(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(fontSize: 18, color: ColorsHelper.backgroundColor),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add action for button press
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.message),
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 3),
    );
  }
}
