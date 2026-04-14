import 'dart:math';

import 'package:flutter/material.dart';

import 'package:your_political_test/UI/screens/widget/custom_scaffold.dart';
import 'package:your_political_test/core/adds/advertisements_service.dart';
import 'package:your_political_test/main.dart';

class RewardAddScreen extends StatefulWidget {
  final VoidCallback afterShowAdd;
  const RewardAddScreen({super.key, required this.afterShowAdd});

  @override
  State<RewardAddScreen> createState() => _RewardAddScreenState();
}

class _RewardAddScreenState extends State<RewardAddScreen> {
  bool isShowedAdd = false;
  bool canPop = false;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () {
      changeText();
    });

    AdvertisementsService().showRewardAd(
      onAdFailedToShow: () {
        setState(() {
          canPop = true;
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(navigatorKey!.currentState!.context).showSnackBar(
          SnackBar(
            margin: EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.transparent,

            content: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Comprueba tu conexion a internet",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        );
      },
      onEarnedReward: () {
        setState(() {
          isShowedAdd = true;
        });
        widget.afterShowAdd();
      },
    );

    super.initState();
  }

  List<String> texts = [
    "Ejecutando análisis de compatibilidad ideológica…",
    "Procesando datos de afinidad política…",
    "Mapeando tu espectro político…",
    "Construyendo tu perfil de pensamiento…",
    "Sincronizando respuestas con el sistema…",
    "Interpretando patrones de tus respuestas…",
    "Calculando coherencia ideológica global…",
    "Evaluando tendencias de posicionamiento…",
    "Analizando correspondencias en el espectro político…",
    "Generando mapa de afinidades políticas…",
  ];
  int currentTextIndex = 0;

  Future<void> changeText() async {
    await Future.delayed(Duration(seconds: Random().nextInt(3) + 1));
    if (isShowedAdd || !mounted) {
      return;
    }

    if (currentTextIndex >= texts.length - 1) {
      setState(() {
        currentTextIndex = 0;
      });
    }
    setState(() {
      currentTextIndex++;
      print("Ejecutando funcion");
      changeText();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      child: CustomScaffold(
        body: Center(
          child: SizedBox(
            width: 250,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text(
                  texts[currentTextIndex],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
