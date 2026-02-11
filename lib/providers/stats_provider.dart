import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';

final statsProvider = AsyncNotifierProvider<StatsNotifier, Map<String, int>>(
  StatsNotifier.new,
);

class StatsNotifier extends AsyncNotifier<Map<String, int>> {
  @override
  Future<Map<String, int>> build() async {
    final stats = await DatabaseService.getDailyStats();
    if (stats.isEmpty) {
      // Auto-seed if first time opening or no data
      await DatabaseService.seedDummyData();
      return await DatabaseService.getDailyStats();
    }
    return stats;
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => DatabaseService.getDailyStats());
  }

  Future<void> importCsv(String csvContent) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final lines = csvContent.split('\n');
      // Assuming header: Date,FocusDurationInSeconds
      for (var i = 1; i < lines.length; i++) {
        final line = lines[i].trim();
        if (line.isEmpty) continue;

        final parts = line.split(',');
        if (parts.length >= 2) {
          final date = parts[0];
          final duration = int.tryParse(parts[1]) ?? 0;
          await DatabaseService.updateDailyStat(date, duration);
        }
      }
      return await DatabaseService.getDailyStats();
    });
  }
}
