import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/style/app_color.dart';

import '../../state/auth_providers.dart';
import '../../state/habit_providers.dart';
import 'package:fl_chart/fl_chart.dart';

class DetailAllHabit extends ConsumerStatefulWidget {
  static const routeName = '/detail_all_habit';
  const DetailAllHabit({super.key});

  @override
  ConsumerState<DetailAllHabit> createState() => _DetailAllHabitState();
}

class _DetailAllHabitState extends ConsumerState<DetailAllHabit> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final uid = ref.watch(currentUidProvider);

    if (uid == null) return const Center(child: CircularProgressIndicator());

    final pullData = ref.watch(habitStreamProvider(uid));

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(title: const Text('Habit Summary')),
      body: pullData.when(
        data: (activities) {
          final total = activities.length;
          final upcoming = activities.where((h) => h.status == 'Upcoming').length;
          final ongoing = activities.where((h) => h.status == 'Ongoing').length;
          final completed = activities.where((h) => h.status == 'Completed').length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Habit by Status',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                _barRow('Total', total, total, Colors.blue),
                _barRow('Upcoming', upcoming, total, Colors.orange),
                _barRow('Ongoing', ongoing, total, Colors.purple),
                _barRow('Completed', completed, total, Colors.green),
                const SizedBox(height: 24),
                const Text(
                  'Distribution',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                AspectRatio(
                  aspectRatio: 1.3,
                  child: total == 0
                      ? const Center(child: Text('No data yet'))
                      : PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex =
                                pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 3,
                      centerSpaceRadius: 48,
                      sections: _buildPieSections(upcoming, ongoing, completed, total),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Legend
                if (total > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _legendItem('Upcoming', Colors.orange),
                      const SizedBox(width: 16),
                      _legendItem('Ongoing', Colors.purple),
                      const SizedBox(width: 16),
                      _legendItem('Completed', Colors.green),
                    ],
                  ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('ERROR please ask developer')),
      ),
    );
  }

  List<PieChartSectionData> _buildPieSections(
      int upcoming, int ongoing, int completed, int total) {
    final data = [
      {'label': 'Upcoming', 'value': upcoming, 'color': Colors.orange},
      {'label': 'Ongoing', 'value': ongoing, 'color': Colors.purple},
      {'label': 'Completed', 'value': completed, 'color': Colors.green},
    ];

    return List.generate(data.length, (i) {
      final isTouched = i == _touchedIndex;
      final count = data[i]['value'] as int;
      final color = data[i]['color'] as Color;
      final percentage = (count / total * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: color,
        value: count.toDouble(),
        title: count == 0 ? '' : '$percentage%',
        radius: isTouched ? 70 : 56,
        titleStyle: TextStyle(
          fontSize: isTouched ? 14 : 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _barRow(String label, int count, int total, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : count / total,
                backgroundColor: Colors.grey.shade200,
                color: color,
                minHeight: 20,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text('$count', style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}