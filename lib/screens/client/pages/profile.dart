import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitpal/auth/login_screen.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/layouts/bottom_bar.dart';
import 'package:myfitpal/screens/components/loading.dart'; // Assurez-vous que ce chemin est correct

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _clientDataFuture = getClientData();

  Future<Map<String, dynamic>> getClientData() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('clients')
            .doc(userId)
            .get();

        if (documentSnapshot.exists) {
          var clientData = documentSnapshot.data() as Map<String, dynamic>;
          return clientData;
        } else {
          return {}; // Aucune donnée trouvée
        }
      } catch (e) {
        throw 'Erreur lors de la récupération des données utilisateur: $e'; // Levée d'exception avec message d'erreur
      }
    }
    return {};
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Function to invite a coach
  void inviteCoach() {
    // Logic to send invitation goes here
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Invitation Envoyée'),
        content: const Text('Une invitation a été envoyée à votre coach.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _clientDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
                child:
                    FitnessLoading()), // Remplacez avec le widget de chargement
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Erreur: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _clientDataFuture =
                            getClientData(); // Relancer la récupération des données
                      });
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Scaffold(
            body: Center(child: Text('Données utilisateur introuvables')),
          );
        } else {
          final userData = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Mon Profil'),
              actions: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      _logout(context);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem(
                        value: 'logout',
                        child: Text('Déconnexion'),
                      ),
                    ];
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorsHelper.colorProfil,
                              width: 5,
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: ColorsHelper.colorProfil,
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                        ),
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('images/avatar.png'),
                          backgroundColor: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      userData['fullName'] ?? 'Nom inconnu',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Active since - Jul, 2019',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.email,
                          color: ColorsHelper.colorProfil),
                      title: Text(
                        userData['email'] ?? 'Email non défini',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.phone,
                          color: ColorsHelper.colorProfil),
                      title: Text(
                        userData['phone'] ?? 'Téléphone non défini',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.web,
                          color: ColorsHelper.colorProfil),
                      title: Text(
                        userData['website'] ?? 'Website non défini',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.location_on,
                          color: ColorsHelper.colorProfil),
                      title: Text(
                        userData['location'] ?? 'Location non définie',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: inviteCoach,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30),
                      backgroundColor: Colors.purple,
                    ),
                    child: const Text(
                      'Inviter un Coach',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.purple,
              child: const Icon(Icons.message),
            ),
            bottomNavigationBar: const BottomBar(currentIndex: 3),
          );
        }
      },
    );
  }
}
