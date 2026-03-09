import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/presentation/state/habit_providers.dart';

import '../../../data/models/habit_model.dart';
import '../../../widget/custom_dialog.dart';

class UpdateHabitScreen extends ConsumerStatefulWidget {
  static const routeName = '/update_habit_screen';
  const UpdateHabitScreen({
    super.key,
  });

  @override
  ConsumerState<UpdateHabitScreen> createState() => _UpdateHabitScreenState();
}

class _UpdateHabitScreenState extends ConsumerState<UpdateHabitScreen> {
  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }


  String? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final pullData = ref.watch(habitStreamProvider(args['uid']!));

    final getHabitDetail = pullData.when(
      data: (habits) => habits.firstWhere((h) => h.id == args['habitId']!),
      error: (err, stack) => null,
      loading: () => null,
    );

    if (getHabitDetail == null) return const Center(child: CircularProgressIndicator());

    _selectedStatus ??= getHabitDetail.status;

    return Scaffold(
      appBar: AppBar(title: Text(getHabitDetail.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // DETAIL CARD
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    _detailRow(Icons.title, 'Title', getHabitDetail.title),
                    const Divider(),
                    _detailRow(Icons.description, 'Description', getHabitDetail.desc),
                    const Divider(),
                    _detailRow(Icons.calendar_today, 'Date', getHabitDetail.date),
                    const Divider(),
                    _detailRow(Icons.access_time, 'Time', getHabitDetail.time),
                    const Divider(),
                    _detailRow(Icons.list, 'Status Now', getHabitDetail.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Update Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              items: const [
                DropdownMenuItem(value: 'Upcoming', child: Text('Upcoming')),
                DropdownMenuItem(value: 'Ongoing', child: Text('Ongoing')),
                DropdownMenuItem(value: 'Completed', child: Text('Completed')),
              ],
              onChanged: (value) => setState(() => _selectedStatus = value),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(habitNotifierProvider.notifier).updateHabit(
                    args['uid']!,
                    args['habitId']!,
                    HabitModel(
                      id: getHabitDetail.id,
                      title: getHabitDetail.title,
                      desc: getHabitDetail.desc,
                      time: getHabitDetail.time,
                      date: getHabitDetail.date,
                      status: _selectedStatus!,
                      uid: getHabitDetail.uid,
                    ),
                  );

                  CustomDialog.showNotifications(
                    title: 'Success',
                    message: 'Habit updated successfully!',
                    confirmText: 'OK',
                  ).then((_){
                    if (!context.mounted) return;
                    Navigator.pop(context);
                  });
                },
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}