import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:your_political_test/UI/screens/main_screen.dart';
import 'package:your_political_test/UI/screens/question_screen.dart';
import 'package:your_political_test/UI/screens/results_screen.dart';
import 'package:your_political_test/app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: QuestionScreen(),
      // home: ResultsScreen(
      //   result: PoliticalResult(
      //     economicScore: 20,
      //     authorityScore: 30,
      //     economicLabel: "Centro-Izquierda",
      //     socialLabel: "Liberal",
      //     compatibilityLabel: "85% Progresista",
      //     compatibilityPercent: 30,
      //     description:
      //         "Tu posición indica una tendencia hacia políticas económicas de centro-izquierda con valores sociales liberales. Apoyas la intervención estatal moderada y las libertades individuales.",
      //   ),
      // ),
    );
  }
}
