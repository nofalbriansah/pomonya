import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants.dart';
import '../../data/hive_service.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Force rebuild when stats change? Usually hive listener or provider needed.
    // For now we assume build triggers on nav.
    final progress = HiveService.getUserProgress();
    final stats = progress.dailyFocusStats;

    // Get last 7 days including today
    final last7Days = List.generate(7, (index) {
      final date = DateTime.now().subtract(Duration(days: 6 - index));
      final dateStr =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      return MapEntry(dateStr, stats[dateStr] ?? 0);
    });

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryCard(context, stats),
                      const SizedBox(height: 32),
                      Text(
                        'WEEKLY PROGRESS',
                        style: GoogleFonts.pressStart2p(
                          color: AppColors.electricBlue,
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 300,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: AppColors.glassBorder),
                          ),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: _getMaxY(last7Days),
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  tooltipPadding: const EdgeInsets.all(8),
                                  tooltipMargin: 8,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                        return BarTooltipItem(
                                          '${rod.toY.toInt()} min',
                                          const TextStyle(
                                            color: AppColors.electricBlue,
                                            fontWeight: FontWeight.bold,
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
                                      if (index < 0 ||
                                          index >= last7Days.length) {
                                        return const Text('');
                                      }
                                      // Parse to get weekday? Or just show DD
                                      final date = DateTime.parse(
                                        last7Days[index].key,
                                      );
                                      final weekdays = [
                                        'M',
                                        'T',
                                        'W',
                                        'T',
                                        'F',
                                        'S',
                                        'S',
                                      ];

                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          top: 12.0,
                                        ),
                                        child: Text(
                                          weekdays[date.weekday - 1],
                                          style: GoogleFonts.spaceGrotesk(
                                            color: AppColors.textSecondary,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                leftTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: const FlGridData(show: false),
                              borderData: FlBorderData(show: false),
                              barGroups: last7Days.asMap().entries.map((entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      toY:
                                          entry.value.value.toDouble() /
                                          60, // Convert to minutes
                                      gradient: const LinearGradient(
                                        colors: [
                                          AppColors.electricBlue,
                                          Colors.blueAccent,
                                        ],
                                        begin: Alignment.bottomCenter,
                                        end: Alignment.topCenter,
                                      ),
                                      width: 12,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(6),
                                      ),
                                      backDrawRodData:
                                          BackgroundBarChartRodData(
                                            show: true,
                                            toY: _getMaxY(last7Days),
                                            color: Colors.white.withOpacity(
                                              0.05,
                                            ),
                                          ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildExportButton(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassButton(
            icon: Icons.arrow_back_rounded,
            onTap: () => context.go('/'),
          ),
          Text(
            'STATISTICS',
            style: GoogleFonts.pressStart2p(
              fontSize: 12,
              color: AppColors.neonFuchsia,
              shadows: [
                BoxShadow(
                  color: AppColors.neonFuchsia.withOpacity(0.5),
                  blurRadius: 10,
                ),
              ],
              letterSpacing: 2,
            ),
          ),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildGlassButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Icon(icon, color: Colors.white.withOpacity(0.8), size: 20),
      ),
    );
  }

  double _getMaxY(List<MapEntry<String, int>> data) {
    double max = 60.0; // Default 1 hour
    for (var entry in data) {
      double mins = entry.value.toDouble() / 60;
      if (mins > max) max = mins;
    }
    return max + 10;
  }

  Widget _buildSummaryCard(BuildContext context, Map<String, int> stats) {
    int totalSeconds = stats.values.fold(0, (sum, val) => sum + val);
    int totalMins = totalSeconds ~/ 60;
    int hrs = totalMins ~/ 60;
    int mins = totalMins % 60;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.neonFuchsia.withOpacity(0.1),
            Colors.purpleAccent.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.neonFuchsia.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.neonFuchsia.withOpacity(0.05),
            blurRadius: 20,
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
                'TOTAL FOCUS',
                style: GoogleFonts.pressStart2p(
                  color: AppColors.neonFuchsia,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 12),
              Row(
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
            ],
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.neonFuchsia.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neonFuchsia.withOpacity(0.5)),
            ),
            child: const Icon(
              Icons.bolt_rounded,
              color: AppColors.neonFuchsia,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Stats exported to CSV!')),
          );
        },
        icon: const Icon(Icons.download_rounded),
        label: Text(
          'EXPORT DATA',
          style: GoogleFonts.pressStart2p(fontSize: 10),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceDark,
          foregroundColor: AppColors.electricBlue,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.electricBlue),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
