import 'package:flutter/material.dart';
import 'package:your_political_test/UI/screens/question_screen.dart';

Future<void> showNameForm(BuildContext context) async {
  TextEditingController userNameFieldController = TextEditingController();
  GlobalKey<FormFieldState> userNameFormFieldKey = GlobalKey<FormFieldState>();
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Introduce tu nombre'),

      content: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, introduce tu nombre';
          }
          return null;
        },
        key: userNameFormFieldKey,
        controller: userNameFieldController,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            if (userNameFormFieldKey.currentState!.validate()) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => QuestionScreen()),
                (route) => false,
              );
            }
          },
          child: Text("Confirmar"),
        ),
      ],
    ),
  );
}
