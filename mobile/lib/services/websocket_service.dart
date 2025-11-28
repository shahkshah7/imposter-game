import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class WebSocketService {
  static final PusherChannelsFlutter _pusher =
      PusherChannelsFlutter.getInstance();

  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    await _pusher.init(
      apiKey: "localkey123",   // REVERB_APP_KEY from .env
      cluster: "mt1",          // can be anything, must match backend
      useTLS: false,
      onEvent: (PusherEvent event) {
        // Optional global logging
        // print("WS EVENT: ${event.eventName} -> ${event.data}");
      },
      // For Laravel Reverb (self-hosted) we override host/port:
      wsPort: 8080,            // REVERB_PORT
      wsHost: "127.0.0.1",     // REVERB_HOST (or your LAN IP / host)
      enableLogging: true,
    );

    await _pusher.connect();
    _initialized = true;
  }

  static Future<void> subscribeToLobby(
    int lobbyId,
    void Function(PusherEvent) onEvent,
  ) async {
    await init();

    await _pusher.subscribe(
      channelName: "lobby.$lobbyId",
      onEvent: onEvent,
    );
  }

  static Future<void> unsubscribeFromLobby(int lobbyId) async {
    await _pusher.unsubscribe(channelName: "lobby.$lobbyId");
  }
}
