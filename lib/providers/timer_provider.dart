import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/hive_service.dart';
import '../core/audio_service.dart';
import 'currency_provider.dart';

enum TimerStatus { initial, running, paused, finished }

enum TimerType { focus, shortBreak, longBreak }

class TimerState {
  final int remainingSeconds;
  final int initialDuration;
  final TimerStatus status;
  final TimerType type;
  final int cycleCount;

  TimerState({
    required this.remainingSeconds,
    required this.initialDuration,
    required this.status,
    required this.type,
    required this.cycleCount,
  });

  TimerState copyWith({
    int? remainingSeconds,
    int? initialDuration,
    TimerStatus? status,
    TimerType? type,
    int? cycleCount,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      initialDuration: initialDuration ?? this.initialDuration,
      status: status ?? this.status,
      type: type ?? this.type,
      cycleCount: cycleCount ?? this.cycleCount,
    );
  }
}

final timerProvider = NotifierProvider<TimerNotifier, TimerState>(
  TimerNotifier.new,
);

class TimerNotifier extends Notifier<TimerState> {
  Timer? _ticker;

  @override
  TimerState build() {
    // We can't easily call _loadSettings here because it returns a value
    final settings = HiveService.getSettings();
    return TimerState(
      remainingSeconds: settings.focusDuration,
      initialDuration: settings.focusDuration,
      status: TimerStatus.initial,
      type: TimerType.focus,
      cycleCount: 0,
    );
  }

  void start() {
    if (state.status == TimerStatus.running) return;

    state = state.copyWith(status: TimerStatus.running);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.remainingSeconds > 0) {
        state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
      } else {
        _handleTimerComplete();
      }
    });
  }

  void pause() {
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  void reset() {
    _ticker?.cancel();
    final settings = HiveService.getSettings();

    int duration = settings.focusDuration;
    if (state.type == TimerType.shortBreak) {
      duration = settings.shortBreakDuration;
    } else if (state.type == TimerType.longBreak) {
      duration = settings.longBreakDuration;
    }

    state = state.copyWith(
      status: TimerStatus.initial,
      remainingSeconds: duration,
      initialDuration: duration,
    );
  }

  void skip() {
    _ticker?.cancel();
    _advancePhase();
  }

  void _handleTimerComplete() {
    _ticker?.cancel();
    state = state.copyWith(status: TimerStatus.finished);

    if (state.type == TimerType.focus) {
      ref.read(currencyProvider.notifier).addCoins(5);
      _saveStats(state.initialDuration);
      AudioService.playCoin();
    } else {
      AudioService.playTimerEnd();
    }

    _advancePhase();
  }

  void _saveStats(int seconds) {
    final progress = HiveService.getUserProgress();
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final currentStats = Map<String, int>.from(progress.dailyFocusStats);
    currentStats[dateStr] = (currentStats[dateStr] ?? 0) + seconds;

    progress.dailyFocusStats = currentStats;
    progress.save();
  }

  void _advancePhase() {
    final settings = HiveService.getSettings();

    TimerType nextType;
    int nextDuration;
    int nextCycle = state.cycleCount;

    if (state.type == TimerType.focus) {
      nextCycle++;
      if (nextCycle % 4 == 0) {
        nextType = TimerType.longBreak;
        nextDuration = settings.longBreakDuration;
      } else {
        nextType = TimerType.shortBreak;
        nextDuration = settings.shortBreakDuration;
      }
    } else {
      nextType = TimerType.focus;
      nextDuration = settings.focusDuration;
    }

    state = state.copyWith(
      status: settings.autoQuest ? TimerStatus.running : TimerStatus.initial,
      type: nextType,
      initialDuration: nextDuration,
      remainingSeconds: nextDuration,
      cycleCount: nextCycle,
    );

    if (settings.autoQuest) {
      start();
    }
  }
}
