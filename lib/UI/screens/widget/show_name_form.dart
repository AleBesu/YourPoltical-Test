import 'package:flutter/material.dart';
import 'package:your_political_test/UI/screens/question_screen.dart';

Future<void> showNameForm(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Introduce tu nombre'),
      content: TextField(
        onChanged: (value) => Navigator.of(context).pop(value),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => QuestionScreen()),
              (route) => false,
            );
          },
          child: Text("Confirmar"),
        ),
      ],
    ),
  );
}
