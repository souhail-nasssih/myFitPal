import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myfitpal/service/coach/getAll.dart';
import 'package:myfitpal/screens/client/components/cardComponent/cardCoach.dart';
import 'package:myfitpal/screens/components/loading.dart';

class SearchLocation extends StatefulWidget {
  final String activityID;

  const SearchLocation({super.key, required this.activityID});

  @override
  State<SearchLocation> createState() => _SearchLocationState();
}

class _SearchLocationState extends State<SearchLocation> {
  late Future<String> _clientCityFuture;

  @override
  void initState() {
    super.initState();
    _clientCityFuture = _fetchClientCity();
  }

  Future<String> _fetchClientCity() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      return await GetAllCoachService().fetchClientCity(userId);
    }
    return 'Ville inconnue';
  }

  Future<List<Map<String, dynamic>>> _fetchProfiles(
      String city, String searchTerm) async {
    return await GetAllCoachService().fetchProfilesByCity(
      widget.activityID,
      city,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _clientCityFuture,
        builder: (context, citySnapshot) {
          if (citySnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: FitnessLoading());
          } else if (citySnapshot.hasError) {
            return Center(child: Text('Erreur: ${citySnapshot.error}'));
          } else if (!citySnapshot.hasData || citySnapshot.data!.isEmpty) {
            return const Center(child: Text('Ville du client inconnue.'));
          } else {
            final city = citySnapshot.data!;
            // Pass an empty string for the searchTerm
            return FutureBuilder<List<Map<String, dynamic>>>(
              future: _fetchProfiles(city, ''),
              builder: (context, profilesSnapshot) {
                if (profilesSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: FitnessLoading());
                } else if (profilesSnapshot.hasError) {
                  return Center(
                      child: Text('Erreur: ${profilesSnapshot.error}'));
                } else if (!profilesSnapshot.hasData ||
                    profilesSnapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun coach disponible.'));
                } else {
                  final profiles = profilesSnapshot.data!;
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
        },
      ),
    );
  }
}
