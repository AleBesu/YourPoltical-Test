import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:your_political_test/UI/provider/user_name_provider.dart';

import 'package:your_political_test/UI/screens/results_screen.dart';
import 'package:your_political_test/UI/screens/reward_add_screen.dart';
import 'package:your_political_test/UI/screens/widget/custom_scaffold.dart';
import 'package:your_political_test/UI/screens/widget/show_pause_dialog.dart';
import 'package:your_political_test/core/const/questions_list.dart';
import 'package:your_political_test/core/entities/political_result.dart';
import 'package:your_political_test/core/entities/question.dart';
import 'package:your_political_test/core/local_database_service/local_database_service.dart';
import 'package:your_political_test/l10n/app_localizations.dart';

enum PoliticalAnswer {
  muyDeAcuerdo(value: 1),
  deAcuerdo(value: 0.5),
  neutral(value: 0),
  enDesacuerdo(value: -0.5),
  muyEnDesacuerdo(value: -1);

  final double value;
  const PoliticalAnswer({required this.value});
}

extension PoliticalAnswerExtension on PoliticalAnswer {
  static String label(BuildContext context, PoliticalAnswer value) {
    final appLocalizations = AppLocalizations.of(context)!;
    switch (value) {
      case PoliticalAnswer.muyDeAcuerdo:
        return appLocalizations.stronglyagree;
      case PoliticalAnswer.deAcuerdo:
        return appLocalizations.agree;
      case PoliticalAnswer.neutral:
        return appLocalizations.neutral;
      case PoliticalAnswer.enDesacuerdo:
        return appLocalizations.disagree;
      case PoliticalAnswer.muyEnDesacuerdo:
        return appLocalizations.stronglydisagree;
    }
  }
}

class QuestionScreen extends ConsumerStatefulWidget {
  const QuestionScreen({super.key});

  @override
  ConsumerState<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends ConsumerState<QuestionScreen> {
  List<Point<double>> answerList = [];

  final AudioPlayer _musicPlayer = AudioPlayer();

  int currentQuestionIndex = 0;

  final PageController _pageController = PageController();
  List<PoliticalAnswer?> _selectedAswersList = List.filled(12, null);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      answerList = List.generate(
        questionsList(context).length,
        (index) => Point(0, 0),
      );

      _selectedAswersList = List.generate(
        questionsList(context).length,
        (index) => null,
      );
    });

    playMusic();
    super.initState();
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic() async {
    await _musicPlayer.setAsset("assets/music/game_play_song.mp3");
    await _musicPlayer.setLoopMode(LoopMode.one);

    setState(() {
      _musicPlayer.play();
    });
  }

  void addAnswerToCurrentQuestion() {
    final currentQuestion = questionsList(context)[currentQuestionIndex];
    final currentAnswer = _selectedAswersList[currentQuestionIndex]!;

    double addedValue =
        //multiply the value of the answer (1 -0,5 ect)
        (currentAnswer.value *
        currentQuestion.direction.value); // negative -1, 1 positive

    //is the axis is horizontal
    if (currentQuestion.questionAxis == QuestionAxis.horizontal) {
      //add this answer to
      answerList[currentQuestionIndex] = Point(addedValue, 0);
    }
    //if the axis is vertical
    else {
      answerList[currentQuestionIndex] = Point(0, addedValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        _musicPlayer.stop();

        await showPauseDialog(context);

        _musicPlayer.play();
      },
      child: CustomScaffold(
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
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  onPageChanged: (value) {
                    setState(() => currentQuestionIndex = value);
                  },
                  children: List.generate(questionsList(context).length, (
                    index,
                  ) {
                    PoliticalAnswer? currentSelectedAnswer =
                        _selectedAswersList[index];

                    final currentQuestion = questionsList(
                      context,
                    )[currentQuestionIndex];

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Column(
                        children: [
                          // Image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              currentQuestion.imageAssetPath,
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              frameBuilder:
                                  (
                                    context,
                                    child,
                                    frame,
                                    wasSynchronouslyLoaded,
                                  ) {
                                    if (wasSynchronouslyLoaded) {
                                      return child;
                                    }
                                    return AnimatedOpacity(
                                      opacity: frame == null ? 0 : 1,
                                      duration: const Duration(
                                        milliseconds: 500,
                                      ),
                                      curve: Curves.easeInOut,
                                      child: child,
                                    );
                                  },
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Question
                          Text(
                            currentQuestion.question,
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
                              label: PoliticalAnswerExtension.label(
                                context,
                                answer,
                              ),
                              isSelected: currentSelectedAnswer == answer,
                              onTap: () => setState(
                                () => _selectedAswersList[index] = answer,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              // ── Footer / Confirm button ──────────────────────────────
              _Footer(
                isFinishQuestion:
                    currentQuestionIndex == questionsList(context).length - 1,
                enabled: _selectedAswersList[currentQuestionIndex] != null,

                onBack: currentQuestionIndex == 0
                    ? null
                    : () async {
                        await _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                onConfirm: () async {
                  addAnswerToCurrentQuestion();
                  //next page
                  await _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },

                onNext: _selectedAswersList[currentQuestionIndex] == null
                    ? null
                    : () {
                        addAnswerToCurrentQuestion();
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                onFinish: () async {
                  final navigator = Navigator.of(context);
                  addAnswerToCurrentQuestion();

                  _musicPlayer.pause();

                  Point<double> userPoint = answerList.reduce(
                    (a, b) => Point(a.x + b.x, a.y + b.y),
                  );

                  final result = PoliticalResult(
                    userName: ref.read(userNameProvider),
                    economicPosition: userPoint.x,
                    authorityPosition: userPoint.y,
                    economicMaxPosition: 6,
                    authorityMaxPosition: 6,
                  );

                  await LocalDatabaseService.addNewResultToHistorial(result);
                  //show add
                  await navigator.push(
                    MaterialPageRoute(
                      builder: (_) => RewardAddScreen(
                        afterShowAdd: () {
                          //go to results
                          navigator.pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => ResultsScreen(result: result),
                            ),
                            (route) => false,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
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
              IconButton(
                onPressed: () async {
                  //play/pause
                  _musicPlayer.pause();
                  await showPauseDialog(context);
                  _musicPlayer.play();
                },
                icon: Icon(Icons.pause),
              ),
              Text(
                '${AppLocalizations.of(context)!.question} ${currentQuestionIndex + 1} - ${questionsList(context).length}',
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
            value: (currentQuestionIndex + 1) / questionsList(context).length,
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
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final bool isFinishQuestion;
  final VoidCallback? onFinish;
  const _Footer({
    required this.enabled,
    required this.onConfirm,
    required this.onBack,
    required this.onNext,
    this.isFinishQuestion = false,
    this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: onBack != null,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: OutlinedButton(
                onPressed: onBack,
                child: Icon(Icons.arrow_back_ios),
              ),
            ),
            SizedBox(width: 8),

            Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton(
                  onPressed: enabled
                      ? isFinishQuestion
                            ? onFinish
                            : onConfirm
                      : null,
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
                  child: Text(
                    AppLocalizations.of(context)!.submit,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),

            Visibility(
              visible: enabled,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: isFinishQuestion
                  ? FilledButton(
                      onPressed: onFinish,
                      child: Icon(Icons.done_outline),
                    )
                  : OutlinedButton(
                      onPressed: onNext,
                      child: Icon(Icons.arrow_forward_ios),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
