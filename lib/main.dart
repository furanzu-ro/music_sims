// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/game_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/date_selection_screen.dart';
import 'providers/game_provider.dart';
import 'utils/constants.dart';
import 'main_navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Musica Journey',
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: bgColor,
          fontFamily: 'Inter',
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            titleTextStyle: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (context) => const HomeScreen(),
          '/main_navigation': (context) => const MainNavigation(),
          '/game': (context) => const GameScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/date_selection': (context) => const DateSelectionScreen(),
        },
      ),
    );
  }
}
