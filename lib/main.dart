import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/app_state_provider.dart';
import 'screens/admin_home_screen.dart';
import 'screens/client_home_screen.dart';
import 'screens/create_experience_screen.dart';
import 'screens/entrepreneur_home_screen.dart';
import 'screens/entrepreneur_profile_screen.dart';
import 'screens/experience_detail_screen.dart';
import 'screens/experience_list_screen.dart';
import 'screens/gastronomic_home_screen.dart';
import 'screens/gastronomic_route_screen.dart';
import 'screens/guide_home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/tourist_home_screen.dart';
import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SumaqRutaApp());
}

class SumaqRutaApp extends StatelessWidget {
  const SumaqRutaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppStateProvider(),
      child: MaterialApp(
        title: 'SUMAQ IA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFFE8671B),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        initialRoute: WelcomeScreen.routeName,
        routes: {
          WelcomeScreen.routeName: (_) => const WelcomeScreen(),
          WelcomeScreen.welcomeRouteName: (_) => const WelcomeScreen(),
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          ClientHomeScreen.routeName: (_) => const ClientHomeScreen(),
          EntrepreneurHomeScreen.routeName: (_) =>
              const EntrepreneurHomeScreen(),
          TouristHomeScreen.routeName: (_) => const TouristHomeScreen(),
          GastronomicHomeScreen.routeName: (_) => const GastronomicHomeScreen(),
          GuideHomeScreen.routeName: (_) => const GuideHomeScreen(),
          AdminHomeScreen.routeName: (_) => const AdminHomeScreen(),
          EntrepreneurProfileScreen.routeName: (_) =>
              const EntrepreneurProfileScreen(),
          CreateExperienceScreen.routeName: (_) =>
              const CreateExperienceScreen(),
          ExperienceListScreen.routeName: (_) => const ExperienceListScreen(),
          ExperienceDetailScreen.routeName: (_) =>
              const ExperienceDetailScreen(),
          GastronomicRouteScreen.routeName: (_) =>
              const GastronomicRouteScreen(),
        },
      ),
    );
  }
}
