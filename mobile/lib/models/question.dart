class Question {
  final int id;

  // Existing fields
  final String asker;
  final String target;
  final String text;
  final bool hasAnswer;
  final String? answer;

  // 🔥 NEW fields (Feature E)
  final int? roundLobbyId;
  final String? targetName;
  final String? askerName;

  Question({
    required this.id,
    required this.asker,
    required this.target,
    required this.text,
    required this.hasAnswer,
    required this.answer,

    // NEW
    this.roundLobbyId,
    this.targetName,
    this.askerName,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],

      // existing mappings
      asker: json['asker'] ?? json['asker_name'] ?? "",
      target: json['target'] ?? json['target_name'] ?? "",
      text: json['text'],
      hasAnswer: json['has_answer'],
      answer: json['answer'],

      // NEW mappings from backend
      roundLobbyId: json['round_lobby_id'],
      targetName: json['target_name'],
      askerName: json['asker_name'],
    );
  }
}
