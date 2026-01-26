import 'package:audioplayers/audioplayers.dart';
import '../data/hive_service.dart';

class AudioService {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playCoin() async {
    if (!HiveService.getSettings().isSoundEnabled) return;
    await _player.play(AssetSource('sfx/coin.mp3'));
  }

  static Future<void> playLevelUp() async {
    if (!HiveService.getSettings().isSoundEnabled) return;
    await _player.play(AssetSource('sfx/level_up.mp3'));
  }

  static Future<void> playTimerEnd() async {
    if (!HiveService.getSettings().isSoundEnabled) return;
    await _player.play(AssetSource('sfx/timer_end.mp3'));
  }
}
