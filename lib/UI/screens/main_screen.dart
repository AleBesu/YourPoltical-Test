import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_material_design_icons/flutter_material_design_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:your_political_test/UI/screens/widget/custom_scaffold.dart';
import 'package:your_political_test/UI/screens/widget/show_name_form.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  AudioPlayer _musicPlayer = AudioPlayer();
  late AnimationController _floatController;
  late AnimationController _pulseController;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  // Particles
  final List<_Particle> _particles = [];
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    //play music
    playMusic();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: 0, end: -10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 0.8).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();

    _particleController.addListener(_updateParticles);
  }

  void _updateParticles() {
    final random = Random();
    setState(() {
      // Add new particle occasionally
      if (random.nextDouble() < 0.05) {
        _particles.add(_Particle(random));
      }

      // Update & remove finished particles
      for (final p in _particles) {
        p.progress += 0.008;
      }
      _particles.removeWhere((p) => p.progress >= 1.0);
    });
  }

  @override
  void dispose() {
    _floatController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _musicPlayer.dispose();
    super.dispose();
  }

  Future<void> playMusic() async {
    await _musicPlayer.setAsset("assets/music/main_menu_song.mp3");
    await _musicPlayer.setLoopMode(LoopMode.one);
    await _musicPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return CustomScaffold(
      onPausedApp: () => setState(() {
        _musicPlayer.pause();
      }),
      onResumedApp: () => setState(() {
        _musicPlayer.play();
      }),

      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.5),
                BlendMode.darken,
              ),
              child: Image.asset(
                "assets/main_screen_wallpaper.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xD9000000),
                    Color(0x262196F3),
                    Color(0xD9000000),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Particles
          ..._particles.map((p) => _buildParticle(p, size)),

          // Bottom fade gradient
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 128,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Color(0xFF111827), Colors.transparent],
                ),
              ),
            ),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(),

                // Main section
                Expanded(child: _buildMainContent()),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParticle(_Particle p, Size size) {
    final x = p.startX * size.width + sin(p.progress * pi * 2) * 20;
    final y = size.height - (p.progress * (size.height + 100));

    return Positioned(
      left: x,
      top: y,
      child: Opacity(
        opacity: (1 - p.progress).clamp(0.0, 1.0),
        child: Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: Color(0x992196F3),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Material(
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
                  if (_musicPlayer.playing) {
                    await _musicPlayer.pause();
                  } else {
                    await _musicPlayer.play();
                  }
                  setState(() {});
                },
                borderRadius: BorderRadius.circular(100),
                child: Icon(
                  _musicPlayer.playing ? MdiIcons.music : Icons.volume_off,
                  color: _musicPlayer.playing ? Colors.white : Colors.redAccent,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Logo / Title with float animation
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: child,
            );
          },
          child: Column(
            children: [
              const Text(
                'Your Political Test',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Subtitle
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            'Descubre tu alineación política a través de cuestionarios interactivos basados en el test de Nolan',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFD1D5DB),
              fontSize: 17,
              height: 1.6,
            ),
          ),
        ),

        const SizedBox(height: 48),

        // Start button with pulse
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await showNameForm(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 8,
                shadowColor: const Color(0x402196F3),
              ),
              child: const Text(
                'COMENZAR TEST',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Stats row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStat('15', 'Preguntas'),

            const SizedBox(width: 20),
            _buildStat('4', 'Dimensiones'),
          ],
        ),
      ],
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildFooterButton(Icons.info_outline, 'Acerca de'),
          const SizedBox(width: 40),
          _buildFooterButton(Icons.history, 'Historial'),
        ],
      ),
    );
  }

  Widget _buildFooterButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF6B7280), size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

// Particle model
class _Particle {
  final double startX;
  double progress;

  _Particle(Random random) : startX = random.nextDouble(), progress = 0.0;
}
