import 'package:imposter_game/utils/api_client.dart';

class VotingService {
  static Future submitVote(int roundId, int voterId, int targetId) async {
    await ApiClient.dio.post('/round/$roundId/vote', data: {
      'voter_id': voterId,
      'target_id': targetId,
    });
  }

  static Future<Map<String, dynamic>> getResults(int roundId) async {
    final response = await ApiClient.dio.get('/round/$roundId/results');
    return response.data;
  }
}
