import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfitpal/helpers/helpers.dart';

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
        : Scaffold(
            appBar: AppBar(
              title: const Text(
                'Coach Profile',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: ColorsHelper.colorBlueText,
              elevation: 0,
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar et nom du coach
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: NetworkImage(
                            _coachData?['profileImageUrl'] ?? '',
                          ),
                          backgroundColor: Colors.grey[200],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _coachData?['fullName'] ?? 'N/A',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                        ),
                        Text(
                          _coachData?['location'] ?? 'Location: N/A',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Informations principales
                  Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInfoRow(
                            context,
                            icon: Icons.email,
                            title: 'Email',
                            value: _coachData?['email'] ?? 'N/A',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            icon: Icons.attach_money,
                            title: 'Pricing',
                            value:
                                '\$${_coachData?['pricing'] ?? 'N/A'} / hour',
                          ),
                          const Divider(),
                          _buildInfoRow(
                            context,
                            icon: Icons.sports_soccer,
                            title: 'Sports',
                            value: (_coachData?['sports'] as List<dynamic>?)
                                    ?.join(', ') ??
                                'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Bouton Modifier
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Logique pour modifier le profil du coach
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsHelper.colorBlueText,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 40,
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  // Fonction pour afficher une ligne d'information avec une icône
  Widget _buildInfoRow(BuildContext context,
      {required IconData icon, required String title, required String value}) {
    return Row(
      children: [
        Icon(icon, color: ColorsHelper.colorBlue),
        const SizedBox(width: 10),
        Text(
          '$title:',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
