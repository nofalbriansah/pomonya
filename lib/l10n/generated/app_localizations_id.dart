// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Pomonya';

  @override
  String get homeStatusFocus => 'SESI FOKUS';

  @override
  String get homeStatusShortBreak => 'ISTIRAHAT PENDEK';

  @override
  String get homeStatusLongBreak => 'ISTIRAHAT PANJANG';

  @override
  String get homeActionFocus => 'MISI FOKUS';

  @override
  String get homeActionBreak => 'JEDA GAME';

  @override
  String get homeActionSleep => 'TIDUR EPIK';

  @override
  String get navHome => 'BERANDA';

  @override
  String get navShop => 'TOKO';

  @override
  String get navStats => 'STATISTIK';

  @override
  String get navSettings => 'PENGATURAN';

  @override
  String get shopTitle => 'TOKO ARKADE';

  @override
  String get shopUnlockItem => 'BUKA ITEM?';

  @override
  String shopCost(int price) {
    return 'Biaya: $price Permata';
  }

  @override
  String get shopCancel => 'BATAL';

  @override
  String get shopBuy => 'BELI';

  @override
  String get shopNotEnoughGems => 'Permata tidak cukup!';

  @override
  String get statsTitle => 'DATA PRODUKTIVITAS';

  @override
  String get statsTotalProductivity => 'TOTAL PRODUKTIVITAS';

  @override
  String get statsExportData => 'EKSPOR DATA';

  @override
  String get statsDataExported => 'Data disalin ke papan klip!';

  @override
  String get settingsTitle => 'KONFIGURASI SISTEM';

  @override
  String get settingsFocus => 'FOKUS';

  @override
  String get settingsShortBreak => 'ISTIRAHAT P.';

  @override
  String get settingsLongBreak => 'ISTIRAHAT L.';

  @override
  String get settingsAutoQuest => 'Auto-Quest';

  @override
  String get settingsAutoQuestDesc => 'Mulai misi otomatis';

  @override
  String get settingsTheme => 'TEMA';

  @override
  String get settingsThemeDark => 'GELAP';

  @override
  String get settingsThemeLight => 'TERANG';

  @override
  String get settingsSound => 'SOUND FX';

  @override
  String get settingsLanguage => 'BAHASA';

  @override
  String get settingsLanguageEn => 'INGGRIS';

  @override
  String get settingsLanguageId => 'INDONESIA';
}
