import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
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

  GameProvider() {
    _loadGameState();
  }

  Future<void> _loadGameState() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = prefs.getString('game_state');
      
      if (gameStateJson != null) {
        final gameStateMap = jsonDecode(gameStateJson);
        _gameState = GameState.fromJson(gameStateMap);
      }
    } catch (e) {
      print('Error loading game state: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveGameState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final gameStateJson = jsonEncode(_gameState.toJson());
      await prefs.setString('game_state', gameStateJson);
    } catch (e) {
      print('Error saving game state: $e');
    }
  }

  void startNewGame([DateTime? chosenDate]) {
    _gameState = GameState(
      isGameStarted: true,
      gameStartTime: chosenDate ?? DateTime.now(),
    );
    _saveGameState();
    notifyListeners();
  }

  Future<void> nextWeek() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate loading delay
      await Future.delayed(const Duration(seconds: 2));

      // Create a log summary of the week
      String logEntry = "Week completed on ${DateTime.now().toLocal().toString().split(' ')[0]} - "
          "Health: ${_gameState.health}, Happiness: ${_gameState.happiness}, Money: \$${_gameState.money}";
      
      // Append the log to existing weekly logs
      List<String> updatedLogs = List.from(_gameState.weeklyLogs)..add(logEntry);
      
      // Reset the week: start a new week (preserve money, and new start time may be kept as before)
      _gameState = GameState(
        isGameStarted: true,
        gameStartTime: _gameState.gameStartTime,
        money: _gameState.money,
        weeklyLogs: updatedLogs,
      );
      
      // Optionally, you may add a last action result message indicating the week reset.
      _lastActionResult = "Next week started!";
      await _saveGameState();
    } catch (e) {
      print('Error during next week transition: $e');
      _lastActionResult = "Error transitioning to next week.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void performAction(GameAction action) {
    if (_gameState.energy < action.energyCost) {
      _lastActionResult = "Not enough energy to perform this action!";
      notifyListeners();
      return;
    }

    // Calculate changes with some randomness
    final random = Random();
    final healthChange = action.healthChange + random.nextInt(5) - 2;
    final energyChange = action.energyChange + random.nextInt(5) - 2;
    final happinessChange = action.happinessChange + random.nextInt(5) - 2;
    final moneyChange = action.moneyChange + random.nextInt(10) - 5;

    // Add action to weekly logs
    String actionLog = "Day ${_gameState.currentDay}: ${action.name}";
    List<String> updatedLogs = List.from(_gameState.weeklyLogs)..add(actionLog);

    _gameState = _gameState.copyWith(
      health: (_gameState.health + healthChange).clamp(0, 100),
      energy: (_gameState.energy + energyChange - action.energyCost).clamp(0, 100),
      happiness: (_gameState.happiness + happinessChange).clamp(0, 100),
      money: (_gameState.money + moneyChange).clamp(0, 9999),
      completedActions: [..._gameState.completedActions, action.id],
      weeklyLogs: updatedLogs,
    );

    _lastActionResult = _generateActionResult(action, healthChange, energyChange, happinessChange, moneyChange);
    
    // Check if day should advance
    if (_gameState.completedActions.length >= 3) {
      _advanceDay();
    }

    _saveGameState();
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
      _completeWeek();
      return;
    }

    // Daily health decay
    _gameState = _gameState.copyWith(
      currentDay: _gameState.currentDay + 1,
      health: (_gameState.health - 5).clamp(0, 100),
      energy: 100, // Reset energy for new day
      completedActions: [], // Reset daily actions
    );

    _lastActionResult = "Day ${_gameState.currentDay - 1} completed! New day begins.";
  }

  void _completeWeek() {
    _lastActionResult = "Week completed! Final stats - Health: ${_gameState.health}, Happiness: ${_gameState.happiness}, Money: \$${_gameState.money}";
    
    // Reset for new week
    _gameState = GameState(
      isGameStarted: true,
      gameStartTime: DateTime.now(),
      money: _gameState.money, // Keep money between weeks
    );
  }

  void resetGame() {
    _gameState = GameState();
    _lastActionResult = null;
    _saveGameState();
    notifyListeners();
  }

  List<GameAction> getAvailableActions() {
    return GameActions.actions.where((action) {
      // Filter out actions that cost too much energy
      return _gameState.energy >= action.energyCost;
    }).toList();
  }

  void clearLastActionResult() {
    _lastActionResult = null;
    notifyListeners();
  }
}