class WebSocketService {
  static Future<void> init() async {}

  static Future<void> subscribeToLobby(
    int lobbyId,
    void Function(dynamic event) onEvent,
  ) async {}

  static Future<void> broadcastTyping({
    required int lobbyId,
    required String playerName,
    required bool isTyping,
  }) async {}

  static Future<void> broadcastAnswering({
    required int lobbyId,
    required String playerName,
    required bool isAnswering,
  }) async {}

  static Future<void> unsubscribeFromLobby(int lobbyId) async {}
}
