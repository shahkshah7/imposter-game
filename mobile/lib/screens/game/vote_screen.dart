import 'package:flutter/material.dart';
import 'package:imposter_game/models/player.dart';
import 'package:imposter_game/services/player_service.dart';
import 'package:imposter_game/services/voting_service.dart';
import 'package:imposter_game/screens/game/reveal_screen.dart';

class VoteScreen extends StatefulWidget {
  final int roundId;
  final Player player;
  final int lobbyId;

  const VoteScreen({
    super.key,
    required this.roundId,
    required this.player,
    required this.lobbyId,
  });

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  List<Player> players = [];
  int? selectedPlayerId;

  @override
  void initState() {
    super.initState();
    loadPlayers();
  }

  void loadPlayers() async {
    players = await PlayerService.getPlayers(widget.lobbyId);
    setState(() {});
  }

  void submitVote() async {
    if (selectedPlayerId == null) return;

    await VotingService.submitVote(
      widget.roundId, 
      widget.player.id,
      selectedPlayerId!,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => RevealScreen(
          roundId: widget.roundId,
          player: widget.player,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Vote for the Impostor")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: players.map((p) {
                return RadioListTile<int>(
                  title: Text(p.name),
                  value: p.id,
                  groupValue: selectedPlayerId,
                  onChanged: (v) => setState(() => selectedPlayerId = v),
                );
              }).toList(),
            ),
          ),
          ElevatedButton(
            onPressed: submitVote,
            child: const Text("Submit Vote"),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
