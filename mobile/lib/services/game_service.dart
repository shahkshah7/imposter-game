import 'package:imposter_game/utils/api_client.dart';
import 'package:imposter_game/models/round.dart';

class GameService {
  static Future<GameRound> startGame(int lobbyId) async {
    final response = await ApiClient.dio.post('/game/$lobbyId/start');
    return GameRound.fromJson(response.data['round']);
  }

  static Future<Map<String, dynamic>> getState(int playerId) async {
    final response = await ApiClient.dio.get('/game/player/$playerId/state');
    return response.data;
  }
}
