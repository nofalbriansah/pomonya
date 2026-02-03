import 'dart:convert';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:pomonya/l10n/generated/app_localizations.dart';
import '../../core/constants.dart';
import '../../providers/stats_provider.dart';
import '../../data/database_service.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(statsProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();

    return statsAsync.when(
      data: (stats) {
        // Get last 7 days including today
        final last7Days = List.generate(7, (index) {
          final date = DateTime.now().subtract(Duration(days: 6 - index));
          final dateStr =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
          return MapEntry(date, stats[dateStr] ?? 0);
        });

        final double maxY = _getMaxY(last7Days);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          body: SafeArea(
            child: Column(
              children: [
                _buildHeader(context, theme, l10n),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSummaryCard(context, theme, stats, l10n),
                          const SizedBox(height: AppSpacing.xl),
                          Text(
                            'WEEKLY PROGRESS',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.m),
                          SizedBox(
                            height: 250,
                            child: Container(
                              padding: const EdgeInsets.fromLTRB(
                                AppSpacing.s,
                                AppSpacing.xl,
                                AppSpacing.m,
                                AppSpacing.s,
                              ),
                              decoration: BoxDecoration(
                                color: theme.cardTheme.color?.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusL,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withOpacity(
                                    0.1,
                                  ),
                                ),
                              ),
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: maxY,
                                  barTouchData: BarTouchData(
                                    enabled: true,
                                    touchTooltipData: BarTouchTooltipData(
                                      getTooltipColor: (group) =>
                                          theme.colorScheme.surface,
                                      tooltipPadding: const EdgeInsets.all(8),
                                      tooltipMargin: 8,
                                      getTooltipItem:
                                          (group, groupIndex, rod, rodIndex) {
                                            final totalSeconds =
                                                last7Days[groupIndex].value;
                                            final m = totalSeconds ~/ 60;
                                            final s = totalSeconds % 60;
                                            return BarTooltipItem(
                                              '${m}m ${s}s',
                                              TextStyle(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            );
                                          },
                                      fitInsideHorizontally: true,
                                      fitInsideVertically: true,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (value, meta) {
                                          final index = value.toInt();
                                          if (index < 0 || index >= 7) {
                                            return const SizedBox.shrink();
                                          }
                                          final date = last7Days[index].key;
                                          final dayName = DateFormat.E(
                                            locale,
                                          ).format(date);
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                            ),
                                            child: Text(
                                              dayName.toUpperCase(),
                                              style: TextStyle(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.4),
                                                fontSize: 8,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          );
                                        },
                                        reservedSize: 24,
                                      ),
                                    ),
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 28,
                                        getTitlesWidget: (value, meta) {
                                          if (value == meta.max) {
                                            return const SizedBox.shrink();
                                          }
                                          return Text(
                                            '${value.toInt()}m',
                                            style: TextStyle(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.3),
                                              fontSize: 8,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: theme.colorScheme.outline
                                            .withOpacity(0.05),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: last7Days.asMap().entries.map((
                                    entry,
                                  ) {
                                    return BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value.value / 60,
                                          color: theme.colorScheme.primary,
                                          width: 12,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          backDrawRodData:
                                              BackgroundBarChartRodData(
                                                show: true,
                                                toY: maxY,
                                                color: theme.colorScheme.primary
                                                    .withOpacity(0.05),
                                              ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildExportSection(context, theme, l10n, stats),
                          const SizedBox(height: AppSpacing.xxl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.go('/'),
            theme: theme,
          ),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                l10n.statsTitle,
                style: GoogleFonts.pressStart2p(
                  fontSize: 12,
                  color: theme.colorScheme.secondary,
                  shadows: [
                    BoxShadow(
                      color: theme.colorScheme.secondary.withOpacity(0.5),
                      blurRadius: 10,
                    ),
                  ],
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          _buildGlassButton(
            icon: Icons.refresh_rounded,
            onTap: () async {
              await _seedDummyData();
            },
            theme: theme,
          ),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.cardTheme.color?.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Icon(
          icon,
          color: theme.iconTheme.color?.withOpacity(0.8),
          size: 20,
        ),
      ),
    );
  }

  double _getMaxY(List<MapEntry<DateTime, int>> data) {
    double maxMins = 60.0; // Default 1 hour
    for (var entry in data) {
      double mins = entry.value.toDouble() / 60;
      if (mins > maxMins) maxMins = mins;
    }
    return (maxMins * 1.2).ceilToDouble().clamp(60, 10000);
  }

  Widget _buildSummaryCard(
    BuildContext context,
    ThemeData theme,
    Map<String, int> stats,
    AppLocalizations l10n,
  ) {
    int totalSeconds = stats.values.fold(0, (sum, val) => sum + val);
    int totalMins = totalSeconds ~/ 60;
    int hrs = totalMins ~/ 60;
    int mins = totalMins % 60;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.l),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.secondary.withOpacity(0.1),
            theme.colorScheme.tertiary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.borderRadiusL),
        border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.secondary.withOpacity(0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    l10n.statsTotalProductivity,
                    style: GoogleFonts.pressStart2p(
                      color: theme.colorScheme.secondary,
                      fontSize: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '$hrs',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        'h ',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                      Text(
                        '$mins',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1,
                        ),
                      ),
                      Text(
                        'm',
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: theme.colorScheme.secondary.withOpacity(0.5),
              ),
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: theme.colorScheme.secondary,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportSection(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Map<String, int> stats,
  ) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => _showExportDialog(context, theme, l10n, stats),
        icon: const Icon(Icons.download_rounded),
        label: Text(
          l10n.statsExportData,
          style: GoogleFonts.pressStart2p(fontSize: 10),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surfaceContainer,
          foregroundColor: theme.colorScheme.primary,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.borderRadiusM),
            side: BorderSide(color: theme.colorScheme.primary),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  void _showExportDialog(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    Map<String, int> stats,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(
          'EXPORT FORMAT',
          style: GoogleFonts.pressStart2p(fontSize: 12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('CSV (Comma Separated Values)'),
              onTap: () {
                Navigator.pop(context);
                _exportToFile(context, l10n, stats, 'csv');
              },
            ),
            ListTile(
              title: const Text('JSON (JavaScript Object Notation)'),
              onTap: () {
                Navigator.pop(context);
                _exportToFile(context, l10n, stats, 'json');
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToFile(
    BuildContext context,
    AppLocalizations l10n,
    Map<String, int> stats,
    String format,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    String content;
    String fileName =
        'pomonya_stats_${DateTime.now().millisecondsSinceEpoch}.$format';

    if (format == 'csv') {
      final sortedDates = stats.keys.toList()..sort();
      final buffer = StringBuffer('Date,FocusDurationInSeconds\n');
      for (final date in sortedDates) {
        buffer.writeln('$date,${stats[date]}');
      }
      content = buffer.toString();
    } else {
      content = const JsonEncoder.withIndent('  ').convert(stats);
    }

    try {
      if (kIsWeb) {
        // Fallback for web - clipboard + helpful message
        await Clipboard.setData(ClipboardData(text: content));
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Data copied to clipboard! (Web download trigger pending browser security check)',
            ),
          ),
        );
        return;
      }

      // For Desktop
      String? outputFile;
      if (io.Platform.isLinux || io.Platform.isWindows || io.Platform.isMacOS) {
        outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Select save location:',
          fileName: fileName,
        );
      }

      if (outputFile != null) {
        final file = io.File(outputFile);
        await file.writeAsString(content);
        messenger.showSnackBar(
          SnackBar(content: Text('File saved to: $outputFile')),
        );
      } else {
        // Fallback for Android or cancelled dialog
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = io.File(filePath);
        await file.writeAsString(content);
        messenger.showSnackBar(
          SnackBar(content: Text('Stored in app documents: $filePath')),
        );
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error saving file: $e')));
    }
  }

  Future<void> _seedDummyData() async {
    await DatabaseService.seedDummyData();
    ref.invalidate(statsProvider);
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Dummy data seeded!')));
    }
  }
}
