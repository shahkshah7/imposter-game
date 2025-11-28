import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

class GameWebSocketHandler {
  final int lobbyId;
  final Function() onQuestionsUpdated;
  final Function() onVotePhaseStarted;

  GameWebSocketHandler({
    required this.lobbyId,
    required this.onQuestionsUpdated,
    required this.onVotePhaseStarted,
  });

  Future<void> init() async {
    final pusher = PusherChannelsFlutter.getInstance();

    await pusher.subscribe(
      channelName: "lobby.$lobbyId",
      onEvent: (PusherEvent event) {
        print("🔥 WS EVENT: ${event.eventName}");

        switch (event.eventName) {
          case "App\\Events\\QuestionAsked":
          case "App\\Events\\QuestionAnswered":
            onQuestionsUpdated();
            break;

          case "App\\Events\\VotePhaseStarted":
            onVotePhaseStarted();
            break;
        }
      },
    );
  }

  Future<void> dispose() async {
    final pusher = PusherChannelsFlutter.getInstance();
    await pusher.unsubscribe(channelName: "lobby.$lobbyId");
  }
}
