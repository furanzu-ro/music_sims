// File: lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkSavedGame();
  }

  void _checkSavedGame() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    if (gameProvider.gameState.isGameStarted) {
      // If game is started, navigate to main navigation (game/profile)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/main_navigation');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image removed for cleaner look
          // Gradient overlay removed for cleaner look
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Welcome card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: cardColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Icon(
                              Icons.music_note,
                              size: 60,
                              color: accentColor,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Welcome to Musica Journey',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: 'PressStart2P',
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Manage your health, energy, and happiness\nthrough your musical career journey!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Consumer<GameProvider>(
                      builder: (context, gameProvider, child) {
                        if (gameProvider.isLoading) {
                          return Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Column(
                              children: [
                                CircularProgressIndicator(
                                  color: accentColor,
                                  strokeWidth: 3,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Loading your journey...',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (gameProvider.gameState.isGameStarted) ...[
                              _buildModernButton(
                                context: context,
                                text: 'Continue Game',
                                icon: Icons.play_arrow,
                                isPrimary: true,
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, '/main_navigation');
                                },
                              ),
                              const SizedBox(height: 16),
                              _buildModernButton(
                                context: context,
                                text: 'Start New Game',
                                icon: Icons.refresh,
                                isPrimary: false,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/game');
                                },
                              ),
                            ] else ...[
                              _buildModernButton(
                                context: context,
                                text: 'Start Game',
                                icon: Icons.rocket_launch,
                            isPrimary: true,
                            onPressed: () async {
                              Navigator.pushNamed(context, '/game').then((_) {
                                // After returning from game screen, check if game started and navigate
                                final gameProvider = Provider.of<GameProvider>(context, listen: false);
                                if (gameProvider.gameState.isGameStarted) {
                                  Navigator.pushReplacementNamed(context, '/main_navigation');
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                              elevation: 6,
                              shadowColor: accentColor.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? accentColor : cardColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          elevation: isPrimary ? 8 : 4,
          shadowColor: isPrimary ? accentColor.withOpacity(0.4) : Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: isPrimary ? BorderSide.none : BorderSide(
              color: accentColor.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isPrimary ? Colors.white : accentColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
