import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/constants.dart';
import '../widgets/floating_notes_animation.dart';

class InstagramSplashScreen extends StatefulWidget {
  const InstagramSplashScreen({super.key});

  @override
  State<InstagramSplashScreen> createState() => _InstagramSplashScreenState();
}

class _InstagramSplashScreenState extends State<InstagramSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/instagram');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const FloatingNotesAnimation(numberOfNotes: 10),
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/icons/instagram_custom.png',
                width: 100,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}