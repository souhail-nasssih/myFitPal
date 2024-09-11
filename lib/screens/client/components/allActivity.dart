import 'package:flutter/material.dart';
import 'package:myfitpal/screens/client/components/activityCard.dart';

class AllActivitiesPage extends StatelessWidget {
  final Function(String) onActivityClick;

  const AllActivitiesPage({super.key, required this.onActivityClick});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InkWell(
            onTap: () {
              print('Activity clicked: Swimming');
              onActivityClick('Swimming');
            },
            child: const ActivityCard(
              imagePath:
                  'images/5.jpg', // Assurez-vous que le chemin de l'image est correct
              activityName: 'Swimming',
            ),
          ),
          const SizedBox(height: 16), // Ajout d'espacement entre les éléments
          InkWell(
            onTap: () {
              print('Activity clicked: Playing Tennis');
              onActivityClick('Playing Tennis');
            },
            child: const ActivityCard(
              imagePath:
                  'images/6.jpg', // Assurez-vous que le chemin de l'image est correct
              activityName: 'Playing Tennis',
            ),
          ),
          // Ajoutez d'autres activités ici en suivant la même logique
        ],
      ),
    );
  }
}
