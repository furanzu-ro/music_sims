import 'instagram_post.dart';

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

  // New profile fields
  final String artistName;
  final String realName;
  final int age;
  final String profilePicture;
  final String gender;
  final String description;
  final String genre;

  // New posts field
  final List<InstagramPost> posts;

  GameState({
    this.currentDay = 1,
    this.health = 100,
    this.energy = 100,
    this.happiness = 75,
    this.money = 0,
    this.stats = const {},
    this.completedActions = const [],
    this.isGameStarted = false,
    this.gameStartTime,
    this.artistName = '',
    this.realName = '',
    this.age = 0,
    this.profilePicture = '',
    this.gender = '',
    this.description = '',
    this.genre = '',
    this.posts = const [],
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
    String? artistName,
    String? realName,
    int? age,
    String? profilePicture,
    String? gender,
    String? description,
    String? genre,
    List<InstagramPost>? posts,
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
      artistName: artistName ?? this.artistName,
      realName: realName ?? this.realName,
      age: age ?? this.age,
      profilePicture: profilePicture ?? this.profilePicture,
      gender: gender ?? this.gender,
      description: description ?? this.description,
      genre: genre ?? this.genre,
      posts: posts ?? List.from(this.posts),
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
      'artistName': artistName,
      'realName': realName,
      'age': age,
      'profilePicture': profilePicture,
      'gender': gender,
      'description': description,
      'genre': genre,
      'posts': posts.map((post) => post.toJson()).toList(),
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
      artistName: json['artistName'] ?? '',
      realName: json['realName'] ?? '',
      age: json['age'] ?? 0,
      profilePicture: json['profilePicture'] ?? '',
      gender: json['gender'] ?? '',
      description: json['description'] ?? '',
      genre: json['genre'] ?? '',
      posts: json['posts'] != null
          ? List<InstagramPost>.from(
              (json['posts'] as List).map((postJson) => InstagramPost.fromJson(postJson)))
          : [],
    );
  }
}
