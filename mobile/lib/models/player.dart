class Player {
  final int id;
  final int lobbyId;
  final String name;
  final String role;
  final String? word;

  Player({
    required this.id,
    required this.lobbyId,
    required this.name,
    required this.role,
    required this.word,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'],
      lobbyId: json['lobby_id'],
      name: json['name'],
      role: json['role'],
      word: json['word'],
    );
  }
}
