import 'dart:convert';

import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class WebSocketService {
  static final PusherChannelsFlutter _pusher =
      PusherChannelsFlutter.getInstance();
  static PusherChannel? _channel;
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;

    try {
      await _pusher.init(
        apiKey: "localkey123",
        cluster: "mt1",
        useTLS: false,
        onConnectionStateChange: (currentState, previousState) {
          print("Pusher connection: $previousState → $currentState");
        },
        onError: (message, code, error) {
          print("Pusher error: $message | code=$code | error=$error");
        },
        onEvent: (event) {
          print("WS EVENT: ${event.eventName} → ${event.data}");
        },
      );

      await _pusher.connect();
      _initialized = true;
    } catch (e) {
      print("Pusher init error: $e");
    }
  }

  static Future<void> subscribeToLobby(
    int lobbyId,
    void Function(PusherEvent event) onEvent,
  ) async {
    await init();

    final channelName = "lobby.$lobbyId";

    _channel = await _pusher.subscribe(
      channelName: channelName,
      onEvent: (event) {
        final normalizedData = _decodeData(event.data);
        final normalizedEvent = PusherEvent(
          channelName: event.channelName,
          eventName: event.eventName,
          data: normalizedData,
          userId: event.userId,
        );
        onEvent(normalizedEvent);
      },
    );

    print("Subscribed to $channelName");
  }

  static Future<void> _clientEvent({
    required String eventName,
    required Map<String, dynamic> data,
  }) async {
    if (_channel == null) return;

    final channelName = _channel!.channelName;
    if (!channelName.startsWith("private-") &&
        !channelName.startsWith("presence-")) {
      print(
          "Client events require private/presence channel. Skipping $eventName on $channelName");
      return;
    }

    await _channel!.trigger(
      PusherEvent(
        channelName: channelName,
        eventName: eventName,
        data: jsonEncode(data),
      ),
    );
  }

  static Future<void> broadcastTyping({
    required int lobbyId,
    required String playerName,
    required bool isTyping,
  }) async {
    await _clientEvent(
      eventName: isTyping ? "client-typing-start" : "client-typing-stop",
      data: {"player": playerName},
    );
  }

  static Future<void> broadcastAnswering({
    required int lobbyId,
    required String playerName,
    required bool isAnswering,
  }) async {
    await _clientEvent(
      eventName: isAnswering ? "client-answering-start" : "client-answering-stop",
      data: {"player": playerName},
    );
  }

  static Future<void> unsubscribeFromLobby(int lobbyId) async {
    final channelName = "lobby.$lobbyId";
    if (_channel != null) {
      await _pusher.unsubscribe(channelName: channelName);
      _channel = null;
    }
    print("Unsubscribed from $channelName");
  }

  static dynamic _decodeData(dynamic data) {
    if (data is String) {
      try {
        return jsonDecode(data);
      } catch (_) {
        return data;
      }
    }
    return data;
  }
}
