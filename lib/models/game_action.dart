class GameAction {
  final String id;
  final String name;
  final String description;
  final String icon;
  final int healthChange;
  final int energyChange;
  final int happinessChange;
  final int moneyChange;
  final int energyCost;
  final Duration duration;
  final List<String> tags;

  const GameAction({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    this.healthChange = 0,
    this.energyChange = 0,
    this.happinessChange = 0,
    this.moneyChange = 0,
    this.energyCost = 0,
    this.duration = const Duration(hours: 1),
    this.tags = const [],
  });
}