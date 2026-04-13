import 'package:your_political_test/core/entities/question.dart';

List<Question> questionsList = const <Question>[
  //1
  Question(
    question:
        "¿Debería el gobierno prohibir opiniones políticas o religiosas extremas para mantener el orden social?",
    imageAssetPath: "assets/question_images/1.png",
    questionAxis: QuestionAxis.vertical,
    direction: Direction.negative,
  ),
  //2
  Question(
    question:
        "¿Debería eliminarse el servicio militar obligatorio y mantener solo un ejército profesional voluntario?",
    imageAssetPath: "assets/question_images/2.png",
    questionAxis: QuestionAxis.vertical,
    direction: Direction.positive,
  ),
  //3
  Question(
    question:
        "¿Deben legalizarse los actos sexuales consentidos entre adultos (en privado) sin interferencia estatal?",
    imageAssetPath: "assets/question_images/3.png",
    questionAxis: QuestionAxis.vertical,
    direction: Direction.positive,
  ),
  //4
  Question(
    question:
        "¿Debería permitirse el consumo y la venta de sustancias (como la marihuana) bajo la responsabilidad del adulto, en lugar de ser una cuestión penal?",
    imageAssetPath: "assets/question_images/4.png",
    questionAxis: QuestionAxis.vertical,
    direction: Direction.positive,
  ),
  //5
  Question(
    question:
        "¿Debería el Estado ser totalmente laico y no otorgar privilegios ni fondos públicos a ninguna institución religiosa?",
    imageAssetPath: "assets/question_images/5.png",
    questionAxis: QuestionAxis.vertical,
    direction: Direction.positive,
  ),
  //6
  Question(
    question:
        "¿Deben las personas tener libertad para cruzar fronteras y trabajar, siempre que no tengan antecedentes criminales?",
    imageAssetPath: "assets/question_images/6.png",
    questionAxis: QuestionAxis.vertical,
    direction: Direction.positive,
  ),
  //7
  Question(
    question:
        "¿Deberían reducirse drásticamente los impuestos para que las personas dispongan de una mayor parte de sus ingresos?",
    imageAssetPath: "assets/question_images/7.png",
    questionAxis: QuestionAxis.horizontal,
    direction: Direction.positive,
  ),
  //8
  Question(
    question:
        "¿Debería el gobierno reducir el gasto social y las subvenciones para equilibrar el presupuesto y bajar la deuda?",
    imageAssetPath: "assets/question_images/8.png",
    questionAxis: QuestionAxis.horizontal,
    direction: Direction.positive,
  ),
  //9
  Question(
    question:
        "¿Deberían eliminarse los controles de precios y salarios para que el mercado los determine libremente?",
    imageAssetPath: "assets/question_images/9.png",
    questionAxis: QuestionAxis.horizontal,
    direction: Direction.positive,
  ),
  //10
  Question(
    question:
        "¿Deberían sectores como el correo, la electricidad o el transporte pasar a manos privadas en lugar de ser gestionados por el Estado?",
    imageAssetPath: "assets/question_images/10.png",
    questionAxis: QuestionAxis.horizontal,
    direction: Direction.positive,
  ),
  //11
  Question(
    question:
        "¿Debería permitirse el libre comercio sin aranceles ni cuotas que protejan artificialmente a la industria nacional?",
    imageAssetPath: "assets/question_images/11.png",
    questionAxis: QuestionAxis.horizontal,
    direction: Direction.positive,
  ),
  //12
  Question(
    question:
        "¿Deberían las organizaciones benéficas y el sector privado hacerse cargo de la ayuda social en lugar de programas gubernamentales obligatorios?",
    imageAssetPath: "assets/question_images/12.png",
    questionAxis: QuestionAxis.horizontal,
    direction: Direction.positive,
  ),
];
