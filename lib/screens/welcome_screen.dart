import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _musicNoteController;
  late Animation<double> _musicNoteAnimation;

  @override
  void initState() {
    super.initState();
    _musicNoteController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _musicNoteAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _musicNoteController,
      curve: Curves.easeInOut,
    ));
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

  Widget _buildFloatingNote(double startX, double startY, double size, double delay) {
    return AnimatedBuilder(
      animation: _musicNoteController,
      builder: (context, child) {
        double progress = (_musicNoteAnimation.value + delay) % 1;
        double y = startY - (progress * 200);
        double x = startX + (10 * (progress - 0.5));
        double opacity = 1.0 - progress;
        return Positioned(
          left: x,
          top: y,
          child: Opacity(
            opacity: opacity,
            child: Icon(
              Icons.music_note,
              size: size,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        );
      },
    );
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
                          Column(
                            children: [
                              const Text(
                                'Welcome to',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Musica Journey',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.getFont(
                                  'Press Start 2P',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Make music. Make headlines. Make history',
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
                            child: SizedBox(
                              height: 100,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  _buildFloatingNote(40, 80, 30, 0.0),
                                  _buildFloatingNote(80, 90, 20, 0.3),
                                  _buildFloatingNote(120, 85, 25, 0.6),
                                  _buildFloatingNote(160, 90, 18, 0.9),
                                  _buildFloatingNote(200, 80, 22, 0.2),
                                  const Positioned(
                                    bottom: 8,
                                    child: Text(
                                      'Loading your journey...',
                                      style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (gameProvider.gameState.isGameStarted) ...[
                              // Removed "Continue Game" button as requested
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
