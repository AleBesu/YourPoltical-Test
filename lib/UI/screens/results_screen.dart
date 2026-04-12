import 'package:flutter/material.dart';
import 'package:your_political_test/UI/screens/widget/custom_scaffold.dart';
import 'package:your_political_test/app/theme/app_colors.dart';

/// Modelo de datos para pasar al widget desde fuera
class PoliticalResult {
  final double economicScore; // -1.0 (izquierda) a 1.0 (derecha)
  final double authorityScore; // -1.0 (liberal) a 1.0 (totalitario)
  final String economicLabel;
  final String socialLabel;
  final String compatibilityLabel;
  final int compatibilityPercent;
  final String description;

  const PoliticalResult({
    required this.economicScore,
    required this.authorityScore,
    required this.economicLabel,
    required this.socialLabel,
    required this.compatibilityLabel,
    required this.compatibilityPercent,
    required this.description,
  });
}

/// Pantalla reutilizable de resultados del test político.
/// Toda la lógica (navegación, compartir, toggle) se delega
/// mediante callbacks para mantener el widget sin estado de negocio.
class ResultsScreen extends StatefulWidget {
  final PoliticalResult result;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onRepeat;

  const ResultsScreen({
    super.key,
    required this.result,
    this.onBack,
    this.onShare,
    this.onRepeat,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  bool _showPoliticians = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildCompassCard(),
            const SizedBox(height: 16),
            _buildResultCard(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  // ─── Encabezado ────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      children: const [
        Text(
          'Tu Posición Política',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Descubre dónde te ubicas en el espectro político',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

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
                economicScore: widget.result.economicScore,
                authorityScore: widget.result.authorityScore,
                showPoliticians: _showPoliticians,
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        _buildPoliticiansToggle(),
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
    final r = widget.result;
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
            value: r.economicLabel,
            valueColor: AppColors.textPrimary,
          ),
          const SizedBox(height: 12),
          _ResultRow(
            label: 'Libertades Sociales',
            value: r.socialLabel,
            valueColor: Colors.white,
          ),
          const SizedBox(height: 12),
          _ResultRow(
            label: 'Compatibilidad',
            value: '${r.compatibilityPercent}% ${r.compatibilityLabel}',
            valueColor: const Color(0xFF16A34A),
          ),
          const SizedBox(height: 16),
          Text(
            r.description,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textPrimary,
              height: 1.6,
            ),
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
            widget.onShare?.call();
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
        OutlinedButton(
          onPressed: () {
            widget.onRepeat?.call();
          },
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF374151),
            padding: const EdgeInsets.symmetric(vertical: 15),
            side: const BorderSide(color: Color(0xFFD1D5DB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Repetir Test',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

// ─── Widget interno: brújula política ─────────────────────────────────────────

class _PoliticalCompass extends StatelessWidget {
  /// economicScore: -1.0 = izquierda extrema · 1.0 = derecha extrema
  /// authorityScore: -1.0 = liberal extremo · 1.0 = totalitario extremo
  final double economicScore;
  final double authorityScore;
  final bool showPoliticians;

  const _PoliticalCompass({
    required this.economicScore,
    required this.authorityScore,
    required this.showPoliticians,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
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

        // Marcador del usuario
        // LayoutBuilder(
        //   builder: (context, constraints) {
        //     // Convertir scores (-1..1) a posición relativa (0..1)
        //     final xFraction = (economicScore + 1) / 2;
        //     final yFraction =
        //         (authorityScore + 1) / 2; // 0 = liberal, 1 = totalitario
        //     const markerSize = 20.0;
        //     final left = xFraction * constraints.maxWidth - markerSize / 2;
        //     final top = yFraction * constraints.maxHeight - markerSize / 2;
        //     return Positioned(
        //       left: left.clamp(0, constraints.maxWidth - markerSize),
        //       top: top.clamp(0, constraints.maxHeight - markerSize),
        //       child: _UserMarker(size: markerSize),
        //     );
        //   },
        // ),

        // Marcadores de políticos (ejemplo hardcodeado; en producción
        // se pasarían como parámetro)
        if (showPoliticians)
          LayoutBuilder(
            builder: (context, constraints) {
              const politicians = [
                _PoliticianPosition(x: 0.20, y: 0.25),
                _PoliticianPosition(x: 0.75, y: 0.30),
                _PoliticianPosition(x: 0.15, y: 0.70),
                _PoliticianPosition(x: 0.80, y: 0.65),
                _PoliticianPosition(x: 0.60, y: 0.45),
              ];
              const markerSize = 28.0;
              return Stack(
                children: politicians.map((p) {
                  return Positioned(
                    left: p.x * constraints.maxWidth - markerSize / 2,
                    top: p.y * constraints.maxHeight - markerSize / 2,
                    child: _PoliticianMarker(size: markerSize),
                  );
                }).toList(),
              );
            },
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

class _PoliticianPosition {
  final double x;
  final double y;
  const _PoliticianPosition({required this.x, required this.y});
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

class _UserMarker extends StatelessWidget {
  final double size;
  const _UserMarker({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Icon(Icons.person, color: Colors.white, size: 12),
    );
  }
}

// ─── Marcador de político ─────────────────────────────────────────────────

class _PoliticianMarker extends StatelessWidget {
  final double size;
  const _PoliticianMarker({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 4),
        ],
      ),
      child: const Icon(
        Icons.account_circle,
        color: Color(0xFF6B7280),
        size: 16,
      ),
    );
  }
}

// ─── Fila de resultado ─────────────────────────────────────────────────────

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.textPrimary),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}

// ─── Ejemplo de uso ───────────────────────────────────────────────────────

void main() {
  runApp(const _DemoApp());
}

class _DemoApp extends StatelessWidget {
  const _DemoApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3B82F6)),
        useMaterial3: true,
      ),
      home: ResultsScreen(
        result: const PoliticalResult(
          economicScore: -0.20, // Centro-izquierda
          authorityScore: -0.30, // Liberal
          economicLabel: 'Centro-Izquierda',
          socialLabel: 'Liberal',
          compatibilityLabel: 'Progresista',
          compatibilityPercent: 85,
          description:
              'Tu posición indica una tendencia hacia políticas económicas de '
              'centro-izquierda con valores sociales liberales. Apoyas la '
              'intervención estatal moderada y las libertades individuales.',
        ),
        onBack: () {},
        onShare: () {},
        onRepeat: () {},
      ),
    );
  }
}
