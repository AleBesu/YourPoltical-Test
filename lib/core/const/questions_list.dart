import 'package:flutter/material.dart';
import 'package:your_political_test/core/entities/question.dart';
import 'package:your_political_test/l10n/app_localizations.dart';

List<Question> questionsList(BuildContext context) {
  final appLocalizations = AppLocalizations.of(context)!;

  return [
    //1
    Question(
      question: appLocalizations.question1,
      imageAssetPath: "assets/question_images/1.png",
      questionAxis: QuestionAxis.vertical,
      direction: Direction.negative,
    ),
    //2
    Question(
      question: appLocalizations.question2,
      imageAssetPath: "assets/question_images/2.png",
      questionAxis: QuestionAxis.vertical,
      direction: Direction.positive,
    ),
    //3
    Question(
      question: appLocalizations.question3,
      imageAssetPath: "assets/question_images/3.png",
      questionAxis: QuestionAxis.vertical,
      direction: Direction.positive,
    ),
    //4
    Question(
      question: appLocalizations.question4,
      imageAssetPath: "assets/question_images/4.png",
      questionAxis: QuestionAxis.vertical,
      direction: Direction.positive,
    ),
    //5
    Question(
      question: appLocalizations.question5,
      imageAssetPath: "assets/question_images/5.png",
      questionAxis: QuestionAxis.vertical,
      direction: Direction.positive,
    ),
    //6
    Question(
      question: appLocalizations.question6,
      imageAssetPath: "assets/question_images/6.png",
      questionAxis: QuestionAxis.vertical,
      direction: Direction.positive,
    ),
    //7
    Question(
      question: appLocalizations.question7,
      imageAssetPath: "assets/question_images/7.png",
      questionAxis: QuestionAxis.horizontal,
      direction: Direction.positive,
    ),
    //8
    Question(
      question: appLocalizations.question8,
      imageAssetPath: "assets/question_images/8.png",
      questionAxis: QuestionAxis.horizontal,
      direction: Direction.positive,
    ),
    //9
    Question(
      question: appLocalizations.question9,
      imageAssetPath: "assets/question_images/9.png",
      questionAxis: QuestionAxis.horizontal,
      direction: Direction.positive,
    ),
    //10
    Question(
      question: appLocalizations.question10,
      imageAssetPath: "assets/question_images/10.png",
      questionAxis: QuestionAxis.horizontal,
      direction: Direction.positive,
    ),
    //11
    Question(
      question: appLocalizations.question11,
      imageAssetPath: "assets/question_images/11.png",
      questionAxis: QuestionAxis.horizontal,
      direction: Direction.positive,
    ),
    //12
    Question(
      question: appLocalizations.question12,
      imageAssetPath: "assets/question_images/12.png",
      questionAxis: QuestionAxis.horizontal,
      direction: Direction.positive,
    ),
  ];
}
