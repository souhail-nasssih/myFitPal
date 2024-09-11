// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/screens/onboarding/welcomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulez un temps d'attente de 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      // Après 3 secondes, naviguez vers l'écran principal
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor:
          ColorsHelper.colorFond, // Changez la couleur de fond en bleu clair
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: AssetImage(
                  'images/1.png'), // Remplacez par le chemin de votre image
              width:
                  150, // Augmentez la taille de l'image pour correspondre au design
              height: 150,
            ),
            SizedBox(height: 20),
            // Text(
            //   'FIT COACH',
            //   style: TextStyle(
            //     fontSize: 28, // Taille de police pour le titre
            //     fontWeight: FontWeight.bold,
            //     color: Colors.blueAccent, // Changez la couleur en bleu
            //   ),
            // ),
            SizedBox(height: 20), // Espace entre le titre et le sous-titre
            Text.rich(TextSpan(children: [
              TextSpan(
                  text: 'Track your ',
                  style: TextStyle(
                    color: ColorsHelper.secondaryColor,
                  )),
              TextSpan(
                text: 'Active Lifestyle',
                style: TextStyle(
                  color:
                      ColorsHelper.colorBlueText, // Changez la couleur en bleu
                ),
              ),
            ]))
          ],
        ),
      ),
    );
  }
}
