// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
        title: 'Next Week Simulator',
        theme: ThemeData(
          primaryColor: primaryColor,
          scaffoldBackgroundColor: bgColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: primaryColor,
          ),
          useMaterial3: true,
        ),
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
        routes: {
          '/game': (context) => const GameScreen(),
          '/date_selection': (context) => const DateSelectionScreen(),
        },
      ),
    );
  }
}
