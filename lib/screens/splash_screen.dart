import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../widgets/floating_notes_animation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSavedGame();
    });
  }

  Future<void> _checkSavedGame() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final hasSave = await gameProvider.loadGameState();

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      if (hasSave) {
        Navigator.pushReplacementNamed(context, '/main_navigation');
      } else {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FloatingNotesAnimation(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Musica Journey',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont(
                    'Press Start 2P',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      const Shadow(
                        blurRadius: 10.0,
                        color: accentColor,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
