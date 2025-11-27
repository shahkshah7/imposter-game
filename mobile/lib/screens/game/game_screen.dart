import 'package:flutter/material.dart';
import 'package:imposter_game/models/player.dart';
import 'package:imposter_game/models/lobby.dart';
import 'package:imposter_game/models/question.dart';
import 'package:imposter_game/services/game_service.dart';
import 'package:imposter_game/services/question_service.dart';

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

  @override
  void initState() {
    super.initState();
    _loadQuestions();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your word: ${widget.player.word ?? ''}"),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAskQuestionDialog(),
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
    final controller = TextEditingController();
    int? selectedTargetId;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Ask a question"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration:
                    const InputDecoration(labelText: "Enter question"),
              ),

              const SizedBox(height: 10),

              DropdownButton<int>(
                value: selectedTargetId,
                hint: const Text("Select target player"),
                isExpanded: true,
                items: [
                  // TODO: Add player list
                ],
                onChanged: (value) {
                  setState(() {
                    selectedTargetId = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (selectedTargetId == null) return;

                await QuestionService.askQuestion(
                  widget.roundId,
                  widget.player.id,
                  selectedTargetId!,
                  controller.text.trim(),
                );

                Navigator.pop(context);
                _loadQuestions();
              },
              child: const Text("Send"),
            )
          ],
        );
      },
    );
  }
}
