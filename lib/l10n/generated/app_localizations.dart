import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Pomonya'**
  String get appTitle;

  /// No description provided for @homeStatusFocus.
  ///
  /// In en, this message translates to:
  /// **'FOCUS SESSION'**
  String get homeStatusFocus;

  /// No description provided for @homeStatusShortBreak.
  ///
  /// In en, this message translates to:
  /// **'SHORT BREAK'**
  String get homeStatusShortBreak;

  /// No description provided for @homeStatusLongBreak.
  ///
  /// In en, this message translates to:
  /// **'LONG BREAK'**
  String get homeStatusLongBreak;

  /// No description provided for @homeActionFocus.
  ///
  /// In en, this message translates to:
  /// **'FOCUS MISSION'**
  String get homeActionFocus;

  /// No description provided for @homeActionBreak.
  ///
  /// In en, this message translates to:
  /// **'GAME BREAK'**
  String get homeActionBreak;

  /// No description provided for @homeActionSleep.
  ///
  /// In en, this message translates to:
  /// **'EPIC SLEEP'**
  String get homeActionSleep;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get navHome;

  /// No description provided for @navShop.
  ///
  /// In en, this message translates to:
  /// **'SHOP'**
  String get navShop;

  /// No description provided for @navStats.
  ///
  /// In en, this message translates to:
  /// **'STATS'**
  String get navStats;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get navSettings;

  /// No description provided for @shopTitle.
  ///
  /// In en, this message translates to:
  /// **'ARCADE SHOP'**
  String get shopTitle;

  /// No description provided for @shopUnlockItem.
  ///
  /// In en, this message translates to:
  /// **'UNLOCK ITEM?'**
  String get shopUnlockItem;

  /// No description provided for @shopCost.
  ///
  /// In en, this message translates to:
  /// **'Cost: {price} Gems'**
  String shopCost(int price);

  /// No description provided for @shopCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get shopCancel;

  /// No description provided for @shopBuy.
  ///
  /// In en, this message translates to:
  /// **'BUY'**
  String get shopBuy;

  /// No description provided for @shopNotEnoughGems.
  ///
  /// In en, this message translates to:
  /// **'Not enough gems!'**
  String get shopNotEnoughGems;

  /// No description provided for @statsTitle.
  ///
  /// In en, this message translates to:
  /// **'PRODUCTIVITY DATA'**
  String get statsTitle;

  /// No description provided for @statsTotalProductivity.
  ///
  /// In en, this message translates to:
  /// **'TOTAL PRODUCTIVITY'**
  String get statsTotalProductivity;

  /// No description provided for @statsExportData.
  ///
  /// In en, this message translates to:
  /// **'EXPORT DATA'**
  String get statsExportData;

  /// No description provided for @statsDataExported.
  ///
  /// In en, this message translates to:
  /// **'Data exported to clipboard!'**
  String get statsDataExported;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM CONFIG'**
  String get settingsTitle;

  /// No description provided for @settingsFocus.
  ///
  /// In en, this message translates to:
  /// **'FOCUS'**
  String get settingsFocus;

  /// No description provided for @settingsShortBreak.
  ///
  /// In en, this message translates to:
  /// **'S. BREAK'**
  String get settingsShortBreak;

  /// No description provided for @settingsLongBreak.
  ///
  /// In en, this message translates to:
  /// **'L. BREAK'**
  String get settingsLongBreak;

  /// No description provided for @settingsAutoQuest.
  ///
  /// In en, this message translates to:
  /// **'Auto-Quest'**
  String get settingsAutoQuest;

  /// No description provided for @settingsAutoQuestDesc.
  ///
  /// In en, this message translates to:
  /// **'Auto-start next mission'**
  String get settingsAutoQuestDesc;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'THEME'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'DARK'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'LIGHT'**
  String get settingsThemeLight;

  /// No description provided for @settingsSound.
  ///
  /// In en, this message translates to:
  /// **'SOUND FX'**
  String get settingsSound;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageEn.
  ///
  /// In en, this message translates to:
  /// **'ENGLISH'**
  String get settingsLanguageEn;

  /// No description provided for @settingsLanguageId.
  ///
  /// In en, this message translates to:
  /// **'INDONESIA'**
  String get settingsLanguageId;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
