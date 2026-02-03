import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../data/settings_model.dart';
import '../data/user_progress_model.dart';

class DatabaseService {
  static Database? _db;
  static const String _dbName = 'pomonya.db';

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    if (kIsWeb) {
      // For web, sqflite requires a different driver or fallback.
      // Since sqflite doesn't support web out of the box easily,
      // we'll use ffi on desktop and standard on mobile.
      // Web might need a different approach or we keep it as 'not supported' for now
      // but let's try to initialize.
      databaseFactory = databaseFactoryFfi;
    } else if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final String path = join(await getDatabasesPath(), _dbName);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Settings Table
    await db.execute('''
      CREATE TABLE settings (
        id INTEGER PRIMARY KEY,
        focusDuration INTEGER,
        shortBreakDuration INTEGER,
        longBreakDuration INTEGER,
        autoQuest INTEGER,
        isSoundEnabled INTEGER,
        isDarkMode INTEGER,
        languageCode TEXT
      )
    ''');

    // Default Settings
    await db.insert('settings', {
      'id': 1,
      'focusDuration': 25 * 60,
      'shortBreakDuration': 5 * 60,
      'longBreakDuration': 15 * 60,
      'autoQuest': 0,
      'isSoundEnabled': 1,
      'isDarkMode': 1,
      'languageCode': 'en',
    });

    // User Progress Table
    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY,
        coins INTEGER
      )
    ''');

    await db.insert('user_progress', {'id': 1, 'coins': 0});

    // Unlocked Items Table
    await db.execute('''
      CREATE TABLE unlocked_items (
        name TEXT PRIMARY KEY
      )
    ''');

    // Daily Stats Table
    await db.execute('''
      CREATE TABLE daily_stats (
        date TEXT PRIMARY KEY,
        duration INTEGER
      )
    ''');
  }

  // --- Settings Methods ---

  static Future<SettingsModel> getSettings() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'settings',
      where: 'id = ?',
      whereArgs: [1],
    );

    if (maps.isEmpty) return SettingsModel();

    final map = maps.first;
    return SettingsModel(
      focusDuration: map['focusDuration'],
      shortBreakDuration: map['shortBreakDuration'],
      longBreakDuration: map['longBreakDuration'],
      autoQuest: map['autoQuest'] == 1,
      isSoundEnabled: map['isSoundEnabled'] == 1,
      isDarkMode: map['isDarkMode'] == 1,
      languageCode: map['languageCode'],
    );
  }

  static Future<void> updateSettings(SettingsModel settings) async {
    final db = await database;
    await db.update(
      'settings',
      {
        'focusDuration': settings.focusDuration,
        'shortBreakDuration': settings.shortBreakDuration,
        'longBreakDuration': settings.longBreakDuration,
        'autoQuest': settings.autoQuest ? 1 : 0,
        'isSoundEnabled': settings.isSoundEnabled == true ? 1 : 0,
        'isDarkMode': settings.isDarkMode == true ? 1 : 0,
        'languageCode': settings.languageCode,
      },
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  // --- User Progress Methods ---

  static Future<UserProgressModel> getUserProgress() async {
    final db = await database;

    // Get basic progress
    final List<Map<String, dynamic>> progressMaps = await db.query(
      'user_progress',
      where: 'id = ?',
      whereArgs: [1],
    );
    int coins = progressMaps.isNotEmpty ? progressMaps.first['coins'] : 0;

    // Get unlocked items
    final List<Map<String, dynamic>> itemsMaps = await db.query(
      'unlocked_items',
    );
    List<String> unlockedItems = itemsMaps
        .map((m) => m['name'] as String)
        .toList();

    // Get daily stats (Map)
    final List<Map<String, dynamic>> statsMaps = await db.query('daily_stats');
    Map<String, int> dailyFocusStats = {
      for (var m in statsMaps) m['date'] as String: m['duration'] as int,
    };

    return UserProgressModel(
      coins: coins,
      unlockedItems: unlockedItems,
      dailyFocusStats: dailyFocusStats,
    );
  }

  static Future<void> updateCoins(int coins) async {
    final db = await database;
    await db.update(
      'user_progress',
      {'coins': coins},
      where: 'id = ?',
      whereArgs: [1],
    );
  }

  static Future<void> addUnlockedItem(String itemName) async {
    final db = await database;
    await db.insert('unlocked_items', {
      'name': itemName,
    }, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  static Future<void> updateDailyStat(String date, int durationSeconds) async {
    final db = await database;
    await db.insert('daily_stats', {
      'date': date,
      'duration': durationSeconds,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<void> addFocusTime(String date, int secondsToAdd) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_stats',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (maps.isEmpty) {
      await db.insert('daily_stats', {'date': date, 'duration': secondsToAdd});
    } else {
      int current = maps.first['duration'];
      await db.update(
        'daily_stats',
        {'duration': current + secondsToAdd},
        where: 'date = ?',
        whereArgs: [date],
      );
    }
  }

  static Future<Map<String, int>> getDailyStats() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('daily_stats');
    return {for (var m in maps) m['date'] as String: m['duration'] as int};
  }

  // --- Seeding ---

  static Future<void> seedDummyData() async {
    final db = await database;
    final now = DateTime.now();

    await db.transaction((txn) async {
      for (int i = 0; i < 10; i++) {
        final date = now.subtract(Duration(days: i));
        final dateStr =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        // Random-ish focus time between 30 and 180 minutes
        final minutes = 30 + (i * 17 + now.minute) % 151;

        await txn.insert('daily_stats', {
          'date': dateStr,
          'duration': minutes * 60,
        }, conflictAlgorithm: ConflictAlgorithm.replace);
      }
    });
  }
}
