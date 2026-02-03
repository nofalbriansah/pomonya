import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/database_service.dart';

final statsProvider = FutureProvider<Map<String, int>>((ref) async {
  return await DatabaseService.getDailyStats();
});
