import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomonya/l10n/generated/app_localizations.dart';
import '../../core/constants.dart';
import '../../providers/timer_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: timerState.when(
          data: (state) => Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 40),
              // Timer Display (Circle + Text)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTimerCircle(context, state, theme, l10n),
                    const SizedBox(height: 32),
                    _buildTimerText(context, state, theme),
                  ],
                ),
              ),
              // Controls
              Padding(
                padding: const EdgeInsets.only(bottom: 60),
                child: _buildControls(ref, state, theme),
              ),
            ],
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildTimerCircle(
    BuildContext context,
    TimerState state,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Progress Track
            Positioned.fill(
              child: CustomPaint(
                painter: _TimerProgressPainter(
                  progress: 1.0, // Background track
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.05),
                  strokeWidth: 2,
                ),
              ),
            ),
            // Progress Value
            Positioned.fill(
              child: CustomPaint(
                painter: _TimerProgressPainter(
                  progress: state.status == TimerStatus.initial
                      ? 1.0
                      : state.remainingSeconds /
                            (state.type == TimerType.focus
                                ? AppConstants.defaultFocusDuration
                                : AppConstants
                                      .defaultShortBreakDuration), // Approximate, actual duration would be better
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  strokeWidth: 3,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.7),
                    ],
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.pets_rounded,
                    size: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _getStatusText(state, l10n),
                  style: theme.textTheme.labelLarge?.copyWith(
                    letterSpacing: 2,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getStatusText(TimerState state, AppLocalizations l10n) {
    if (state.status == TimerStatus.initial) return 'IDLE';
    if (state.status == TimerStatus.paused) return 'PAUSED';
    return state.type == TimerType.focus ? 'FOCUSING' : 'BREAK';
  }

  Widget _buildTimerText(
    BuildContext context,
    TimerState state,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          _formatTime(state.remainingSeconds),
          style: theme.textTheme.displayLarge?.copyWith(
            fontSize: 48,
            letterSpacing: -2,
          ),
        ),
      ),
    );
  }

  Widget _buildControls(WidgetRef ref, TimerState state, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSmallButton(
          icon: Icons.refresh_rounded,
          onTap: () => ref.read(timerProvider.notifier).reset(),
          theme: theme,
        ),
        const SizedBox(width: 32),
        _buildLargePlayButton(
          isPlaying: state.status == TimerStatus.running,
          onTap: () {
            if (state.status == TimerStatus.running) {
              ref.read(timerProvider.notifier).pause();
            } else {
              ref.read(timerProvider.notifier).start();
            }
          },
          theme: theme,
        ),
        const SizedBox(width: 32),
        _buildSmallButton(
          icon: Icons.skip_next_rounded,
          onTap: () => ref.read(timerProvider.notifier).skip(),
          theme: theme,
        ),
      ],
    );
  }

  Widget _buildSmallButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outline),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(icon, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }

  Widget _buildLargePlayButton({
    required bool isPlaying,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 4,
          ),
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 40,
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

class _TimerProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _TimerProgressPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708, // -90 degrees
      6.28319 * progress, // 360 degrees * progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
