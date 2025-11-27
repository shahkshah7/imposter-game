import 'package:flutter/material.dart';
import 'package:imposter_game/services/lobby_service.dart';
import 'package:imposter_game/models/player.dart';
import 'package:imposter_game/models/lobby.dart';
import 'package:imposter_game/screens/lobby_room/lobby_room_screen.dart';

class JoinLobbyScreen extends StatefulWidget {
  const JoinLobbyScreen({super.key});

  @override
  State<JoinLobbyScreen> createState() => _JoinLobbyScreenState();
}

class _JoinLobbyScreenState extends State<JoinLobbyScreen> {
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();

  bool _loading = false;
  String? _error;

  void _joinLobby() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      Player player = await LobbyService.joinLobby(
        _codeController.text.trim(),
        _nameController.text.trim(),
      );

      // fetch lobby after join
      Lobby lobby = Lobby(id: player.lobbyId, code: _codeController.text.trim());

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LobbyRoomScreen(player: player, lobby: lobby),
        ),
      );
    } catch (e) {
      setState(() {
        _error = "Failed to join. Check code.";
      });
    }

    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Join Lobby")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: "Lobby Code",
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: "Player Name",
              ),
            ),

            const SizedBox(height: 20),

            _loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _joinLobby,
                    child: const Text("Join"),
                  ),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(_error!,
                    style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
