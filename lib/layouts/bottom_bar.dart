import 'package:flutter/material.dart';
import 'package:myfitpal/helpers/helpers.dart';
import 'package:myfitpal/screens/client/pages/activity.dart';
import 'package:myfitpal/screens/client/pages/calendar.dart';
import 'package:myfitpal/screens/client/pages/insights.dart';
import 'package:myfitpal/screens/client/pages/profile.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;

  const BottomBar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: ColorsHelper.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavBarIcon(context, Icons.home, 0, const ActivityScreen()),
          _buildNavBarIcon(context, Icons.show_chart, 1, const InsightsPage()),
          _buildNavBarIcon(
              context, Icons.calendar_today, 2, const CalendarPage()),
          _buildNavBarIcon(context, Icons.person, 3, const ProfilePage()),
        ],
      ),
    );
  }

  Widget _buildNavBarIcon(BuildContext context, IconData iconData, int index,
      Widget destinationPage) {
    final bool isSelected = currentIndex == index;
    return Stack(
      alignment: Alignment.center,
      children: [
        if (isSelected)
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
          ),
        IconButton(
          icon: Icon(
            iconData,
            color: isSelected
                ? ColorsHelper.backgroundColor
                : ColorsHelper.secondaryColor,
          ),
          onPressed: () {
            if (currentIndex != index) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => destinationPage),
              );
            }
          },
        ),
      ],
    );
  }
}
