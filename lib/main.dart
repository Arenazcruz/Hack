import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/app_state_provider.dart';
import 'screens/create_experience_screen.dart';
import 'screens/entrepreneur_home_screen.dart';
import 'screens/entrepreneur_profile_screen.dart';
import 'screens/experience_detail_screen.dart';
import 'screens/experience_list_screen.dart';
import 'screens/gastronomic_route_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/tourist_home_screen.dart';

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
        title: 'Sumaq Ruta AI',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1F7A53),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
        ),
        initialRoute: LoginScreen.routeName,
        routes: {
          LoginScreen.routeName: (_) => const LoginScreen(),
          RegisterScreen.routeName: (_) => const RegisterScreen(),
          RoleSelectionScreen.routeName: (_) => const RoleSelectionScreen(),
          EntrepreneurHomeScreen.routeName: (_) =>
              const EntrepreneurHomeScreen(),
          TouristHomeScreen.routeName: (_) => const TouristHomeScreen(),
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
