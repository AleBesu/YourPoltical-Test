import 'package:flutter/material.dart';
import 'package:your_political_test/UI/screens/main_screen.dart';

Future<void> showPauseDialog(BuildContext context) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => AlertDialog(
      title: Center(child: Text('Pausa')),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OutlinedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Continuar"),
          ),
          SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreen()),
                (route) => false,
              );
            },
            child: Text("Menu Principal"),
          ),
        ],
      ),
    ),
  );
}
