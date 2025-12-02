import 'package:flutter/material.dart';
import 'package:imposter_game/models/player.dart';
import 'package:imposter_game/models/lobby.dart';
import 'package:imposter_game/services/game_service.dart';
import 'package:imposter_game/screens/game/game_screen.dart';

class LobbyRoomScreen extends StatefulWidget {
  final Player player;
  final Lobby lobby;

  const LobbyRoomScreen({
    super.key,
    required this.player,
    required this.lobby,
  });

  @override
  State<LobbyRoomScreen> createState() => _LobbyRoomScreenState();
}

class _LobbyRoomScreenState extends State<LobbyRoomScreen> {
  bool _starting = false;
  String? _error;

  void _startGame() async {
    setState(() {
      _starting = true;
    });

    try {
      final round = await GameService.startGame(widget.lobby.code);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => GameScreen(
            player: widget.player,
            lobby: widget.lobby,
            roundId: round.id,
          ),
        ),
      );
    } catch (e) {
      setState(() {
        _error = e.toString();
        _starting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isHost = widget.player.id == widget.lobby.hostId;

    return Scaffold(
      appBar: AppBar(title: Text("Lobby: ${widget.lobby.code}")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome ${widget.player.name}!"),

            const SizedBox(height: 40),

            if (isHost)
              _starting
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _startGame,
                      child: const Text("Start Game"),
                    )
            else
              const Text("Waiting for host to start..."),

            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
