class Question {
  final int id;
  final String asker;
  final String target;
  final String text;
  final bool hasAnswer;
  final String? answer;

  Question({
    required this.id,
    required this.asker,
    required this.target,
    required this.text,
    required this.hasAnswer,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      asker: json['asker'],
      target: json['target'],
      text: json['text'],
      hasAnswer: json['has_answer'],
      answer: json['answer'],
    );
  }
}
