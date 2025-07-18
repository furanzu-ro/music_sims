// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';  // Added import for Google Fonts
import 'screens/splash_screen.dart' as splash;
import 'screens/welcome_screen.dart';
import 'screens/game_screen.dart' as game;
import 'screens/profile_screen.dart';
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
          // Remove fontFamily here to use GoogleFonts for all text styles
          textTheme: TextTheme(
            displayLarge: GoogleFonts.nunito(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            displayMedium: GoogleFonts.nunito(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
            bodyLarge: GoogleFonts.nunito(
              fontSize: 16,
              color: Colors.white,
            ),
            bodyMedium: GoogleFonts.nunito(
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
          '/splash': (context) => const splash.SplashScreen(),
          '/welcome': (context) => const WelcomeScreen(),
          '/main_navigation': (context) => const main_nav.MainNavigation(),
          '/game': (context) => const game.GameScreen(),
          '/profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
