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
  DateTime _startingDate = DateTime.now();

  Future<void> _pickStartingDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: accentColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _startingDate) {
      setState(() {
        _startingDate = picked;
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${_monthName(date.month)} ${date.day}, ${date.year}";
  }

  String _monthName(int month) {
    const monthNames = [
      "", "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return monthNames[month];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          final gameState = gameProvider.gameState;

          if (!gameProvider.isProfileComplete) {
            // Show profile creation form
            return Stack(
              fit: StackFit.expand,
              children: [
                // Background image
                Image.network(
                  'https://images.pexels.com/photos/1190298/pexels-photo-1190298.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [primaryColor, bgColor],
                        ),
                      ),
                    );
                  },
                ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        bgColor.withOpacity(0.9),
                        primaryColor.withOpacity(0.7),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(24),
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
                                const Icon(
                                  Icons.person_add,
                                  size: 60,
                                  color: accentColor,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Create Your Artist Profile',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Pacifico',
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tell us about your musical journey',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Form fields
                          _buildFormField(
                            label: 'Artist Name',
                            icon: Icons.music_note,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter artist name' : null,
                            onSaved: (value) => _artistName = value ?? '',
                          ),
                          const SizedBox(height: 16),
                          
                          _buildFormField(
                            label: 'Real Name',
                            icon: Icons.person,
                            validator: (value) => value == null || value.isEmpty ? 'Please enter real name' : null,
                            onSaved: (value) => _realName = value ?? '',
                          ),
                          const SizedBox(height: 16),
                          
                          _buildFormField(
                            label: 'Age',
                            icon: Icons.cake,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) return 'Please enter age';
                              final age = int.tryParse(value);
                              if (age == null || age <= 0) return 'Please enter a valid age';
                              return null;
                            },
                            onSaved: (value) => _age = int.tryParse(value ?? '0') ?? 0,
                          ),
                          const SizedBox(height: 16),
                          
                          _buildFormField(
                            label: 'Profile Picture URL (Optional)',
                            icon: Icons.image,
                            onSaved: (value) => _profilePicture = value ?? '',
                          ),
                          const SizedBox(height: 16),
                          
                          _buildDropdownField(
                            label: 'Gender',
                            icon: Icons.person_outline,
                            value: _gender,
                            items: const ['Male', 'Female', 'Other'],
                            onChanged: (value) => setState(() => _gender = value ?? 'Male'),
                          ),
                          const SizedBox(height: 16),
                          
                          _buildFormField(
                            label: 'Description',
                            icon: Icons.description,
                            maxLines: 3,
                            onSaved: (value) => _description = value ?? '',
                          ),
                          const SizedBox(height: 16),
                          
                          _buildDropdownField(
                            label: 'Music Genre',
                            icon: Icons.library_music,
                            value: _genre,
                            items: const ['Classical', 'Pop', 'Rock', 'Hip-hop', 'Electronic', 'Jazz', 'Blues', 'Country', 'Folk'],
                            onChanged: (value) => setState(() => _genre = value ?? 'Classical'),
                          ),
                          const SizedBox(height: 16),
                          
                          // Starting Date Field
                          GestureDetector(
                            onTap: _pickStartingDate,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: cardColor.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: primaryColor.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: accentColor),
                                  const SizedBox(width: 16),
                                  Text(
                                    "Starting Date: ${_formatDate(_startingDate)}",
                                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Create Artist Button
                          Container(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  _formKey.currentState?.save();
                                  
                                  // Show loading dialog
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                      child: Card(
                                        color: cardColor,
                                        child: Padding(
                                          padding: EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(color: accentColor),
                                              SizedBox(height: 16),
                                              Text(
                                                'Creating your artist profile...',
                                                style: TextStyle(color: Colors.white, fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  
                                  // Simulate loading
                                  await Future.delayed(const Duration(seconds: 2));
                                  
                                  gameProvider.setProfile(
                                    artistName: _artistName,
                                    realName: _realName,
                                    age: _age,
                                    profilePicture: _profilePicture,
                                    gender: _gender,
                                    description: _description,
                                    genre: _genre,
                                  );
                                  gameProvider.startNewGame(_startingDate);
                                  
                                  Navigator.of(context).pop(); // Close loading dialog
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                                elevation: 8,
                                shadowColor: accentColor.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, size: 24),
                                  SizedBox(width: 12),
                                  Text(
                                    'Create Artist',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          // Game Home Screen (with bottom nav)
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
                              child: Column(
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
                                    '\$${gameState.money} • Week ${_getWeekNumber(gameState)} (${gameState.gameStartTime != null ? _formatDate(gameState.gameStartTime!) : "No Date"})',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 14,
                                    ),
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
                  
                  // Action Result
                  if (gameProvider.lastActionResult != null)
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
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
                  
                  // Actions Grid
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 200), // Extra bottom padding for weekly log
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Daily Actions',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.5,
                            ),
                            itemCount: gameProvider.getAvailableActions().length,
                            itemBuilder: (context, index) {
                              final action = gameProvider.getAvailableActions()[index];
                              return _buildActionCard(context, action, gameProvider);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              // Weekly Log at bottom
              Positioned(
                left: 16,
                right: 16,
                bottom: 16,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            const Icon(Icons.history, color: accentColor),
                            const SizedBox(width: 8),
                            const Text(
                              'Weekly Log',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: gameProvider.isLoading ? null : () => gameProvider.nextWeek(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accentColor,
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Next Week',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: gameState.weeklyLogs.isEmpty
                            ? const Center(
                                child: Text(
                                  'No activities yet. Start performing actions!',
                                  style: TextStyle(color: Colors.white70),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: gameState.weeklyLogs.length,
                                itemBuilder: (context, index) {
                                  final logEntry = gameState.weeklyLogs[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: primaryColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      logEntry,
                                      style: const TextStyle(color: Colors.white, fontSize: 12),
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

  Widget _buildFormField({
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    void Function(String?)? onSaved,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          prefixIcon: Icon(icon, color: accentColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          prefixIcon: Icon(icon, color: accentColor),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
        value: value,
        dropdownColor: cardColor,
        style: const TextStyle(color: Colors.white),
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(item, style: const TextStyle(color: Colors.white)),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildCompactStat(String label, int value, IconData icon, {Color? color}) {
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

  Widget _buildActionCard(BuildContext context, GameAction action, GameProvider gameProvider) {
    final canPerform = gameProvider.gameState.energy >= action.energyCost;
    
    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => gameProvider.performAction(action, context: context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      action.icon,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      action.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: canPerform ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                  if (action.energyCost > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: canPerform ? accentColor : Colors.grey,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${action.energyCost}⚡',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                action.description,
                style: TextStyle(
                  fontSize: 10,
                  color: canPerform ? Colors.white70 : Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getWeekNumber(GameState gameState) {
    int completedWeeks = gameState.weeklyLogs.where((String log) => log.contains('Week completed')).length;
    return completedWeeks + 1;
  }
}
