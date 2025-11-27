import 'package:flutter/material.dart';
import 'package:imposter_game/services/voting_service.dart';
import 'package:imposter_game/models/player.dart';

class RevealScreen extends StatefulWidget {
  final int roundId;
  final Player player;

  const RevealScreen({
    super.key,
    required this.roundId,
    required this.player,
  });

  @override
  State<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends State<RevealScreen> {
  Map<String, dynamic>? results;

  @override
  void initState() {
    super.initState();
    loadResults();
  }

  void loadResults() async {
    results = await VotingService.getResults(widget.roundId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (results == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final winner = results!['winner'];
    final impostorId = results!['impostor'];

    return Scaffold(
      appBar: AppBar(title: const Text("Round Results")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              winner == 'civilians'
                  ? "🎉 Civilians Win!"
                  : "🔥 Impostor Wins!",
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 20),
            Text("Impostor was Player ID: $impostorId"),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Return to game screen or new round
              },
              child: const Text("Next Round"),
            )
          ],
        ),
      ),
    );
  }
}
