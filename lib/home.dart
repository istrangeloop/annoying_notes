import 'dart:convert';

import 'package:annoying_notes/models/entry.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'package:annoying_notes/appstate.dart';
import 'package:annoying_notes/datetime_selector.dart';
import 'package:annoying_notes/reminder_dialog.dart';

class HomePage extends StatefulWidget {
  final Entry entry;
  final bool? isEditing;

  const HomePage({super.key, required this.entry, this.isEditing});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuillController _noteBodyController = QuillController.basic();
  final TextEditingController _tagsController = TextEditingController();

  Entry editingEntry = Entry.empty();
  final List<String> _newTags = [];

  @override
  void initState() {
    super.initState();

    _noteBodyController.document = Document.fromJson(
      jsonDecode(widget.entry.text),
    );
    editingEntry = widget.entry;
  }

  @override
  void dispose() {
    _noteBodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void resetState() {
    _tagsController.text = "";
    _noteBodyController.document = Document.fromJson(
      jsonDecode(widget.entry.text),
    );
    editingEntry = widget.entry;
  }

  void saveState() {
    widget.entry.text = jsonEncode(
      _noteBodyController.document.toDelta().toJson(),
    );
  }

  void _addTag(String tag) {
    setState(() {
      editingEntry.tags.add(tag.trim());
    });
  }

  void _addNewTag(String tag) {
    setState(() {
      _newTags.add(tag.trim());
      _tagsController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      editingEntry.tags.remove(tag);
    });
  }

  void _removeNewTag(String tag) {
    setState(() {
      _newTags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    String formattedDate = DateFormat('EEE d MMM').format(editingEntry.date);
    String formattedTime = DateFormat('kk:mm').format(editingEntry.date);

    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (widget.isEditing != null && widget.isEditing == true) ...[
              BackButton(),
            ],
            QuillSimpleToolbar(
              controller: _noteBodyController,
              config: const QuillSimpleToolbarConfig(),
            ),
            Expanded(
              child: GridPaper(
                // Customize grid properties
                color: Colors.grey, // Color of the grid lines
                divisions:
                    1, // Number of major divisions within each primary grid cell
                interval: 94, // Spacing between primary grid lines
                child: QuillEditor.basic(
                  controller: _noteBodyController,
                  config: const QuillEditorConfig(),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Date:"),
                InkWell(
                  onTap: () {
                    // Handle tap event
                    datePicker(
                      context: context,
                      time: editingEntry.date,
                      save: (inputDate) =>
                          setState(() => editingEntry.date = inputDate),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today),
                          SizedBox(
                            width: 4.0,
                          ), // Adds spacing between icon and text
                          Text(formattedDate),
                        ],
                      ),
                    ),
                  ),
                ),
                Text("Time:"),
                InkWell(
                  onTap: () {
                    // time needs to know the date to save and vice versa
                    timePicker(
                      context: context,
                      date: editingEntry.date,
                      save: (inputDate) =>
                          setState(() => editingEntry.date = inputDate),
                    );
                  },
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(Icons.timer),
                          SizedBox(
                            width: 4.0,
                          ), // Adds spacing between icon and text
                          Text(formattedTime),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // TODO: checkbox and spaced repetition
            if (editingEntry.date.isAfter(DateTime.now())) ...[
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      // Handle tap event
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          insetPadding: EdgeInsets.all(10),

                          child: ReminderDialog(
                            originalReminders: editingEntry.reminders,
                            save: (rlist) => {
                              print(rlist),
                              setState(() => editingEntry.reminders = rlist),
                            },
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.alarm_add),
                            SizedBox(
                              height: 4.0,
                            ), // Adds spacing between icon and text
                            Text('Set up reminder'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      // Handle tap event
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Title'),
                          content: Text('Here content'),
                        ),
                      );
                    },
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Icon(Icons.check_box),
                            SizedBox(
                              height: 4.0,
                            ), // Adds spacing between icon and text
                            Text('Set up Completion'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            Column(
              children: [
                SizedBox(
                  width: 300,
                  child: TextField(
                    controller: _tagsController,
                    decoration: InputDecoration(
                      labelText: 'Add a tag',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          if (_tagsController.text.isNotEmpty) {
                            _addTag(_tagsController.text);
                            _addNewTag(_tagsController.text);
                          }
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _addTag(value);
                      }
                    },
                  ),
                ),
                Wrap(
                  spacing: 8.0,
                  children:
                      appState.allTags.map((tag) {
                        return FilterChip(
                          label: Text('#${tag.text}'),
                          selected: editingEntry.tags.contains(tag.text),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _addTag(tag.text);
                              } else {
                                _removeTag(tag.text);
                              }
                            });
                          },
                        );
                      }).toList() +
                      _newTags.map((tag) {
                        return FilterChip(
                          label: Text('#$tag'),
                          selected: editingEntry.tags.contains(tag),
                          onSelected: (bool selected) {
                            setState(() {
                              if (!selected) {
                                _removeTag(tag);
                                _removeNewTag(tag);
                              }
                            });
                          },
                          onDeleted: () => {
                            _removeTag(tag),
                            _removeNewTag(tag),
                          },
                        );
                      }).toList(),
                ),
              ],
            ),
            Column(
              children: [
                for (var reminder in editingEntry.reminders) ...[
                  Text("a"),
                  if (reminder.alarm) ...[Text("Alarm")],
                  if (reminder.notify) ...[Text("Notify")],
                  if (reminder.email) ...[Text("Email")],
                ],
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      editingEntry.text = jsonEncode(
                        _noteBodyController.document.toDelta().toJson(),
                      );
                      appState.saveEntry(widget.entry.id, editingEntry);

                      saveState();
                    },
                    child: Text('Save'),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      resetState();
                    },
                    child: Text('Discard'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
