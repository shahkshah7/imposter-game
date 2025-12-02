import 'package:imposter_game/utils/api_client.dart';
import 'package:imposter_game/models/round.dart';
import 'package:dio/dio.dart';

class GameService {
  static Future<GameRound> startGame(String lobbyCode) async {
    try {
      final response = await ApiClient.dio.post('/game/$lobbyCode/start');
      return GameRound.fromJson(response.data['round']);
    } on DioException catch (e) {
      final message = e.response?.data is Map && e.response?.data['error'] != null
          ? e.response?.data['error'].toString()
          : e.message ?? 'Failed to start game';
      throw Exception(message);
    }
  }

  static Future<Map<String, dynamic>> getState(int playerId) async {
    final response = await ApiClient.dio.get('/game/player/$playerId/state');
    return response.data;
  }
}
