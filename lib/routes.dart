import 'package:flutter/material.dart';
import 'package:myfitpal/auth/login_screen.dart';
import 'package:myfitpal/screens/client/pages/activity.dart';
import 'package:myfitpal/screens/client/pages/calendar.dart';
import 'package:myfitpal/screens/client/pages/insights.dart';
import 'package:myfitpal/screens/client/pages/profile.dart';

class Routes {
  static const String activityScreen = '/';
  static const String insights = '/insights';
  static const String calendar = '/calendar';
  static const String profile = '/profile';
  static const String login = '/login';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case activityScreen:
        return MaterialPageRoute(builder: (_) => const ActivityScreen());
      case insights:
        return MaterialPageRoute(builder: (_) => const InsightsPage());
      case calendar:
        return MaterialPageRoute(builder: (_) => const CalendarPage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => const LoginScreen()); // Default route
    }
  }
}
