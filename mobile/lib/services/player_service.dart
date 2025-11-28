import 'package:imposter_game/utils/api_client.dart';
import 'package:imposter_game/models/player.dart';

class PlayerService {
  static Future<List<Player>> getPlayers(int lobbyId) async {
    final response = await ApiClient.dio.get('/lobby/$lobbyId/players');

    return (response.data['players'] as List)
        .map((p) => Player.fromJson(p))
        .toList();
  }
}
