import 'package:annoying_notes/models/reminder.dart';
import 'package:flutter/material.dart';

class ReminderDialog extends StatefulWidget {
  const ReminderDialog({
    super.key,
    required this.originalReminders,
    required this.save,
  });
  final Function save;

  final List<Reminder> originalReminders;

  @override
  State<ReminderDialog> createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  List<Reminder> reminders = [];
  Reminder newReminder = Reminder.empty();

  @override
  void initState() {
    super.initState();
    // deep copy
    reminders = widget.originalReminders.map((obj) => obj).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      padding: const EdgeInsets.all(12.0),
      child: SizedBox(
        height: 500,
        child: ListView(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Chip(label: Text("5 minutes")),
                    Chip(label: Text("15 minutes")),
                  ],
                ),
                Column(
                  children: [
                    FilterChip(
                      label: Text("Notification"),
                      selected: newReminder.notify == true,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            newReminder.notify = true;
                          } else {
                            newReminder.notify = false;
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text("Alarm"),
                      selected: newReminder.alarm == true,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            newReminder.alarm = true;
                          } else {
                            newReminder.alarm = false;
                          }
                        });
                      },
                    ),
                    FilterChip(
                      label: Text("Email"),
                      selected: newReminder.email == true,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            newReminder.email = true;
                          } else {
                            newReminder.email = false;
                          }
                        });
                      },
                    ),
                  ],
                ),
                ElevatedButton(
                  child: Text("+"),
                  onPressed: () {
                    setState(() {
                      reminders.add(newReminder);
                      newReminder = Reminder.empty();
                    });
                  },
                ),
              ],
            ),
            if (reminders.isNotEmpty)
              for (var reminder in reminders)
                Row(
                  children: [
                    Column(
                      children: [
                        Chip(label: Text("5 minutes")),
                        Chip(label: Text("15 minutes")),
                      ],
                    ),
                    Column(
                      children: [
                        FilterChip(
                          label: Text("Notification"),
                          selected: reminder.notify == true,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                reminder.notify = true;
                              } else {
                                reminder.notify = false;
                              }
                            });
                          },
                        ),
                        FilterChip(
                          label: Text("Alarm"),
                          selected: reminder.alarm == true,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                reminder.alarm = true;
                              } else {
                                reminder.alarm = false;
                              }
                            });
                          },
                        ),
                        FilterChip(
                          label: Text("Email"),
                          selected: reminder.email == true,
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                reminder.email = true;
                              } else {
                                reminder.email = false;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
            ElevatedButton(
              onPressed: () => {widget.save(reminders), Navigator.pop(context)},
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
