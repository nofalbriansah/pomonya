import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pomonya/l10n/generated/app_localizations.dart';
import '../../core/constants.dart';
import '../../providers/timer_provider.dart';
import '../widgets/mpus_animation.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);

    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                child: timerState.when(
                  data: (state) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTimerDisplay(context, state, theme, l10n),
                      const SizedBox(height: 60),
                      _buildControls(ref, state, theme),
                      const SizedBox(height: 40), // Space for bottom nav
                    ],
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
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
    required ThemeData theme,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.cardTheme.shape is RoundedRectangleBorder
              ? (theme.cardTheme.shape as RoundedRectangleBorder).side.color ??
                    AppColors.glassBorder
              : AppColors.glassBorder,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Icon(
          icon,
          color:
              theme.iconTheme.color?.withOpacity(0.8) ??
              Colors.white.withOpacity(0.8),
          size: 20,
        ),
      ),
    );
  }

  Widget _buildTimerDisplay(
    BuildContext context,
    TimerState state,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow ring
              Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.1),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.dividerColor.withOpacity(0.05),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              // Inner glowing ring
              Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: theme.colorScheme.secondary.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.secondary.withOpacity(0.15),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [
                  theme.textTheme.displayLarge?.color ?? Colors.white,
                  theme.textTheme.displayLarge?.color?.withOpacity(0.7) ??
                      Colors.blueGrey,
                ],
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
          ),
        ),
      ],
    );
  }

  Widget _buildControls(WidgetRef ref, TimerState state, ThemeData theme) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildTimeControlButton(
              icon: Icons.refresh_rounded,
              onTap: () {
                ref.read(timerProvider.notifier).reset();
              },
              theme: theme,
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
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeControlButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: theme.cardTheme.color?.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: theme.cardTheme.shape is RoundedRectangleBorder
                ? (theme.cardTheme.shape as RoundedRectangleBorder)
                          .side
                          .color ??
                      AppColors.glassBorder
                : AppColors.glassBorder,
          ),
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
}
