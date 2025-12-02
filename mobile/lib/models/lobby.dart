class Lobby {
  final int id;
  final String code;
  final int? hostId;

  Lobby({
    required this.id,
    required this.code,
    this.hostId,
  });

  factory Lobby.fromJson(Map<String, dynamic> json) {
    return Lobby(
      id: json['id'] as int,
      code: json['code'] as String,
      hostId: json['host_id'] as int?,
    );
  }
}
