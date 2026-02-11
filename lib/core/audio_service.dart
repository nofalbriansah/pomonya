import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCoin({bool isSoundEnabled = true}) async {
    if (!isSoundEnabled) return;
    try {
      await _player.play(AssetSource('sfx/coin.mp3'));
    } catch (e) {
      debugPrint('Error playing coin sound: $e');
    }
  }

  static Future<void> playLevelUp({bool isSoundEnabled = true}) async {
    if (!isSoundEnabled) return;
    try {
      await _player.play(AssetSource('sfx/level_up.mp3'));
    } catch (e) {
      debugPrint('Error playing level up sound: $e');
    }
  }

  static Future<void> playTimerEnd({bool isSoundEnabled = true}) async {
    if (!isSoundEnabled) return;
    try {
      await _player.play(AssetSource('sfx/timer_end.mp3'));
    } catch (e) {
      debugPrint('Error playing timer end sound: $e');
    }
  }
}
