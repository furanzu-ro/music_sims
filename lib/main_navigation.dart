
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_sims/providers/game_provider.dart';
import 'package:music_sims/screens/game_home_screen.dart';
import 'package:provider/provider.dart';
import 'screens/profile_screen.dart';
import 'utils/constants.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;

  static const List<Widget> _widgetOptions = <Widget>[
    GameHomeScreen(),
    ProfileScreen(),
  ];

  static const List<IconData> _icons = [
    Icons.home,
    Icons.face,
  ];

  static const List<String> _labels = [
    'Home',
    'Profile',
  ];

  static const double _iconSize = 28;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
  }

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      _controller.forward(from: 0.0);
    }
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    bool isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index),
        child: Container(
          padding: const EdgeInsets.only(top: 6, bottom: 1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black54, size: _iconSize),
              const SizedBox(height: 4),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: isSelected
                    ? Container(
                        key: ValueKey<int>(index),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 60), // Add bottom padding to avoid content under nav bar
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: true,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                height: 60,
                alignment: Alignment.bottomCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: primaryColor, 
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(icon: _icons[0], label: _labels[0], index: 0),
                          _buildNavItem(icon: _icons[1], label: _labels[1], index: 1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Consumer<GameProvider>(
            builder: (context, gameProvider, child) {
              if (gameProvider.isLoading) {
                return Container(
                  color: Colors.black.withOpacity(0.7),
                  width: double.infinity,
                  height: double.infinity,
                  child: const SizedBox.shrink(),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      ),
    );
  }
}
