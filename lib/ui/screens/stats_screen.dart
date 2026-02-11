import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:pomonya/l10n/generated/app_localizations.dart';
import '../../core/constants.dart';
import '../../providers/stats_provider.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  @override
  void initState() {
    super.initState();
    // Auto sync/refresh data whenever the page is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statsProvider.notifier).refresh();
    });
  }

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
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                              letterSpacing: 1.2,
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
                                color: theme.cardTheme.color?.withValues(
                                  alpha: 0.6,
                                ),
                                borderRadius: BorderRadius.circular(
                                  AppSpacing.borderRadiusL,
                                ),
                                border: Border.all(
                                  color: theme.colorScheme.outline.withValues(
                                    alpha: 0.1,
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
                                              GoogleFonts.inter(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.w900,
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
                                              style: GoogleFonts.inter(
                                                color: theme
                                                    .colorScheme
                                                    .onSurface
                                                    .withValues(alpha: 0.4),
                                                fontSize: 9,
                                                fontWeight: FontWeight.w800,
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
                                        reservedSize: 32,
                                        getTitlesWidget: (value, meta) {
                                          if (value == meta.max) {
                                            return const SizedBox.shrink();
                                          }
                                          return Text(
                                            '${value.toInt()}m',
                                            style: GoogleFonts.inter(
                                              color: theme.colorScheme.onSurface
                                                  .withValues(alpha: 0.3),
                                              fontSize: 9,
                                              fontWeight: FontWeight.w600,
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
                                            .withValues(alpha: 0.05),
                                        strokeWidth: 1,
                                      );
                                    },
                                  ),
                                  borderData: FlBorderData(show: false),
                                  barGroups: last7Days.asMap().entries.map((
                                    entry,
                                  ) {
                                    final isToday = entry.key == 6;
                                    return BarChartGroupData(
                                      x: entry.key,
                                      barRods: [
                                        BarChartRodData(
                                          toY: entry.value.value / 60,
                                          color: isToday
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.primary
                                                    .withValues(alpha: 0.6),
                                          width: 14,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(6),
                                              ),
                                          backDrawRodData:
                                              BackgroundBarChartRodData(
                                                show: true,
                                                toY: maxY,
                                                color: theme.colorScheme.primary
                                                    .withValues(alpha: 0.05),
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSquircleBackButton(context, theme),
          Text(
            l10n.statsTitle.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(width: 40), // Symmetric spacer
        ],
      ),
    );
  }

  Widget _buildSquircleBackButton(BuildContext context, ThemeData theme) {
    return GestureDetector(
      onTap: () => context.go('/'),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withValues(alpha: 0.1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: theme.colorScheme.onSurface,
          size: 18,
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.statsTotalProductivity.toUpperCase(),
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$hrs',
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'H ',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    '$mins',
                    style: GoogleFonts.inter(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'M',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.trending_up_rounded,
              color: Colors.white,
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
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            onPressed: () => _importFromFile(context, theme, l10n),
            icon: Icons.upload_rounded,
            label: 'IMPORT',
            color: theme.colorScheme.primary,
            theme: theme,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionButton(
            onPressed: () => _exportToFile(context, l10n, stats),
            icon: Icons.download_rounded,
            label: 'EXPORT',
            color: theme.colorScheme.secondary,
            theme: theme,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required ThemeData theme,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: color,
                letterSpacing: 1.1,
              ),
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
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    String fileName =
        'pomonya_stats_${DateTime.now().millisecondsSinceEpoch}.csv';

    final sortedDates = stats.keys.toList()..sort();
    final buffer = StringBuffer('Date,FocusDurationInSeconds\n');
    for (final date in sortedDates) {
      buffer.writeln('$date,${stats[date]}');
    }
    final content = buffer.toString();

    try {
      if (kIsWeb) {
        await Clipboard.setData(ClipboardData(text: content));
        messenger.showSnackBar(
          const SnackBar(content: Text('CSV copied to clipboard!')),
        );
        return;
      }

      String? outputFile;
      if (io.Platform.isLinux || io.Platform.isWindows || io.Platform.isMacOS) {
        outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save CSV Export:',
          fileName: fileName,
        );
      }

      if (outputFile != null) {
        final file = io.File(outputFile);
        await file.writeAsString(content);
        messenger.showSnackBar(
          SnackBar(content: Text('File saved to: $outputFile')),
        );
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export error: $e')));
    }
  }

  Future<void> _importFromFile(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = io.File(result.files.single.path!);
        final content = await file.readAsString();
        await ref.read(statsProvider.notifier).importCsv(content);
        messenger.showSnackBar(
          const SnackBar(content: Text('Data imported successfully!')),
        );
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Import error: $e')));
    }
  }
}
