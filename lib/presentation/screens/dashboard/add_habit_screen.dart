import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';
import 'package:habitly_mission/presentation/state/habit_providers.dart';
import 'package:habitly_mission/style/app_color.dart';
import 'package:habitly_mission/widget/custom_field.dart';

class AddHabitScreen extends ConsumerStatefulWidget {

  const AddHabitScreen({super.key,});

  @override
  ConsumerState<AddHabitScreen> createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends ConsumerState<AddHabitScreen> {
  final titleHabit = TextEditingController();
  final descHabit = TextEditingController();
  String timeHabit = '06:00';
  String statusHabit = 'Upcoming';
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  @override
  void dispose() {
    titleHabit.dispose();
    descHabit.dispose();
    super.dispose();
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2028),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        // format to DD/MM/YYYY string
        formattedDate = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }


  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(currentUidProvider);
    final List<String> timeOptions = [
      '06:00',
      '09:00',
      '12:00',
      '15:00',
      '18:00',
      '21:00',
    ];
    final List<String> statusOptions = [
      'Upcoming',
      'Ongoing',
      'Completed',
    ];

    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(height: 20,),
              CustomField(
                label: 'Habit Name',
                backgroundColor: Colors.white,
                controller: titleHabit,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'cant be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              CustomField(
                label: 'Habit Description',
                backgroundColor: Colors.white,
                controller: descHabit,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'cant be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
                child: Card(
                  color: Color(0XFFECE6F0),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Text('When you do the habit ?'),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(
                          horizontal: 20,
                          vertical: 2,
                        ),
                        child: GestureDetector(
                          onTap: pickDate,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate, // ← shows DD/MM/YYYY
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.calendar_today),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('When we should remind you ?'),//time OPTIONS
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 20),
                        child: DropdownMenu<String>(
                          width: double.infinity,
                          initialSelection: timeOptions[0],
                          dropdownMenuEntries: timeOptions.map((value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                          onSelected: (value) {
                            if (value != null) {
                              timeHabit = value;
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('Status of habit?'),
                      Padding(// Status
                        padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 20),
                        child: DropdownMenu<String>(
                          width: double.infinity,
                          initialSelection: statusOptions[0],
                          dropdownMenuEntries: statusOptions.map((value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                          onSelected: (value) {
                            if (value != null) {
                              statusHabit = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsetsGeometry.directional(start: 30, end: 30),
                child: ElevatedButton(
                  //button register
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    if(uid == null) return;

                      // await ref.read(habitListProvider.notifier).addHabit(
                      //   titleHabit.text,
                      //   descHabit.text,
                      //   timeHabit,
                      // );

                    await ref.read(habitNotifierProvider.notifier).addHabit(title: titleHabit.text, desc: descHabit.text, time: timeHabit,date: formattedDate,status: statusHabit, uid: uid);

                    if(!context.mounted) return;

                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Success"),
                          content: const Text("Habit added successfully!"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("OK"),
                            ),
                          ],
                        ),
                      );

                    // Clear fields AFTER dialog is closed
                    titleHabit.clear();
                    descHabit.clear();

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2FB969),
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save habit",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
