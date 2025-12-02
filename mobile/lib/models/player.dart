class Player {
  final int id;
  final int? lobbyId;
  final String name;
  final String? word;

  Player({
    required this.id,
    required this.name,
    this.lobbyId,
    this.word,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as int,
      name: json['name'] as String,
      lobbyId: json['lobby_id'] as int?,
      word: json['word'] as String?,
    );
  }
}
