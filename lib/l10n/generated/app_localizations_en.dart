// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pomonya';

  @override
  String get homeStatusFocus => 'FOCUS SESSION';

  @override
  String get homeStatusShortBreak => 'SHORT BREAK';

  @override
  String get homeStatusLongBreak => 'LONG BREAK';

  @override
  String get homeActionFocus => 'FOCUS MISSION';

  @override
  String get homeActionBreak => 'GAME BREAK';

  @override
  String get homeActionSleep => 'EPIC SLEEP';

  @override
  String get navHome => 'HOME';

  @override
  String get navShop => 'SHOP';

  @override
  String get navStats => 'STATS';

  @override
  String get navSettings => 'SETTINGS';

  @override
  String get shopTitle => 'ARCADE SHOP';

  @override
  String get shopUnlockItem => 'UNLOCK ITEM?';

  @override
  String shopCost(int price) {
    return 'Cost: $price Gems';
  }

  @override
  String get shopCancel => 'CANCEL';

  @override
  String get shopBuy => 'BUY';

  @override
  String get shopNotEnoughGems => 'Not enough gems!';

  @override
  String get statsTitle => 'PRODUCTIVITY DATA';

  @override
  String get statsTotalProductivity => 'TOTAL PRODUCTIVITY';

  @override
  String get statsExportData => 'EXPORT DATA';

  @override
  String get statsDataExported => 'Data exported to clipboard!';

  @override
  String get settingsTitle => 'SYSTEM CONFIG';

  @override
  String get settingsFocus => 'FOCUS';

  @override
  String get settingsShortBreak => 'S. BREAK';

  @override
  String get settingsLongBreak => 'L. BREAK';

  @override
  String get settingsAutoQuest => 'Auto-Quest';

  @override
  String get settingsAutoQuestDesc => 'Auto-start next mission';

  @override
  String get settingsTheme => 'THEME';

  @override
  String get settingsThemeDark => 'DARK';

  @override
  String get settingsThemeLight => 'LIGHT';

  @override
  String get settingsSound => 'SOUND FX';

  @override
  String get settingsLanguage => 'LANGUAGE';

  @override
  String get settingsLanguageEn => 'ENGLISH';

  @override
  String get settingsLanguageId => 'INDONESIA';
}
