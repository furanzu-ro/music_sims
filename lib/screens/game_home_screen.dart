import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../widgets/artist_profile_loading.dart';

class GameHomeScreen extends StatefulWidget {
  const GameHomeScreen({super.key});

  @override
  State<GameHomeScreen> createState() => _GameHomeScreenState();
}

class _GameHomeScreenState extends State<GameHomeScreen> with TickerProviderStateMixin {
  late AnimationController _musicNoteController;

  @override
  void initState() {
    super.initState();
    _musicNoteController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _musicNoteController.dispose();
    super.dispose();
  }


  String _formatDate(DateTime date) {
    const monthNames = [
      "",
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];
    return "${monthNames[date.month]} ${date.day}, ${date.year}";
  }

  Widget _buildCompactStat(String label, int value, IconData icon,
      {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(
          '$value%',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final gameState = gameProvider.gameState;
        return Stack(
          children: [
            Column(
              children: [
                // Compact Stats Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: const BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      // Profile section (smaller)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: accentColor, width: 2),
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: primaryColor,
                              backgroundImage: gameState.profilePicture.isNotEmpty
                                  ? NetworkImage(gameState.profilePicture)
                                  : null,
                              child: gameState.profilePicture.isEmpty
                                  ? const Icon(Icons.person, size: 25, color: Colors.white)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gameState.artistName,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Text(
                                      gameState.gameStartTime != null
                                          ? _formatDate(gameState.gameStartTime!)
                                          : "No Date",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.attach_money, color: Colors.white, size: 18),
                                    const SizedBox(width: 4),
                                    Text(
                                      gameState.money.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Compact stats
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCompactStat('Health', gameState.health, Icons.favorite,
                              color: gameState.health > 50 ? accentColor : dangerColor),
                          _buildCompactStat('Energy', gameState.energy, Icons.battery_charging_full,
                              color: gameState.energy > 30 ? accentColor : warningColor),
                          _buildCompactStat('Happiness', gameState.happiness, Icons.mood,
                              color: accentColor),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            const SizedBox(height: 12),
                            Container(
                              height: 70,
                              width: 70,
                              margin: const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Image(
                                  image: AssetImage('assets/icons/instagram_custom.png'),
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (gameProvider.isLoading)
              Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                  const Center(
                    child: ArtistProfileLoading(),
                  ),
                ],
              ),
            // Floating Next Week button
            Positioned(
              bottom: 20,
              right: 24,
              child: Material(
                elevation: 10,
                shape: const CircleBorder(),
                child: Consumer<GameProvider>(
                  builder: (context, gameProvider, child) {
                    return FloatingActionButton(
                      onPressed: gameProvider.isLoading
                          ? null
                          : () async {
                                await gameProvider.nextWeek();
                            },
                      backgroundColor: accentColor,
                      child: const Icon(Icons.calendar_today),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
