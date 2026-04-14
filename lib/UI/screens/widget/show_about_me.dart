import 'package:flutter/material.dart';

Future<void> showAboutMe(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Icon(Icons.close),
              ),
            ],
          ),
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: AssetImage("assets/grow_now_logo.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "GrowNow-Software",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 6),
          Text(
            " Somos una empresa dedicada al desarrollo de aplicaciones móviles educativas. Creamos soluciones digitales modernas, intuitivas y de alto rendimiento que facilitan el aprendizaje y mejoran la experiencia de los usuarios. Nos enfocamos en diseñar herramientas accesibles y eficientes que apoyen la educación a través de la tecnología.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8),
          Text(
            "© 2026 GrowNow-Software. Todos los derechos reservados.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: Colors.white60,
            ),
          ),
        ],
      ),
    ),
  );
}
