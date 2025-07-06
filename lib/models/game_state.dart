class GameState {
  final int currentDay;
  final int health;
  final int energy;
  final int happiness;
  final int money;
  final Map<String, int> stats;
  final List<String> completedActions;
  final bool isGameStarted;
  final DateTime? gameStartTime;

  GameState({
    this.currentDay = 1,
    this.health = 100,
    this.energy = 100,
    this.happiness = 75,
    this.money = 500,
    this.stats = const {},
    this.completedActions = const [],
    this.isGameStarted = false,
    this.gameStartTime,
  });

  GameState copyWith({
    int? currentDay,
    int? health,
    int? energy,
    int? happiness,
    int? money,
    Map<String, int>? stats,
    List<String>? completedActions,
    bool? isGameStarted,
    DateTime? gameStartTime,
  }) {
    return GameState(
      currentDay: currentDay ?? this.currentDay,
      health: health ?? this.health,
      energy: energy ?? this.energy,
      happiness: happiness ?? this.happiness,
      money: money ?? this.money,
      stats: stats ?? Map.from(this.stats),
      completedActions: completedActions ?? List.from(this.completedActions),
      isGameStarted: isGameStarted ?? this.isGameStarted,
      gameStartTime: gameStartTime ?? this.gameStartTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentDay': currentDay,
      'health': health,
      'energy': energy,
      'happiness': happiness,
      'money': money,
      'stats': stats,
      'completedActions': completedActions,
      'isGameStarted': isGameStarted,
      'gameStartTime': gameStartTime?.toIso8601String(),
    };
  }

  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      currentDay: json['currentDay'] ?? 1,
      health: json['health'] ?? 100,
      energy: json['energy'] ?? 100,
      happiness: json['happiness'] ?? 75,
      money: json['money'] ?? 500,
      stats: Map<String, int>.from(json['stats'] ?? {}),
      completedActions: List<String>.from(json['completedActions'] ?? []),
      isGameStarted: json['isGameStarted'] ?? false,
      gameStartTime: json['gameStartTime'] != null 
          ? DateTime.parse(json['gameStartTime']) 
          : null,
    );
  }
}