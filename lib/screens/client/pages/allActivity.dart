import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myfitpal/screens/client/components/cardComponent/activityCard.dart'; // Assurez-vous que ce chemin est correct
import 'package:myfitpal/screens/components/loading.dart';
import 'package:myfitpal/service/client/Activity.dart'; // Assurez-vous que ce chemin est correct

class AllActivitiesPage extends StatefulWidget {
  final Function(String) onActivityClick;

  const AllActivitiesPage({super.key, required this.onActivityClick});

  @override
  State<AllActivitiesPage> createState() => _AllActivitiesPageState();
}

class _AllActivitiesPageState extends State<AllActivitiesPage> {
  final FirebaseService firebaseService = FirebaseService();

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: StreamBuilder<QuerySnapshot>(
          stream: firebaseService.getActivites(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Une erreur est survenue'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const FitnessLoading(); // Utilisez FitnessLoading ici
            }

            final activities = snapshot.data?.docs ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                var activity = activities[index].data() as Map<String, dynamic>;

                String activityID = activity['activityName'] ?? '';
                String activityName =
                    activity['activityName'] ?? 'Activité inconnue';

                return InkWell(
                  onTap: () {
                    if (activityID.isNotEmpty) {
                      widget.onActivityClick(activityID); // Passer activityID
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('ID d\'activité manquant')),
                      );
                    }
                  },
                  child: ActivityCard(
                    imagePath: activity['imagePath'] ?? 'images/5.jpg',
                    activityName: activityName,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
