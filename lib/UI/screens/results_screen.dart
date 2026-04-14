import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:your_political_test/UI/provider/user_name_provider.dart';
import 'package:your_political_test/UI/screens/main_screen.dart';
import 'package:your_political_test/UI/screens/question_screen.dart';
import 'package:your_political_test/UI/screens/widget/custom_scaffold.dart';
import 'package:your_political_test/app/theme/app_colors.dart';
import 'package:your_political_test/core/const/politicials_list.dart';
import 'package:your_political_test/core/entities/political_result.dart';

/// Pantalla reutilizable de resultados del test político.
/// Toda la lógica (navegación, compartir, toggle) se delega
/// mediante callbacks para mantener el widget sin estado de negocio.
class ResultsScreen extends StatefulWidget {
  final bool showActionsButtons;
  final PoliticalResult result;
  final VoidCallback? onBack;

  final VoidCallback? onRepeat;

  const ResultsScreen({
    super.key,
    required this.result,
    this.onBack,
    this.showActionsButtons = true,
    this.onRepeat,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _showPoliticians = false;
  bool isTakingScreenshot = false;
  ScreenshotController _resultsScreenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: AppBar(
        title: Text(
          'Tu Posición Política',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildPoliticiansToggle(),
            const SizedBox(height: 8),
            Screenshot(
              controller: _resultsScreenshotController,
              child: Container(
                padding: isTakingScreenshot
                    ? const EdgeInsets.all(16)
                    : const EdgeInsets.all(0),
                decoration: isTakingScreenshot == false
                    ? null
                    : BoxDecoration(
                        color: AppColors.primaryDark,
                        borderRadius: BorderRadius.circular(16),
                      ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isTakingScreenshot) ...[
                      Text(
                        'Your Political Test',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 12),
                    ],

                    _buildCompassCard(),
                    const SizedBox(height: 16),
                    _buildResultCard(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            if (widget.showActionsButtons) _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  String get economicResult {
    final value = widget.result.economicPosition;

    if (value >= 5) {
      return 'Ultra-Derecha';
    } else if (value >= 3) {
      return 'Derecha';
    } else if (value > 0.51) {
      return 'Centro-Derecha';
    } else if (value >= 0 || value < 0 && value >= -0.51) {
      return 'Centro';
    } else if (value <= -5) {
      return 'Ultra-Izquierda';
    } else if (value <= -3) {
      return 'Izquierda';
    } else if (value <= -0.51) {
      return 'Centro-Izquierda';
    } else {
      throw Exception('Invalid economic position');
    }
  }

  String get authorityResult {
    final value = widget.result.authorityPosition;

    if (value >= 5) {
      return 'Liberal';
    } else if (value >= 3) {
      return 'Liberal-Moderado';
    } else if (value >= 0 || value < 0 && value >= -3) {
      return 'Centro';
    } else if (value <= -5) {
      return 'Totalitario';
    } else if (value < 0 && value <= -3) {
      return 'Totalitario-Moderado';
    } else {
      throw Exception('Invalid economic position');
    }
  }

  // ─── Encabezado ────────────────────────────────────────────────────────────

  // ─── Brújula política ──────────────────────────────────────────────────────

  Widget _buildCompassCard() {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth * 0.9;
            return SizedBox(
              width: size,
              height: size,
              child: _PoliticalCompass(
                economicMaxPosition: widget.result.economicMaxPosition,
                authorityMaxPosition: widget.result.authorityMaxPosition,
                economicPosition: widget.result.economicPosition,
                authorityPosition: widget.result.authorityPosition,
                showPoliticians: _showPoliticians,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPoliticiansToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Mostrar políticos',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        const SizedBox(width: 12),
        Switch(
          value: _showPoliticians,
          activeColor: const Color(0xFF3B82F6),
          onChanged: (v) => setState(() => _showPoliticians = v),
        ),
      ],
    );
  }

  // ─── Tarjeta de resultado ──────────────────────────────────────────────────

  Widget _buildResultCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tu Resultado',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _ResultRow(
            label: 'Orientación Económica',
            valueChildren: [
              Text(
                economicResult,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ResultRow(
            label: 'Libertades Sociales',
            valueChildren: [
              Text(
                authorityResult,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ResultRow(
            label: 'Compatibilidad',
            valueChildren: [
              Text(
                "Izquierda: ${((((widget.result.economicPosition) / (widget.result.economicMaxPosition * -1)) * 100) * (widget.result.economicPosition > 0 ? 0 : 1)).abs().toStringAsFixed(2)}%",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.repRed,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Derecha: ${((((widget.result.economicPosition) / (widget.result.economicMaxPosition)) * 100) * (widget.result.economicPosition < 0 ? 0 : 1)).abs().toStringAsFixed(2)}%",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.repBlue,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Liberal: ${((((widget.result.authorityPosition) / (widget.result.authorityMaxPosition)) * 100) * (widget.result.authorityPosition < 0 ? 0 : 1)).abs().toStringAsFixed(2)}%",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.repGreen,
                ),
              ),
              SizedBox(width: 8),
              Text(
                "Totalitario: ${((((widget.result.authorityPosition) / (widget.result.authorityMaxPosition)) * 100) * (widget.result.authorityPosition > 0 ? 0 : 1)).abs().toStringAsFixed(2)}%",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.repOrange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Botones de acción ─────────────────────────────────────────────────────

  Widget _buildActionButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            setState(() {
              isTakingScreenshot = true;
            });

            _resultsScreenshotController.capture().then((imageBytes) async {
              setState(() {
                isTakingScreenshot = false;
              });

              if (imageBytes != null) {
                //       final imageFile = await  File( '${(await getTemporaryDirectory()).path}/results.png').create() ;
                //  await imageFile.writeAsBytes(imageBytes!);

                await SharePlus.instance.share(
                  ShareParams(
                    files: [
                      XFile.fromData(
                        imageBytes,
                        name: "results.png",
                        mimeType: 'image/png',
                      ),
                    ],
                  ),
                );
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3B82F6),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Compartir Resultados',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => QuestionScreen()),
              (route) => false,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.repGreen.withValues(alpha: 0.8),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Repetir Test',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => MainScreen()),
              (route) => false,
            );
          },
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15),
            side: const BorderSide(color: Color(0xFFD1D5DB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Volver al Inicio',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

// ─── Widget interno: brújula política ─────────────────────────────────────────

class _PoliticalCompass extends ConsumerWidget {
  /// economicScore: -1.0 = izquierda extrema · 1.0 = derecha extrema
  /// authorityScore: -1.0 = liberal extremo · 1.0 = totalitario extremo

  final double economicPosition; // -1.0 (izquierda) a 1.0 (derecha)
  final double economicMaxPosition;

  final double authorityPosition; // -1.0 (liberal) a 1.0 (totalitario)
  final double authorityMaxPosition;
  final bool showPoliticians;

  const _PoliticalCompass({
    required this.economicPosition,
    required this.authorityPosition,
    required this.showPoliticians,
    required this.economicMaxPosition,
    required this.authorityMaxPosition,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Cuadrantes
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF9CA3AF), width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    _Quadrant(
                      color: AppColors.repGreen.withValues(alpha: 0.8),
                      label: 'Liberal\nIzquierda',
                      textColor: const Color(0xFFDCFCE7),
                      borderRight: true,
                      borderBottom: true,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                      ),
                    ),
                    _Quadrant(
                      color: AppColors.repBlue.withValues(alpha: 0.8),
                      label: 'Liberal\nDerecha',
                      textColor: const Color(0xFFDBEAFE),
                      borderBottom: true,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _Quadrant(
                      color: AppColors.repRed.withValues(alpha: 0.8),
                      label: 'Totalitario\nIzquierda',
                      textColor: const Color(0xFFFEE2E2),
                      borderRight: true,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                    _Quadrant(
                      color: AppColors.repPurple.withValues(alpha: 0.8),
                      label: 'Totalitario\nDerecha',
                      textColor: const Color(0xFFF3E8FF),
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Marcadores de políticos (ejemplo hardcodeado; en producción
        // se pasarían como parámetro)
        if (showPoliticians)
          ...politiciansList.map((politician) {
            return Positioned.fill(
              child: Align(
                alignment: Alignment(
                  (politician.x / economicMaxPosition),
                  (politician.y / authorityMaxPosition) * -1,
                ),
                child: _AvatarWidget(
                  size: 32,
                  name: politician.name,
                  image: AssetImage(politician.imagePath),
                  showBorder: false,
                ),
              ),
            );
          }),

        // Marcador del usuario
        Positioned.fill(
          child: Align(
            alignment: Alignment(
              (economicPosition / economicMaxPosition),
              (authorityPosition / authorityMaxPosition) *
                  -1, // es por -1 ya que en flutter los valores
              //positivos del eje Y van hacia abajo y yo uso convesionalmente
              // los valores positivos hacia arriba(arriba liberal, abajo totalitario)
            ),
            child: _AvatarWidget(size: 28, name: ref.watch(userNameProvider)),
          ),
        ),
      ],
    );
  }

  Widget _axisLabel(String text) => Text(
    text,
    style: const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: Color(0xFF4B5563),
    ),
  );
}

// ─── Cuadrante de color ────────────────────────────────────────────────────

class _Quadrant extends StatelessWidget {
  final Color color;
  final String label;
  final Color textColor;
  final bool borderRight;
  final bool borderBottom;
  final BorderRadiusGeometry? borderRadius;

  const _Quadrant({
    required this.color,
    required this.label,
    required this.textColor,
    this.borderRight = false,
    this.borderBottom = false,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color,
          border: Border(
            right: borderRight
                ? const BorderSide(color: Color(0xFF9CA3AF))
                : BorderSide.none,
            bottom: borderBottom
                ? const BorderSide(color: Color(0xFF9CA3AF))
                : BorderSide.none,
          ),
          borderRadius: borderRadius,
        ),
        child: Stack(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
              ),
              itemCount: 36,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(
                        255,
                        176,
                        177,
                        178,
                      ).withOpacity(0.35),
                      width: 0.5,
                    ),
                  ),
                );
              },
            ),

            //Text
            Positioned.fill(
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Marcador del usuario ──────────────────────────────────────────────────

class _AvatarWidget extends ConsumerWidget {
  final double size;
  final String name;
  final AssetImage? image;
  final bool showBorder;
  const _AvatarWidget({
    required this.size,
    required this.name,
    this.image,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: TextStyle(color: Colors.white),

      message: name,
      showDuration: Duration(seconds: 2, milliseconds: 500),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: showBorder
              ? Border.all(color: Colors.blueAccent, width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
          image: image == null
              ? null
              : DecorationImage(image: image!, fit: BoxFit.cover),
        ),
        child: image != null
            ? null
            : const Icon(Icons.person, color: AppColors.primaryBlue),
      ),
    );
  }
}

// ─── Fila de resultado ─────────────────────────────────────────────────────

class _ResultRow extends StatelessWidget {
  final String label;
  final List<Widget> valueChildren;

  const _ResultRow({required this.label, required this.valueChildren});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: valueChildren,
        ),
      ],
    );
  }
}
