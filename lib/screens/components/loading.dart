import 'package:flutter/material.dart';
import 'dart:math';

class FitnessLoading extends StatefulWidget {
  const FitnessLoading({super.key});

  @override
  State<FitnessLoading> createState() => _FitnessLoadingState();
}

class _FitnessLoadingState extends State<FitnessLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // Répétition infinie de l'animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Arrière-plan sombre pour un bon contraste
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animation de rotation simple de l'icône kettlebell
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * pi,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors
                          .purpleAccent, // Couleur unie pour plus de simplicité
                    ),
                    child: const Icon(
                      Icons.fitness_center, // Icône de kettlebell
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            // Texte statique et simple
            const Text(
              "Chargement...",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
