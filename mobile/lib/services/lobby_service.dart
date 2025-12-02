import 'package:dio/dio.dart';
import 'package:imposter_game/utils/api_client.dart';
import 'package:imposter_game/models/lobby.dart';
import 'package:imposter_game/models/player.dart';

class LobbyService {
  static Future<Map<String, dynamic>> createLobby(String playerName) async {
    try {
      final response = await ApiClient.post(
        '/lobby/create',
        data: {'name': playerName},
      );

      if (response.statusCode != 200) {
        throw Exception('Create failed: ${response.statusCode}');
      }

      final data = response.data;
      if (data == null || data['player'] == null || data['lobby'] == null) {
        throw Exception('Invalid createLobby response structure');
      }

      return {
        'player': Player.fromJson(data['player']),
        'lobby': Lobby.fromJson(data['lobby']),
      };
    } on DioException catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> joinLobby(
    String code,
    String playerName,
  ) async {
    final normalizedCode = code.trim().toUpperCase();
    final normalizedName = playerName.trim();

    try {
      final response = await ApiClient.post(
        '/lobby/$normalizedCode/join',
        data: {'name': normalizedName},
      );

      print("joinLobby() status: ${response.statusCode}");
      print("joinLobby() data: ${response.data}");

      if (response.statusCode != 200) {
        throw Exception('Join failed: ${response.statusCode}');
      }

      final data = response.data;
      if (data == null || data['player'] == null || data['lobby'] == null) {
        throw Exception('Invalid joinLobby response structure');
      }

      return {
        'player': Player.fromJson(data['player']),
        'lobby': Lobby.fromJson(data['lobby']),
      };
    } on DioException catch (e) {
      rethrow;
    }
  }
}
