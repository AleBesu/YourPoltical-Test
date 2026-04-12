class Question {
  final String question;
  final String imageAssetPath;
  final QuestionType questionType;

  const Question({
    required this.question,
    required this.imageAssetPath,
    required this.questionType,
  });
}

enum QuestionType { economic, social }
