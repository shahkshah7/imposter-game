class Lobby {
  final int id;
  final String code;

  Lobby({required this.id, required this.code});

  factory Lobby.fromJson(Map<String, dynamic> json) {
    return Lobby(
      id: json['id'],
      code: json['code'],
    );
  }
}
