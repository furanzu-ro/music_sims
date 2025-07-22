import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:music_sims/models/instagram_post.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';
import '../models/game_action.dart';
import '../data/game_actions.dart';

class GameProvider extends ChangeNotifier {
  GameState _gameState = GameState();
  bool _isLoading = false;
  String? _lastActionResult;

  GameState get gameState => _gameState;
  bool get isLoading => _isLoading;
  String? get lastActionResult => _lastActionResult;

  GameProvider();

  Future<bool> loadGameState() async {
    _isLoading = true;
    notifyListeners();

    bool hasSave = false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = prefs.getString('game_state');
      
      if (gameStateJson != null) {
        final gameStateMap = jsonDecode(gameStateJson);
        _gameState = GameState.fromJson(gameStateMap);
        if (_gameState.isGameStarted) {
          hasSave = true;
        }
      }
    } catch (e) {
      print('Error loading game state: $e');
      _gameState = GameState();
    }

    _isLoading = false;
    notifyListeners();
    return hasSave;
  }

  Future<void> saveGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = jsonEncode(_gameState.toJson());
      await prefs.setString('game_state', gameStateJson);
    } catch (e) {
      print('Error saving game state: $e');
    }
  }

  bool get isProfileComplete {
    return _gameState.artistName.isNotEmpty &&
        _gameState.realName.isNotEmpty &&
        _gameState.age > 0 &&
        _gameState.gender.isNotEmpty &&
        _gameState.genre.isNotEmpty;
  }

  void setProfile({
    required String artistName,
    required String realName,
    required int age,
    required String profilePicture,
    required String gender,
    required String description,
    required String genre,
  }) {
    _gameState = _gameState.copyWith(
      artistName: artistName,
      realName: realName,
      age: age,
      profilePicture: profilePicture,
      gender: gender,
      description: description,
      genre: genre,
    );
    notifyListeners();
    saveGameState();

    // Automatically start the game after profile is set
    if (isProfileComplete && !_gameState.isGameStarted) {
      startNewGame();
    }
  }

  void startNewGame([DateTime? chosenDate]) {
    if (!isProfileComplete) {
      _lastActionResult = "Please complete your profile before starting the game.";
      notifyListeners();
      return;
    }
    _gameState = _gameState.copyWith(
      isGameStarted: true,
      gameStartTime: chosenDate ?? DateTime.now(),
    );
    saveGameState();
    notifyListeners();
  }

  Future<void> nextWeek() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 2));

      // Complete the current week and reset
      _completeWeek();

      // Update the game start time by adding 7 days
      if (_gameState.gameStartTime != null) {
        _gameState = _gameState.copyWith(
          gameStartTime: _gameState.gameStartTime!.add(const Duration(days: 7)),
        );
      } else {
        _gameState = _gameState.copyWith(
          gameStartTime: DateTime.now(),
        );
      }

      _lastActionResult = null; // Remove popup message
      await saveGameState();
    } catch (e) {
      print('Error during next week transition: $e');
      _lastActionResult = null; // Remove popup message on error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void performAction(GameAction action, {required BuildContext context}) {
    if (_gameState.energy < action.energyCost) {
      // Show dialog instead of blocking tap
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Energy not enough!'),
          content: const Text('You do not have enough energy to perform this action.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Calculate changes with some randomness
    final random = Random();
    final healthChange = action.healthChange + random.nextInt(5) - 2;
    final energyChange = action.energyChange + random.nextInt(5) - 2;
    final happinessChange = action.happinessChange + random.nextInt(5) - 2;
    final moneyChange = action.moneyChange + random.nextInt(10) - 5;

    // Removed weekly log related code
        "${healthChange > 0 ? '+$healthChange health' : '$healthChange health'}, "
        "${energyChange > 0 ? '+$energyChange energy' : '$energyChange energy'}, "
        "${happinessChange > 0 ? '+$happinessChange happiness' : '$happinessChange happiness'}, "
        "${moneyChange > 0 ? '+\$$moneyChange' : '-\$${moneyChange.abs()}'}.";

    // Removed weeklyLogs related code
    _gameState = _gameState.copyWith(
      health: (_gameState.health + healthChange).clamp(0, 100),
      energy: (_gameState.energy + energyChange - action.energyCost).clamp(0, 100),
      happiness: (_gameState.happiness + happinessChange).clamp(0, 100),
      money: (_gameState.money + moneyChange).clamp(0, 9999),
      completedActions: [..._gameState.completedActions, action.id],
    );


    _lastActionResult = _generateActionResult(action, healthChange, energyChange, happinessChange, moneyChange);
    
    // Check if day should advance
    if (_gameState.completedActions.length >= 3) {
      _advanceDay();
    }

    saveGameState();
    notifyListeners();
  }

  String _generateActionResult(GameAction action, int health, int energy, int happiness, int money) {
    List<String> results = [];
    
    if (health > 0) results.add("+$health Health");
    if (health < 0) results.add("$health Health");
    if (energy > 0) results.add("+$energy Energy");
    if (energy < 0) results.add("$energy Energy");
    if (happiness > 0) results.add("+$happiness Happiness");
    if (happiness < 0) results.add("$happiness Happiness");
    if (money > 0) results.add("+\$$money");
    if (money < 0) results.add("-\$${money.abs()}");

    return "You ${action.name.toLowerCase()}! ${results.join(', ')}";
  }

  void _advanceDay() {
    if (_gameState.currentDay >= 7) {
      // Don't auto-advance to next week, just complete the current day
      _gameState = _gameState.copyWith(
        health: (_gameState.health - 5).clamp(0, 100),
        energy: 100, // Reset energy for new day
        completedActions: [], // Reset daily actions
      );
      // Remove the "Day __ Completed" pop-up message
      _lastActionResult = null;
      return;
    }

    // Daily health decay
    _gameState = _gameState.copyWith(
      currentDay: _gameState.currentDay + 1,
      health: (_gameState.health - 5).clamp(0, 100),
      energy: 100, // Reset energy for new day
      completedActions: [], // Reset daily actions
    );

    // Remove the "Day X completed! New day begins." message by clearing _lastActionResult
    _lastActionResult = null;
  }

  void _completeWeek() {
    // This method is now only called by nextWeek() button
    // Removed weeklyLogs related code
    _lastActionResult = "Week completed! Final stats - Health: ${_gameState.health}, Happiness: ${_gameState.happiness}, Money: \$${_gameState.money}";
    
    // Preserve Health, Energy, and Happiness when transitioning to next week
    _gameState = _gameState.copyWith(
      currentDay: 1,
      completedActions: [], // Reset daily actions for new week
      // Health, energy, and happiness remain unchanged
    );
  }

  Future<void> resetGame() async {
    _gameState = GameState();
    _lastActionResult = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('game_state');
    notifyListeners();
  }

  List<GameAction> getAvailableActions() {
    return GameActions.actions;
  }

  void clearLastActionResult() {
    _lastActionResult = null;
    notifyListeners();
  }

  // New method to add a post
  void addPost(String imageUrl, String caption) {
    final newPost = InstagramPost(imageUrl: imageUrl, caption: caption);
    final updatedPosts = List<InstagramPost>.from(_gameState.posts)..add(newPost);
    _gameState = _gameState.copyWith(posts: updatedPosts);
    saveGameState();
    notifyListeners();
  }
}
