import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_action.dart';
import '../utils/constants.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Next Week Simulator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          final gameState = gameProvider.gameState;
          
          return Column(
            children: [
              // Stats Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('Day', '${gameState.currentDay}/7', Icons.calendar_today),
                        _buildStatItem('Health', '${gameState.health}%', Icons.favorite, 
                          color: gameState.health > 50 ? accentColor : dangerColor),
                        _buildStatItem('Energy', '${gameState.energy}%', Icons.battery_charging_full,
                          color: gameState.energy > 30 ? accentColor : warningColor),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatItem('Happiness', '${gameState.happiness}%', Icons.mood),
                        _buildStatItem('Money', '\$${gameState.money}', Icons.attach_money),
                        _buildStatItem('Actions', '${gameState.completedActions.length}/3', Icons.check_circle),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Action Result
              if (gameProvider.lastActionResult != null)
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: accentColor),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: accentColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          gameProvider.lastActionResult!,
                          style: const TextStyle(color: accentColor),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: gameProvider.clearLastActionResult,
                        color: accentColor,
                      ),
                    ],
                  ),
                ),
              
              // Actions List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: gameProvider.getAvailableActions().length,
                  itemBuilder: (context, index) {
                    final action = gameProvider.getAvailableActions()[index];
                    return _buildActionCard(context, action, gameProvider);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, {Color? color}) {
    return Column(
      children: [
        Icon(icon, color: color ?? Colors.white70),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, GameAction action, GameProvider gameProvider) {
    final canPerform = gameProvider.gameState.energy >= action.energyCost;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      child: InkWell(
        onTap: canPerform ? () => gameProvider.performAction(action) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    action.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          action.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: canPerform ? Colors.white : Colors.grey,
                          ),
                        ),
                        Text(
                          action.description,
                          style: TextStyle(
                            color: canPerform ? Colors.white70 : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (action.energyCost > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: canPerform ? primaryColor : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${action.energyCost} Energy',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  if (action.healthChange != 0)
                    _buildEffectChip('Health', action.healthChange, Icons.favorite),
                  if (action.energyChange != 0)
                    _buildEffectChip('Energy', action.energyChange, Icons.battery_charging_full),
                  if (action.happinessChange != 0)
                    _buildEffectChip('Happiness', action.happinessChange, Icons.mood),
                  if (action.moneyChange != 0)
                    _buildEffectChip('Money', action.moneyChange, Icons.attach_money),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEffectChip(String label, int value, IconData icon) {
    final isPositive = value > 0;
    final color = isPositive ? accentColor : dangerColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}$value',
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}