import 'package:flutter/material.dart';
import 'dart:math';
import '../utils/constants.dart';

class FloatingNotesAnimation extends StatefulWidget {
  final int numberOfNotes;
  const FloatingNotesAnimation({super.key, this.numberOfNotes = 15});

  @override
  State<FloatingNotesAnimation> createState() => _FloatingNotesAnimationState();
}

class _FloatingNotesAnimationState extends State<FloatingNotesAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: List.generate(widget.numberOfNotes, (index) {
        final startX = _random.nextDouble() * size.width;
        final startY = size.height + (_random.nextDouble() * size.height * 0.5);
        final noteSize = _random.nextDouble() * 20 + 15;
        final delay = _random.nextDouble();
        final travelDistance = size.height * 0.8 + (_random.nextDouble() * 200);
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            double progress = (_animation.value + delay) % 1;
            double y = startY - (progress * travelDistance);
            double x = startX + (sin(progress * 2 * pi) * 25);
            double opacity = sin(progress * pi);

            return Positioned(
              left: x,
              top: y,
              child: Opacity(
                opacity: opacity,
                child: Icon(
                  Icons.music_note,
                  size: noteSize,
                  color: accentColor,
                  shadows: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.7),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}