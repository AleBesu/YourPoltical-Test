class Question {
  final String question;
  final String imageAssetPath;
  final QuestionAxis questionAxis;
  final Direction direction;

  const Question({
    required this.question,
    required this.imageAssetPath,
    required this.questionAxis,
    required this.direction,
  });
}

//horizontal: economic, vertical: authority
enum QuestionAxis { horizontal, vertical }

enum Direction {
  positive(1),
  negative(-1);

  final int value;
  const Direction(this.value);
} //positivo derecha o liberal ,negativo izquierda o autoritario
