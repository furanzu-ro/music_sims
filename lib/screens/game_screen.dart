import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/game_action.dart';
import '../models/game_state.dart';
import '../utils/constants.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _artistName = '';
  String _realName = '';
  int _age = 0;
  String _profilePicture = '';
  String _gender = 'Male';
  String _description = '';
  String _genre = 'Classical';

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

          if (!gameProvider.isProfileComplete) {
            // Show profile form
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const Text(
                      'Create Your Profile',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Artist Name',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter artist name' : null,
                      onSaved: (value) => _artistName = value ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Real Name',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter real name' : null,
                      onSaved: (value) => _realName = value ?? '',
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter age';
                        final age = int.tryParse(value);
                        if (age == null || age <= 0) return 'Please enter a valid age';
                        return null;
                      },
                      onSaved: (value) => _age = int.tryParse(value ?? '0') ?? 0,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Profile Picture URL',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      onSaved: (value) => _profilePicture = value ?? '',
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _gender,
                      items: const [
                        DropdownMenuItem(value: 'Male', child: Text('Male')),
                        DropdownMenuItem(value: 'Female', child: Text('Female')),
                      ],
                      onChanged: (value) => setState(() => _gender = value ?? 'Male'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      maxLines: 3,
                      onSaved: (value) => _description = value ?? '',
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Genre',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      value: _genre,
                      items: const [
                        DropdownMenuItem(value: 'Classical', child: Text('Classical')),
                        DropdownMenuItem(value: 'Pop', child: Text('Pop')),
                        DropdownMenuItem(value: 'Rock', child: Text('Rock')),
                        DropdownMenuItem(value: 'Hip-hop', child: Text('Hip-hop')),
                        DropdownMenuItem(value: 'Electronic', child: Text('Electronic')),
                        DropdownMenuItem(value: 'Jazz', child: Text('Jazz')),
                        DropdownMenuItem(value: 'Blues', child: Text('Blues')),
                        DropdownMenuItem(value: 'Country', child: Text('Country')),
                        DropdownMenuItem(value: 'Folk', child: Text('Folk')),
                      ],
                      onChanged: (value) => setState(() => _genre = value ?? 'Classical'),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          gameProvider.setProfile(
                            artistName: _artistName,
                            realName: _realName,
                            age: _age,
                            profilePicture: _profilePicture,
                            gender: _gender,
                            description: _description,
                            genre: _genre,
                          );
                          gameProvider.startNewGame();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Start Game',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              Column(
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
                            _buildStatItem('Health', '${gameState.health}%', Icons.favorite, 
                              color: gameState.health > 50 ? accentColor : dangerColor),
                            _buildStatItem('Energy', '${gameState.energy}%', Icons.battery_charging_full,
                              color: gameState.energy > 30 ? accentColor : warningColor),
                            _buildStatItem('Happiness', '${gameState.happiness}%', Icons.mood),
                          ],
                        ),
                        const SizedBox(height: 10),
                        // Profile details row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            if (gameState.profilePicture.isNotEmpty)
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(gameState.profilePicture),
                              )
                            else
                              const CircleAvatar(
                                radius: 30,
                                child: Icon(Icons.person, size: 30),
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Artist: ${gameState.artistName}',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'Real Name: ${gameState.realName}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Age: ${gameState.age}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Gender: ${gameState.gender}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  'Genre: ${gameState.genre}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatItem('Money', '\$${gameState.money}', Icons.attach_money),
                            _buildStatItem('Week', 'Week ${_getWeekNumber(gameState)}', Icons.calendar_view_week),
                            _buildStatItem('Date', _formatDate(gameState.gameStartTime), Icons.date_range),
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
                  
                  // Actions List and Weekly Log in a scrollable view
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Actions List
                          ...gameProvider.getAvailableActions().map((action) => 
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _buildActionCard(context, action, gameProvider),
                            ),
                          ),
                          
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // Floating Next Week Button
              Positioned(
                bottom: 20,
                right: 20,
                child: ElevatedButton(
                  onPressed: gameProvider.isLoading ? null : () => gameProvider.nextWeek(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Next Week',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              // Weekly Log Section
              Positioned(
                left: 20,
                bottom: 80,
                right: 20,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Weekly Log',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Expanded(
                        child: gameState.weeklyLogs.isEmpty
                            ? const Center(
                                child: Text(
                                  'No logs yet. Start performing actions!',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              )
                            : ListView.builder(
                                itemCount: gameState.weeklyLogs.length,
                                itemBuilder: (context, index) {
                                  final logEntry = gameState.weeklyLogs[index];
                                  return Card(
                                    color: cardColor,
                                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: ListTile(
                                      leading: const Icon(Icons.history, color: accentColor),
                                      title: Text(
                                        logEntry,
                                        style: const TextStyle(color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              // Loading Overlay
              if (gameProvider.isLoading)
                Container(
                  color: Colors.black.withOpacity(0.7),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: accentColor,
                          strokeWidth: 4,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Advancing to next week...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
    // Allow tap always, show dialog if energy insufficient
    final canPerform = gameProvider.gameState.energy >= action.energyCost;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      child: InkWell(
        onTap: () => gameProvider.performAction(action, context: context),
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

  int _getWeekNumber(GameState gameState) {
    // Count completed weeks from weekly logs that contain "Week completed"
    int completedWeeks = gameState.weeklyLogs.where((String log) => log.contains('Week completed')).length;
    return completedWeeks + 1;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No Date';
    return '${date.month}/${date.day}/${date.year}';
  }
}
