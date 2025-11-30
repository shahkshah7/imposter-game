import 'dart:io' show Platform;

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
import 'package:imposter_game/screens/game/widgets/typing_indicator.dart';

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

  String? _currentlyTypingPlayer;
  String? _currentlyAnsweringPlayer;

  // ANSWER POPUP
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

  // VOTING
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

    if (Platform.isAndroid || Platform.isIOS) {
      WebSocketService.subscribeToLobby(
        widget.lobby.id,
        (PusherEvent event) {
          print("WebSocket EVENT: ${event.eventName}");
          print("DATA: ${event.data}");

          // ---------------- VOTE PHASE ----------------
          if (event.eventName == "App\\Events\\VotePhaseStarted") {
            _goToVotingScreen();
            return;
          }

          // ---------------- TYPING START ----------------
          if (event.eventName == "typing.start") {
            final data = event.data;
            if (data["player"] != widget.player.name) {
              setState(() => _currentlyTypingPlayer = data["player"]);
            }
            return;
          }

          // ---------------- TYPING STOP ----------------
          if (event.eventName == "typing.stop") {
            final data = event.data;
            if (_currentlyTypingPlayer == data["player"]) {
              setState(() => _currentlyTypingPlayer = null);
            }
            return;
          }

          // ---------------- ANSWERING START ----------------
          if (event.eventName == "answering.start") {
            final data = event.data;

            if (data["player"] != widget.player.name) {
              setState(() => _currentlyAnsweringPlayer = data["player"]);
            }

            // hide typing indicator during answer
            setState(() => _currentlyTypingPlayer = null);
            return;
          }

          // ---------------- ANSWERING STOP ----------------
          if (event.eventName == "answering.stop") {
            final data = event.data;

            if (_currentlyAnsweringPlayer == data["player"]) {
              setState(() => _currentlyAnsweringPlayer = null);
            }

            return;
          }

          // ---------------- QUESTION ASKED / ANSWERED ----------------
          if (event.eventName == "App\\Events\\QuestionAsked" ||
              event.eventName == "App\\Events\\QuestionAnswered") {
            _loadQuestions();
            return;
          }

          // fallback
          _loadQuestions();
        },
      );
    }

    _loadQuestions();
  }

  @override
  void dispose() {
    if (Platform.isAndroid || Platform.isIOS) {
      WebSocketService.unsubscribeFromLobby(widget.lobby.id);
    }
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
        onPressed: _currentlyAnsweringPlayer == null
            ? _openAskQuestionDialog
            : null,
        child: const Icon(Icons.help_outline),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ANSWERING INDICATOR
                if (_currentlyAnsweringPlayer != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${_currentlyAnsweringPlayer!} is answering…",
                      style: const TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                // TYPING INDICATOR
                if (_currentlyAnsweringPlayer == null &&
                    _currentlyTypingPlayer != null)
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: TypingIndicator(
                      playerName: _currentlyTypingPlayer!,
                    ),
                  ),

                // QUESTION LIST
                Expanded(
                  child: ListView.builder(
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
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
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
