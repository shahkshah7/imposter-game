import 'package:imposter_game/utils/api_client.dart';
import 'package:imposter_game/models/question.dart';

class QuestionService {
  static Future<Question> askQuestion(
      int roundId, int askerId, int targetId, String text) async {
    final response =
        await ApiClient.dio.post('/round/$roundId/question', data: {
      'asker_id': askerId,
      'target_id': targetId,
      'text': text
    });

    return Question.fromJson(response.data['question']);
  }

  static Future<void> answerQuestion(int questionId, String answer) async {
    await ApiClient.dio.post('/question/$questionId/answer', data: {
      'answer': answer,
    });
  }

  static Future<List<Question>> getQuestions(int roundId, int playerId) async {
    final response =
        await ApiClient.dio.get('/round/$roundId/questions/$playerId');

    return (response.data['questions'] as List)
        .map((q) => Question.fromJson(q))
        .toList();
  }
}
