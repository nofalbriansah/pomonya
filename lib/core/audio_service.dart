import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCoin({bool isSoundEnabled = true}) async {
    if (!isSoundEnabled) return;
    await _player.play(AssetSource('sfx/coin.mp3'));
  }

  static Future<void> playLevelUp({bool isSoundEnabled = true}) async {
    if (!isSoundEnabled) return;
    await _player.play(AssetSource('sfx/level_up.mp3'));
  }

  static Future<void> playTimerEnd({bool isSoundEnabled = true}) async {
    if (!isSoundEnabled) return;
    await _player.play(AssetSource('sfx/timer_end.mp3'));
  }
}
