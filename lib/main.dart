import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pomonya/l10n/generated/app_localizations.dart';
import 'core/theme.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'core/router.dart';

import 'data/database_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize SQLite
  await DatabaseService.database;
  runApp(const ProviderScope(child: PomonyaApp()));
}

class PomonyaApp extends ConsumerWidget {
  const PomonyaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeProvider);
    final localeAsync = ref.watch(localeProvider);
    final router = ref.watch(routerProvider);

    return themeModeAsync.when(
      data: (themeMode) => localeAsync.when(
        data: (locale) => MaterialApp.router(
          title: 'Pomonya',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeMode,
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('id')],
          routerConfig: router,
        ),
        loading: () => const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
        error: (err, stack) => MaterialApp(
          home: Scaffold(
            body: Center(child: Text('Error loading locale: $err')),
          ),
        ),
      ),
      loading: () => const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      error: (err, stack) => MaterialApp(
        home: Scaffold(body: Center(child: Text('Error loading theme: $err'))),
      ),
    );
  }
}
