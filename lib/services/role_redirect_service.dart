import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../screens/admin_home_screen.dart';
import '../screens/client_home_screen.dart';
import '../screens/entrepreneur_home_screen.dart';
import '../screens/gastronomic_home_screen.dart';
import '../screens/guide_home_screen.dart';
import '../screens/tourist_home_screen.dart';

class RoleRedirectService {
  const RoleRedirectService._();

  static void redirectByRole(BuildContext context, UserProfile profile) {
    final role = profile.role.trim();

    switch (role) {
      case 'client':
        _go(context, ClientHomeScreen.routeName);
        return;
      case 'entrepreneur':
        _go(context, EntrepreneurHomeScreen.routeName);
        return;
      case 'gastronomic':
        _go(context, GastronomicHomeScreen.routeName);
        return;
      case 'guide':
        _go(context, GuideHomeScreen.routeName);
        return;
      case 'tourist':
        _go(context, TouristHomeScreen.routeName);
        return;
      case 'admin':
        _go(context, AdminHomeScreen.routeName);
        return;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rol no reconocido. Se abrirá el inicio de cliente.'),
          ),
        );
        _go(context, ClientHomeScreen.routeName);
    }
  }

  static void _go(BuildContext context, String routeName) {
    Navigator.pushReplacementNamed(context, routeName);
  }
}
