import 'package:flutter/material.dart';
import 'package:myfitpal/screens/client/components/cardComponent/activityCard.dart';

class HomeScreenCoach extends StatefulWidget {
  const HomeScreenCoach({super.key});

  @override
  State<HomeScreenCoach> createState() => _HomeScreenCoachState();
}

class _HomeScreenCoachState extends State<HomeScreenCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Column(
        children: [
          // Autres widgets peuvent être ici
          Expanded(
            // Utilisation de Expanded pour donner une hauteur définie à ListView
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: const <Widget>[
                ActivityCard(
                    imagePath: 'images/7.jpg', activityName: 'playning'),
                ActivityCard(
                    imagePath: 'images/6.jpg',
                    activityName: 'coaching requisite'),
                ActivityCard(
                    imagePath: 'images/5.jpg', activityName: 'History'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
