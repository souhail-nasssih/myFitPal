// lib/screens/widgets/onboarding_content.dart

import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';

class OnboardingContent extends StatelessWidget {
  final String description;
  final String image;
  final String title1;
  final String title2;
  final Color backgroundColor;
  final Color textColor;

  const OnboardingContent({
    super.key,
    required this.description,
    required this.image,
    required this.title1,
    required this.title2,
    this.backgroundColor = ColorsHelper.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Column(
        children: [
          const SizedBox(height: 50),
          Expanded(
            flex: 1,
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: title1,
                        style: const TextStyle(
                          color: ColorsHelper.secondaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: title2,
                        style: const TextStyle(
                          color: ColorsHelper.colorBlueText,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 350,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: ColorsHelper.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
