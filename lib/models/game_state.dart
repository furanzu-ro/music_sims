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
  final List<String> weeklyLogs;

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
    this.weeklyLogs = const [],
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
    List<String>? weeklyLogs,
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
      weeklyLogs: weeklyLogs ?? List.from(this.weeklyLogs),
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
      'weeklyLogs': weeklyLogs,
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
      weeklyLogs: json['weeklyLogs'] != null 
          ? List<String>.from(json['weeklyLogs']) 
          : [],
    );
  }
}