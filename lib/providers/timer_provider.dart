import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';
import '../core/audio_service.dart';
import 'currency_provider.dart';
import 'settings_provider.dart';

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

final timerProvider = AsyncNotifierProvider<TimerNotifier, TimerState>(
  TimerNotifier.new,
);

class TimerNotifier extends AsyncNotifier<TimerState> {
  Timer? _ticker;

  @override
  Future<TimerState> build() async {
    final settings = await ref.watch(settingsProvider.future);
    return TimerState(
      remainingSeconds: settings.focusDuration,
      initialDuration: settings.focusDuration,
      status: TimerStatus.initial,
      type: TimerType.focus,
      cycleCount: 0,
    );
  }

  Future<void> start() async {
    final currentState = await future;
    if (currentState.status == TimerStatus.running) return;

    state = AsyncData(currentState.copyWith(status: TimerStatus.running));
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final s = await future;
      if (s.remainingSeconds > 0) {
        state = AsyncData(s.copyWith(remainingSeconds: s.remainingSeconds - 1));
      } else {
        _handleTimerComplete();
      }
    });
  }

  void pause() {
    _ticker?.cancel();
    state = state.whenData((s) => s.copyWith(status: TimerStatus.paused));
  }

  Future<void> reset() async {
    _ticker?.cancel();
    final settings = await ref.read(settingsProvider.future);
    final currentState = await future;

    int duration = settings.focusDuration;
    if (currentState.type == TimerType.shortBreak) {
      duration = settings.shortBreakDuration;
    } else if (currentState.type == TimerType.longBreak) {
      duration = settings.longBreakDuration;
    }

    state = AsyncData(
      currentState.copyWith(
        status: TimerStatus.initial,
        remainingSeconds: duration,
        initialDuration: duration,
      ),
    );
  }

  void setDuration(int duration) {
    _ticker?.cancel();
    state = state.whenData(
      (s) => s.copyWith(
        status: TimerStatus.initial,
        remainingSeconds: duration,
        initialDuration: duration,
      ),
    );
  }

  void skip() {
    _ticker?.cancel();
    _advancePhase();
  }

  Future<void> _handleTimerComplete() async {
    _ticker?.cancel();
    final currentState = await future;
    final settings = await ref.read(settingsProvider.future);
    final isSoundEnabled = settings.isSoundEnabled ?? true;

    if (currentState.type == TimerType.focus) {
      await ref.read(currencyProvider.notifier).addCoins(5);
      await _saveStats(currentState.initialDuration);
      AudioService.playCoin(isSoundEnabled: isSoundEnabled);
    } else {
      AudioService.playTimerEnd(isSoundEnabled: isSoundEnabled);
    }

    _advancePhase();
  }

  Future<void> _saveStats(int seconds) async {
    final today = DateTime.now();
    final dateStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    await DatabaseService.addFocusTime(dateStr, seconds);
  }

  Future<void> _advancePhase() async {
    _ticker?.cancel();
    final settings = await ref.read(settingsProvider.future);
    final currentState = await future;

    TimerType nextType;
    int nextDuration;
    int nextCycle = currentState.cycleCount;

    if (currentState.type == TimerType.focus) {
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

    final newState = currentState.copyWith(
      status: settings.autoQuest ? TimerStatus.running : TimerStatus.initial,
      type: nextType,
      initialDuration: nextDuration,
      remainingSeconds: nextDuration,
      cycleCount: nextCycle,
    );

    state = AsyncData(newState);

    if (settings.autoQuest) {
      start();
    }
  }
}
