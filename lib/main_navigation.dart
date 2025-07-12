import 'package:flutter/material.dart';
import 'screens/game_screen.dart';
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
  late Animation<double> _animation;

  static const List<Widget> _widgetOptions = <Widget>[
    GameScreen(),
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

  static const double _indicatorWidth = 100;
  static const double _indicatorHeight = 40;
  static const double _indicatorRadius = 20;
  static const double _iconSize = 28;
  static const double _fontSize = 14;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
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
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: isSelected
                  ? Container(
                      key: ValueKey<int>(_selectedIndex),
                      width: _indicatorWidth,
                      height: _indicatorHeight,
                      decoration: BoxDecoration(
                        color: accentColor,
                        borderRadius: BorderRadius.circular(_indicatorRadius),
                        boxShadow: const [
                          BoxShadow(
                            color: accentColor,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(left: 12),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.white, size: _iconSize),
                          const SizedBox(width: 8),
                          Text(
                            label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      key: ValueKey<int>(-1),
                      width: _indicatorWidth,
                      height: _indicatorHeight,
                    ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: Icon(icon, color: isSelected ? Colors.transparent : Colors.black87, size: _iconSize),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
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
    );
  }
}
