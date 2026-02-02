import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants.dart';
import '../../providers/timer_provider.dart';
import '../widgets/mpus_animation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Background Blobs
          Positioned(
            top: -200,
            left: -100,
            child: _buildBlurCircle(Colors.purple.shade900, 500),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: _buildBlurCircle(Colors.blue.shade900, 400),
          ),
          Positioned(
            top: 300,
            left: -150,
            child: _buildBlurCircle(Colors.green.shade900, 300),
          ),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimerDisplay(context, timerState),
                    const SizedBox(height: 60),
                    _buildControls(ref, timerState),
                    const SizedBox(height: 20), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlurCircle(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withOpacity(0.3),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
        child: Container(color: Colors.transparent),
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
      ),
    );
  }

  Widget _buildTimerDisplay(BuildContext context, TimerState state) {
    return Column(
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Inner glowing ring
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.neonFuchsia.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.neonFuchsia.withOpacity(0.15),
                      blurRadius: 30,
                      spreadRadius: 0,
                    ),
                  ],
                ),
              ),
              // Mpus Character (scaled)
              Transform.scale(
                scale: 1.5,
                child: MpusAnimation(
                  isWorking:
                      state.status == TimerStatus.running &&
                      state.type == TimerType.focus,
                  isBreak:
                      state.status == TimerStatus.running &&
                      state.type != TimerType.focus,
                ),
              ),
            ],
          ),
        ),
        // Timer Text
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFF94A3B8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Text(
            _formatTime(state.remainingSeconds),
            style: GoogleFonts.spaceGrotesk(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1,
              letterSpacing: -2,
            ),
          ),
        ),
        const SizedBox(height: 40), // Increased spacing
        // Focus Session Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.surfaceDark.withOpacity(0.6),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.8),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _getStatusText(state.type),
                style: GoogleFonts.pressStart2p(
                  fontSize: 10,
                  color: Colors.blue.shade200,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required String icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.1)),
            left: BorderSide(color: Colors.white.withOpacity(0.1)),
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.05),
              Colors.white.withOpacity(0.01),
            ],
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
          ],
        ),
        child: Stack(
          children: [
            // Top highlight line
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      color.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(icon, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 8),
                  Text(
                    label.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                      letterSpacing: 0.5,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControls(WidgetRef ref, TimerState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTimeControlButton(
          icon: Icons.refresh_rounded,
          onTap: () {
            ref.read(timerProvider.notifier).reset();
          },
        ),
        const SizedBox(width: 32),
        _buildPlayButton(
          isPlaying: state.status == TimerStatus.running,
          onTap: () {
            if (state.status == TimerStatus.running) {
              ref.read(timerProvider.notifier).pause();
            } else {
              ref.read(timerProvider.notifier).start();
            }
          },
        ),
        const SizedBox(width: 32),
        _buildTimeControlButton(
          icon: Icons.skip_next_rounded,
          onTap: () {
            ref.read(timerProvider.notifier).skip();
          },
        ), // Placeholder for symmetry or another action
      ],
    );
  }

  Widget _buildTimeControlButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: Colors.blueGrey.shade200, size: 24),
      ),
    );
  }

  Widget _buildPlayButton({
    required bool isPlaying,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.greenAccent, Colors.cyan],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.greenAccent.withOpacity(0.4),
              blurRadius: 30,
              spreadRadius: 0,
            ),
          ],
          border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                  ),
                ),
              ),
            ),
            Center(
              child: Icon(
                isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
                size: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getStatusText(TimerType type) {
    switch (type) {
      case TimerType.focus:
        return 'FOCUS SESSION';
      case TimerType.shortBreak:
        return 'SHORT BREAK';
      case TimerType.longBreak:
        return 'LONG BREAK';
    }
  }
}
