import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitpal/screens/client/components/cardCoach.dart';

class ProfileList extends StatefulWidget {
  const ProfileList({super.key});

  @override
  State<ProfileList> createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  Future<List<Map<String, dynamic>>> _fetchProfiles() async {
    final firestore = FirebaseFirestore.instance;
    final querySnapshot = await firestore.collection('coaches').get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'fullname': data['fullName'] ?? 'Nom inconnu',
        'pricing': data['pricing'] ?? 0,
        'duration': data['duration'] ?? 'Durée inconnue',
        'certifications': data['certifications'] ?? 'Pas de certification',
        'city': data['city'] ?? 'Ville inconnue',
        'image': data['image'] ?? 'images/4.jpg',
        'email': data['email'] ?? 'email@example.com',
        'birthday':
            (data['birthday'] as Timestamp?)?.toDate().toLocal().toString() ??
                'Date inconnue', // Convertit Timestamp en String
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchProfiles(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erreur: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Aucun coach disponible.'));
        } else {
          final profiles = snapshot.data!;
          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              return ProfileCard(
                fullname: profile['fullname']!,
                pricing: profile['pricing']!,
                duration: profile['duration']!,
                certifications: profile['certifications']!,
                city: profile['city']!,
                image: profile['image']!,
                email: profile['email']!,
                birthday: profile['birthday']!,
              );
            },
          );
        }
      },
    );
  }
}
