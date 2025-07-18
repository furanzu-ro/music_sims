import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin { 
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _floatingNotesAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _floatingNotesAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/welcome');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildFloatingNote(double startX, double startY, double size, double delay) {
    return AnimatedBuilder(
      animation: _floatingNotesAnimation,
      builder: (context, child) {
        double progress = (_floatingNotesAnimation.value + delay) % 1;
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
    return FadeTransition(
      opacity: _animation,
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Gradient background replacing image
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6366F1), Color(0xFF10B981)],
                ),
              ),
            ),
            // Floating music notes animation
            Stack(
              children: [
                _buildFloatingNote(50, 400, 24, 0.0),
                _buildFloatingNote(120, 450, 18, 0.3),
                _buildFloatingNote(200, 420, 20, 0.6),
                _buildFloatingNote(280, 460, 16, 0.9),
                _buildFloatingNote(350, 430, 22, 0.2),
              ],
            ),
            // Gradient overlay for contrast
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.black.withOpacity(0.3)
                  ],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            // Content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // App title with pixelated font
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Musica Journey',
                          style: GoogleFonts.getFont(
                            'Press Start 2P',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: const Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Subtitle
                        Text(
                          'Your Musical Life Simulation',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                            shadows: [
                              Shadow(
                                offset: const Offset(1, 1),
                                blurRadius: 2,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Loading indicator replaced with music note animation
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF10B981).withOpacity(0.3),
                              const Color(0xFF10B981),
                            ],
                            stops: [0.0, _animation.value],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        child: const Icon(
                          Icons.music_note,
                          color: Colors.white,
                          size: 30,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
