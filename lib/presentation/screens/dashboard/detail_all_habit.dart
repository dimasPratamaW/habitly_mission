import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/style/app_color.dart';

import '../../state/auth_providers.dart';
import '../../state/habit_providers.dart';

class DetailAllHabit extends ConsumerStatefulWidget {
  static const routeName = '/detail_all_habit';
  const DetailAllHabit({super.key});

  @override
  ConsumerState<DetailAllHabit> createState() => _DetailAllHabitState();
}

class _DetailAllHabitState extends ConsumerState<DetailAllHabit> {
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

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Habit by Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 20),
                _barRow('Total', total, total, Colors.blue),
                _barRow('Upcoming', upcoming, total, Colors.orange),
                _barRow('Ongoing', ongoing, total, Colors.purple),
                _barRow('Completed', completed, total, Colors.green),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('ERROR please ask developer')),
      ),
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