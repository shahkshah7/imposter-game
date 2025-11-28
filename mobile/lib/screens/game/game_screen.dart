import 'package:flutter/material.dart';
import 'package:imposter_game/models/player.dart';
import 'package:imposter_game/models/lobby.dart';
import 'package:imposter_game/models/question.dart';
import 'package:imposter_game/services/question_service.dart';
import 'package:imposter_game/screens/game/widgets/ask_question_dialog.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import 'package:imposter_game/services/websocket_service.dart';
import 'package:imposter_game/screens/game/widgets/answer_dialog.dart';
import 'package:imposter_game/screens/game/voting_screen.dart';

class GameScreen extends StatefulWidget {
  final Player player;
  final Lobby lobby;
  final int roundId;

  const GameScreen({
    super.key,
    required this.player,
    required this.lobby,
    required this.roundId,
  });

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Question> _questions = [];
  bool _loading = true;

  // -----------------------------
  // FEATURE B – Answer popup logic
  // -----------------------------
  void _checkForAnswerPopup() {
    for (var q in _questions) {
      final bool isTarget = q.target == widget.player.name;
      final bool noAnswer = q.answer == null && q.hasAnswer == false;

      if (isTarget && noAnswer) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AnswerDialog(
            question: q,
            onAnswered: _loadQuestions,
          ),
        );
        break;
      }
    }
  }

  // -----------------------------
  // FEATURE C – Vote screen navigation
  // -----------------------------
  void _goToVotingScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VotingScreen(
          roundId: widget.roundId,
          player: widget.player,
          lobbyId: widget.lobby.id,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // WebSocket subscription for real-time updates
    WebSocketService.subscribeToLobby(
      widget.lobby.id,
      (PusherEvent event) {
        print("🔥 WebSocket EVENT: ${event.eventName}");
        print("📦 Data: ${event.data}");

        // Handle VotePhaseStarted
        if (event.eventName == "App\\Events\\VotePhaseStarted") {
          print("🚨 Vote phase started — navigating to voting screen");
          _goToVotingScreen();
          return;
        }

        // Handle QuestionAsked / QuestionAnswered
        if (event.eventName == "App\\Events\\QuestionAsked" ||
            event.eventName == "App\\Events\\QuestionAnswered") {
          _loadQuestions();
          return;
        }

        // Fallback: reload questions on any unexpected event
        _loadQuestions();
      },
    );

    // Initial load
    _loadQuestions();
  }

  @override
  void dispose() {
    WebSocketService.unsubscribeFromLobby(widget.lobby.id);
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    final q = await QuestionService.getQuestions(
      widget.roundId,
      widget.player.id,
    );

    setState(() {
      _questions = q;
      _loading = false;
    });

    _checkForAnswerPopup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your word: ${widget.player.word ?? ''}"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAskQuestionDialog,
        child: const Icon(Icons.help_outline),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final q = _questions[index];

                return ListTile(
                  title: Text("${q.asker} → ${q.target}"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(q.text),
                      if (q.answer != null)
                        Text(
                          "Answer: ${q.answer}",
                          style: const TextStyle(color: Colors.blue),
                        )
                      else if (q.hasAnswer)
                        const Text(
                          "Answered",
                          style: TextStyle(color: Colors.green),
                        )
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _openAskQuestionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AskQuestionDialog(
          lobbyId: widget.lobby.id,
          roundId: widget.roundId,
          currentPlayer: widget.player,
          onQuestionSent: _loadQuestions,
        );
      },
    );
  }
}
