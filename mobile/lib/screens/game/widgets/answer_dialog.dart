import 'package:flutter/material.dart';
import 'package:imposter_game/models/question.dart';
import 'package:imposter_game/services/question_service.dart';

class AnswerDialog extends StatelessWidget {
  final Question question;
  final Function onAnswered;

  const AnswerDialog({
    super.key,
    required this.question,
    required this.onAnswered,
  });

  final List<String> presetAnswers = const [
    "Yes",
    "No",
    "Maybe",
    "Sometimes",
    "Often",
    "Rarely",
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Question from ${question.asker}"),
      content: Text(question.text),
      actions: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: presetAnswers.map((answer) {
            return ElevatedButton(
              onPressed: () async {
                await QuestionService.answerQuestion(question.id, answer);
                Navigator.pop(context);
                onAnswered();
              },
              child: Text(answer),
            );
          }).toList(),
        ),
      ],
    );
  }
}
