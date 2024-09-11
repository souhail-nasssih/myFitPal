import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart'; // Assurez-vous que ce chemin est correct
import 'package:myfitpal/layouts/bottom_bar.dart';
import 'package:myfitpal/screens/client/components/allActivity.dart';
import 'package:myfitpal/screens/client/components/detailActivity.dart';

class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  String? _userName; // Variable to store the user's name

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    _pageController.addListener(() {
      final pageIndex = _pageController.page?.round() ?? 0;
      if (_tabController.index != pageIndex) {
        _tabController.animateTo(pageIndex);
      }
    });
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _pageController.jumpToPage(_tabController.index);
      }
    });

    // Fetch the client's name after initialization
    getClientName();
  }

  // Function to retrieve the client's name from Firestore
  Future<void> getClientName() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection(
                'clients') // Assurez-vous que la collection est correcte
            .doc(userId) // Rechercher par ID
            .get();

        if (documentSnapshot.exists) {
          var clientData = documentSnapshot.data() as Map<String, dynamic>;
          setState(() {
            _userName = clientData['fullname'] ??
                'Utilisateur inconnu'; // Default if name is not found
          });
        } else {
          setState(() {
            _userName = 'Utilisateur inconnu';
          });
        }
      } catch (e) {
        print('Error fetching client name: $e');
        setState(() {
          _userName = 'Utilisateur inconnu';
        });
      }
    } else {
      setState(() {
        _userName = 'Utilisateur inconnu';
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Activités, '),
            Text(
              _userName ?? 'Utilisateur inconnu', // Display the username
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: ColorsHelper.secondaryColor,
          unselectedLabelColor: ColorsHelper.secondaryColor,
          indicatorColor: ColorsHelper.secondaryColor,
          tabs: const [
            Tab(text: '   All   '),
            Tab(text: 'Popular'),
            Tab(text: 'Intensive'),
          ],
        ),
      ),
      body: PageView(
        controller: _pageController,
        children: [
          AllActivitiesPage(onActivityClick: (activity) {
            print('Navigating to details for: $activity');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ActivityDetailScreen(activity: activity),
              ),
            );
          }),
          const PopularActivitiesPage(),
          const IntensiveActivitiesPage(),
        ],
      ),
      bottomNavigationBar: const BottomBar(
        currentIndex: 0,
      ),
    );
  }
}

class PopularActivitiesPage extends StatelessWidget {
  const PopularActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Popular Activities'));
  }
}

class IntensiveActivitiesPage extends StatelessWidget {
  const IntensiveActivitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Intensive Activities'));
  }
}
