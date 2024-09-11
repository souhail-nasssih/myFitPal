// lib/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:myfitpal/auth/login_screen.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/screens/onboarding/OnboardingScreen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: const [
              OnboardingContent(
                description:
                    'Welcome to our fitness app! Get started on your journey.',
                image: 'images/6.jpg',
                title1: 'Welcome ',
                title2: 'to MyApp',
                backgroundColor: ColorsHelper.backgroundColor,
                textColor: ColorsHelper.secondaryColor,
              ),
              OnboardingContent(
                description:
                    'Begin your fitness adventure as a Client! Access personalized workout plans, work with certified coaches, track your progress, and stay motivated with live sessions.',
                image: 'images/4.jpg',
                title1: 'Become a ',
                title2: 'Client!',
                backgroundColor: ColorsHelper.backgroundColor,
                textColor: ColorsHelper.secondaryColor,
              ),
              OnboardingContent(
                description:
                    'Grow your client base as a Coach! Create custom fitness programs, host live training sessions, and build your professional brand in a thriving community.',
                image: 'images/5.jpg',
                title1: 'Join us as a ',
                title2: 'Coach!',
                backgroundColor: ColorsHelper.backgroundColor,
                textColor: ColorsHelper.secondaryColor,
              ),
              LoginScreen(), // Replaced PathSelectionScreen with LoginScreen
            ],
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: List.generate(
                    4,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: _currentPage == index ? 30 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? ColorsHelper.primaryColor
                            : ColorsHelper.colorGrey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
