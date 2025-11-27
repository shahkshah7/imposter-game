import 'package:imposter_game/utils/api_client.dart';
import 'package:imposter_game/models/lobby.dart';
import 'package:imposter_game/models/player.dart';

class LobbyService {
  static Future<Lobby> createLobby() async {
    final response = await ApiClient.dio.post('/lobby/create');
    return Lobby.fromJson(response.data['lobby']);
  }

  static Future<Player> joinLobby(String code, String name) async {
    final response = await ApiClient.dio.post('/lobby/$code/join', data: {
      'name': name
    });
    return Player.fromJson(response.data['player']);
  }
}
