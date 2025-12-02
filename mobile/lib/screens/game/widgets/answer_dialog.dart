import 'package:flutter/material.dart';
import 'package:imposter_game/models/question.dart';
import 'package:imposter_game/services/question_service.dart';
import 'package:imposter_game/services/websocket_service.dart';

class AnswerDialog extends StatefulWidget {
  final Question question;
  final Function onAnswered;

  const AnswerDialog({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  @override
  State<AnswerDialog> createState() => _AnswerDialogState();
}

class _AnswerDialogState extends State<AnswerDialog> {
  final List<String> presetAnswers = const [
    "Yes",
    "No",
    "Maybe",
    "Sometimes",
    "Often",
    "Rarely",
  ];

  @override
  void initState() {
    super.initState();

    // Debug print
    print("START ANSWERING → ${widget.question.target} (lobby ${widget.question.roundLobbyId})");

    // Begin answering indicator
    if (widget.question.roundLobbyId != null) {
      WebSocketService.broadcastAnswering(
        lobbyId: widget.question.roundLobbyId!,
        playerName: widget.question.target,
        isAnswering: true,
      );
    }
  }

  @override
  void dispose() {
    // Debug print
    print("STOP ANSWERING → ${widget.question.target}");

    // Stop answering indicator
    if (widget.question.roundLobbyId != null) {
      WebSocketService.broadcastAnswering(
        lobbyId: widget.question.roundLobbyId!,
        playerName: widget.question.target,
        isAnswering: false,
      );
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Question from ${widget.question.asker}"),
      content: Text(widget.question.text),
      actions: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presetAnswers.map((answer) {
            return ElevatedButton(
              onPressed: () async {
                await QuestionService.answerQuestion(widget.question.id, answer);

                // Stop answering on submit
                if (widget.question.roundLobbyId != null) {
                  WebSocketService.broadcastAnswering(
                    lobbyId: widget.question.roundLobbyId!,
                    playerName: widget.question.target,
                    isAnswering: false,
                  );
                }

                Navigator.pop(context);
                widget.onAnswered();
              },
              child: Text(answer),
            );
          }).toList(),
        ),
      ],
    );
  }
}
