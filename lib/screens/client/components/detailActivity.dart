import 'package:flutter/material.dart';
import 'package:myfitpal/layouts/bottom_bar.dart';
import 'package:myfitpal/screens/client/components/giveCoatch.dart';
import 'package:myfitpal/screens/client/components/searchLocation.dart';

class ActivityDetailScreen extends StatelessWidget {
  final String activityID;

  const ActivityDetailScreen({super.key, required this.activityID});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('$activityID Details'), // Afficher l'ID de l'activité
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Coach'),
              Tab(text: 'Localisation'),
              Tab(text: 'Session'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GiveCoatch(
                activityID: activityID), // Passer activityID à ProfileList
            SearchLocation(activityID: activityID),
            const Center(child: Text('Session Info')),
          ],
        ),
        bottomNavigationBar: const BottomBar(currentIndex: 0),
      ),
    );
  }
}
