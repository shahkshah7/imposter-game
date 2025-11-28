import 'package:flutter/material.dart';
import 'package:imposter_game/models/player.dart';
import 'package:imposter_game/services/player_service.dart';
import 'package:imposter_game/services/question_service.dart';

class AskQuestionDialog extends StatefulWidget {
  final int lobbyId;
  final int roundId;
  final Player currentPlayer;
  final VoidCallback onQuestionSent;

  const AskQuestionDialog({
    super.key,
    required this.lobbyId,
    required this.roundId,
    required this.currentPlayer,
    required this.onQuestionSent,
  });

  @override
  State<AskQuestionDialog> createState() => _AskQuestionDialogState();
}

class _AskQuestionDialogState extends State<AskQuestionDialog> {
  final TextEditingController _questionController = TextEditingController();
  List<Player> _players = [];
  int? _selectedTargetId;
  bool _loadingPlayers = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  Future<void> _loadPlayers() async {
    try {
      final players = await PlayerService.getPlayers(widget.lobbyId);

      // remove self from target options
      players.removeWhere((p) => p.id == widget.currentPlayer.id);

      setState(() {
        _players = players;
        _loadingPlayers = false;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load players";
        _loadingPlayers = false;
      });
    }
  }

  Future<void> _sendQuestion() async {
    if (_selectedTargetId == null) return;
    if (_questionController.text.trim().isEmpty) return;

    await QuestionService.askQuestion(
      widget.roundId,
      widget.currentPlayer.id,
      _selectedTargetId!,
      _questionController.text.trim(),
    );

    widget.onQuestionSent();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Ask a question"),
      content: _loadingPlayers
          ? const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                TextField(
                  controller: _questionController,
                  decoration: const InputDecoration(
                    labelText: "Enter question",
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButton<int>(
                  value: _selectedTargetId,
                  isExpanded: true,
                  hint: const Text("Select target player"),
                  items: _players
                      .map(
                        (player) => DropdownMenuItem<int>(
                          value: player.id,
                          child: Text(player.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedTargetId = value;
                    });
                  },
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: _sendQuestion,
          child: const Text("Send"),
        ),
      ],
    );
  }
}
