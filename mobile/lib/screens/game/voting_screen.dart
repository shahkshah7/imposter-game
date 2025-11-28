import 'package:flutter/material.dart';
import 'package:imposter_game/models/player.dart';
import 'package:imposter_game/services/voting_service.dart';

class VotingScreen extends StatefulWidget {
  final int roundId;
  final Player player;
  final int lobbyId;

  const VotingScreen({
    super.key,
    required this.roundId,
    required this.player,
    required this.lobbyId,
  });

  @override
  State<VotingScreen> createState() => _VotingScreenState();
}

class _VotingScreenState extends State<VotingScreen> {
  int? _selectedPlayerId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vote for the Imposter")),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            "Who do you think is the Imposter?",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          // TODO: show list of players
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _submitVote,
        child: const Icon(Icons.done),
      ),
    );
  }

  Future<void> _submitVote() async {
    if (_selectedPlayerId == null) return;

    await VotingService.submitVote(
      widget.roundId,
      widget.player.id,
      _selectedPlayerId!,
    );

    Navigator.pop(context);
  }
}
