import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/layouts/base_app_bar.dart';
import 'package:myfitpal/layouts/bottom_bar.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(
        title: 'Insights',
        onBackPressed: () {
          Navigator.pop(context); // Navigate back to the previous screen
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.trending_up,
              size: 100,
              color: ColorsHelper.colorBlue,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your Insights Here',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Analyze your data and performance.',
              style: TextStyle(fontSize: 16, color: ColorsHelper.colorGreyT),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomBar(currentIndex: 1),
    );
  }
}
