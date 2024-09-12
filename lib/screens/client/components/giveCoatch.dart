import 'package:flutter/material.dart';
import 'package:myfitpal/screens/client/components/cardComponent/cardCoach.dart';
import 'package:myfitpal/screens/components/loading.dart';
import 'package:myfitpal/service/coach/getAll.dart';

class GiveCoatch extends StatefulWidget {
  final String activityID;

  const GiveCoatch({super.key, required this.activityID});

  @override
  State<GiveCoatch> createState() => _GiveCoatchState();
}

class _GiveCoatchState extends State<GiveCoatch> {
  late final GetAllCoachService _coachService;

  @override
  void initState() {
    super.initState();
    _coachService = GetAllCoachService();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _coachService.fetchAllProfiles(widget.activityID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: FitnessLoading());
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
