class GameRound {
  final int id;
  final int lobbyId;
  final int wordPairId;
  final int impostorId;

  GameRound({
    required this.id,
    required this.lobbyId,
    required this.wordPairId,
    required this.impostorId,
  });

  factory GameRound.fromJson(Map<String, dynamic> json) {
    return GameRound(
      id: json['id'],
      lobbyId: json['lobby_id'],
      wordPairId: json['word_pair_id'],
      impostorId: json['impostor_player_id'],
    );
  }
}
