import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart'; // Assurez-vous que ce chemin est correct
import 'package:myfitpal/layouts/bottom_bar.dart';
import 'package:myfitpal/screens/client/pages/IntensiveActivities.dart';
import 'package:myfitpal/screens/client/pages/PopularActivities.dart';
import 'package:myfitpal/screens/client/pages/allActivity.dart';
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
  String? _userName;
  bool _isLoading = true; // Ajout d'un état de chargement
  String? _error; // Stocke les erreurs de récupération

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

    // Récupérer le nom de l'utilisateur
    getClientName();
  }

  Future<void> getClientName() async {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      try {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('clients')
            .doc(userId)
            .get();

        if (documentSnapshot.exists) {
          var clientData = documentSnapshot.data() as Map<String, dynamic>?;
          setState(() {
            _userName = clientData?['fullName'] ?? 'Utilisateur inconnu';
            _isLoading = false;
          });
        } else {
          setState(() {
            _userName = 'Utilisateur inconnu';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _error = 'Erreur lors de la récupération des données: $e';
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _userName = 'Utilisateur inconnu';
        _isLoading = false;
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
        title: _isLoading
            ? const CircularProgressIndicator() // Affichage de chargement
            : Row(
                children: [
                  const Text('Activités, '),
                  Text(
                    _userName ?? 'Utilisateur inconnu',
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
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Affichage de chargement
          : _error != null
              ? Center(
                  child: Text(_error!,
                      style: const TextStyle(
                          color: Colors.red))) // Affichage de l'erreur
              : PageView(
                  controller: _pageController,
                  children: [
                    AllActivitiesPage(onActivityClick: (activityID) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ActivityDetailScreen(activityID: activityID),
                        ),
                      );
                    }),
                    const PopularActivitiesPage(),
                    const IntensiveActivitiesPage(),
                  ],
                ),
      bottomNavigationBar: const BottomBar(currentIndex: 0),
    );
  }
}
