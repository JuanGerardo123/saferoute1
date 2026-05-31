import 'package:flutter/material.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/map/screens/map_screen.dart';
import '../../features/incidents/screens/new_incident_screen.dart';
import '../../features/incidents/screens/incident_detail_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String map = '/map';
  static const String newIncident = '/incident/new';
  static const String incidentDetail = '/incident/detail';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case map:
        return MaterialPageRoute(builder: (_) => const MapScreen());
      case newIncident:
        return MaterialPageRoute(builder: (_) => const NewIncidentScreen());
      case incidentDetail:
        return MaterialPageRoute(
          builder: (_) =>
              IncidentDetailScreen(incidentId: settings.arguments as String),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
