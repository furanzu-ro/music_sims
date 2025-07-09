// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart' as splash;
import 'screens/home_screen.dart';
import 'screens/game_screen.dart' as game;
import 'screens/profile_screen.dart';
import 'screens/date_selection_screen.dart';
import 'providers/game_provider.dart';
import 'utils/constants.dart';
import 'main_navigation.dart' as main_nav;

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
          fontFamily: 'Inter', // Keep Inter as main font
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            displayMedium: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              color: Colors.white,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
            titleTextStyle: TextStyle(
              fontFamily: 'PressStart2P', // Pixelated font only for app bar title
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => splash.SplashScreen(),
          '/home': (context) => const HomeScreen(),
          '/main_navigation': (context) => const main_nav.MainNavigation(),
          '/game': (context) => const game.GameScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/date_selection': (context) => const DateSelectionScreen(),
        },
      ),
    );
  }
}
