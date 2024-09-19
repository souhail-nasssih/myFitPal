import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';

class SocialIcons extends StatelessWidget {
  const SocialIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.g_mobiledata, size: 40),
          color:
              ColorsHelper.colorBlueText, // Utilisation de la couleur primaire
          onPressed: () {
            // Action pour Google
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.facebook, size: 40),
          color:
              ColorsHelper.colorBlueText, // Utilisation de la couleur primaire
          onPressed: () {
            // Action pour Facebook
          },
        ),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.camera_alt_outlined, size: 40),
          color:
              ColorsHelper.colorBlueText, // Utilisation de la couleur primaire
          onPressed: () {
            // Action pour Instagram
          },
        ),
      ],
    );
  }
}
