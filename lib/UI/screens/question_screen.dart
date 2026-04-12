import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:your_political_test/UI/screens/widget/custom_scaffold.dart';
import 'package:your_political_test/core/entities/question.dart';

enum PoliticalAnswer {
  muyDeAcuerdo(label: "Muy de acuerdo"),
  deAcuerdo(label: "De acuerdo"),
  neutral(label: "Neutral"),
  enDesacuerdo(label: "En desacuerdo"),
  muyEnDesacuerdo(label: "Muy en desacuerdo");

  final String label;
  const PoliticalAnswer({required this.label});
}

// extension PoliticalAnswerLabel on PoliticalAnswer {
//   String get label {
//     switch (this) {
//       case PoliticalAnswer.muyDeAcuerdo:
//         return 'Muy de acuerdo';
//       case PoliticalAnswer.deAcuerdo:
//         return 'De acuerdo';
//       case PoliticalAnswer.neutral:
//         return 'Neutral';
//       case PoliticalAnswer.enDesacuerdo:
//         return 'En desacuerdo';
//       case PoliticalAnswer.muyEnDesacuerdo:
//         return 'Muy en desacuerdo';
//     }
//   }
// }

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  PoliticalAnswer? _selected;
  final AudioPlayer _musicPlayer = AudioPlayer();

  int currentQuestion = 0;
  List<Question> questionsList = <Question>[
    Question(
      question: "",
      imageAssetPath: "",
      questionType: QuestionType.economic,
    ),
  ];

  final PageController _pageController = PageController();

  @override
  void initState() {
    playMusic();
    super.initState();
  }

  Future<void> playMusic() async {
    await _musicPlayer.setAsset("assets/music/game_play_song.mp3");
    await _musicPlayer.setLoopMode(LoopMode.one);
    await _musicPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      onPausedApp: () => setState(() {
        _musicPlayer.pause();
      }),
      onResumedApp: () => setState(() {
        _musicPlayer.play();
      }),
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────────
            _buildHeader(),

            // ── Scrollable body ──────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() => currentQuestion = value);
                },
                children: List.generate(
                  questionsList.length,
                  (index) => SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      children: [
                        // Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/main_screen_wallpaper.png",
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Question
                        Text(
                          "Esto es una pregunta",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Options
                        ...PoliticalAnswer.values.map(
                          (answer) => _AnswerOption(
                            label: answer.label,
                            isSelected: _selected == answer,
                            onTap: () => setState(() => _selected = answer),
                          ),
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ── Footer / Confirm button ──────────────────────────────
            _Footer(enabled: _selected != null, onConfirm: () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.pause)),
              Text(
                'Pregunta ${currentQuestion + 1} de ${questionsList.length}',
                style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Material(
                  color: Colors.transparent,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _musicPlayer.playing
                          ? Colors.grey.withOpacity(0.3)
                          : Colors.red.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: InkWell(
                      onTap: () async {
                        setState(() {
                          if (_musicPlayer.playing) {
                            _musicPlayer.pause();
                          } else {
                            _musicPlayer.play();
                          }
                        });
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Icon(
                        _musicPlayer.playing
                            ? MdiIcons.music
                            : Icons.volume_off,
                        color: _musicPlayer.playing
                            ? Colors.white
                            : Colors.redAccent,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ////////////////////////////////////////////////////////
          LinearProgressIndicator(
            value: currentQuestion / questionsList.length,
            borderRadius: BorderRadius.circular(99),
            minHeight: 8,
            backgroundColor: const Color(0xFF334155),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF3B82F6)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _AnswerOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _AnswerOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  static const _primary = Color(0xFF3B82F6);
  static const _surfaceColor = Color(0xFF1E293B);
  static const _borderColor = Color(0xFF475569);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? _primary.withOpacity(0.12) : _surfaceColor,
          border: Border.all(
            color: isSelected ? _primary : _borderColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFFF1F5F9),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? _primary : _borderColor,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: _primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final bool enabled;
  final VoidCallback onConfirm;

  const _Footer({required this.enabled, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1E293B),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      child: SizedBox(
        width: double.infinity,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: enabled ? onConfirm : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: enabled
                  ? const Color(0xFF3B82F6)
                  : const Color(0xFF475569),
              disabledBackgroundColor: const Color(0xFF475569),
              foregroundColor: Colors.white,
              disabledForegroundColor: const Color(0xFF94A3B8),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Confirmar respuesta',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
