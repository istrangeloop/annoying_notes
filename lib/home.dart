import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:witchy_diary/appstate.dart';
import 'package:witchy_diary/datetime_selector.dart';

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

  //TODO: note editing if entry is provided
  DateTime selectedDate = DateTime(0);
  List<String> _tags = [];
  List<String> _newTags = [];

  @override
  void initState() {
    super.initState();
    _noteBodyController.document = Document.fromJson(
      jsonDecode(widget.entry.text),
    );
    selectedDate = widget.entry.date;
    _tags = widget.entry.tags;
  }

  @override
  void dispose() {
    _noteBodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void resetState() {
    _tagsController.text = "";
    setState(() {
      _noteBodyController.document = Document.fromJson(
        jsonDecode(widget.entry.text),
      );
      selectedDate = widget.entry.date;
      _tags = widget.entry.tags;
    });
  }

  void saveState() {
    widget.entry.text = jsonEncode(
      _noteBodyController.document.toDelta().toJson(),
    );
    widget.entry.date = selectedDate;
    widget.entry.tags = _tags;
    _newTags = [];
  }

  void _addTag(String tag) {
    setState(() {
      _tags.add(tag.trim());
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
      _tags.remove(tag);
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

    DateTime now = DateTime.now();

    String formattedDate = DateFormat('kk:mm - EEE d MMM').format(now);
    String formattedSelectedDate = DateFormat(
      'kk:mm - EEE d MMM',
    ).format(selectedDate);

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
              child: QuillEditor.basic(
                controller: _noteBodyController,
                config: const QuillEditorConfig(),
              ),
            ),
            Text(
              "Date: ${selectedDate == DateTime(0) ? formattedDate : formattedSelectedDate}",
            ),
            ElevatedButton(
              onPressed: () {
                showDateTimePicker(
                  context: context,
                  save: (inputDate) => setState(() => selectedDate = inputDate),
                );
              },
              child: Text('Select another?'),
            ),
            // TODO: reminders and alarm logic
            // checkbox and spaced repetition
            if (selectedDate.isAfter(DateTime.now())) ...[
              Column(
                children: [
                  Text("This date is in the future. Set reminder?"),
                  Text("5 minutes before"),
                  Text("30 minutes before"),
                  Text("custom"),
                  Text("Notification"),
                  Text("Alarm"),
                  Text("+ add another"),
                ],
              ),
            ],
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
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
                          selected: _tags.contains(tag.text),
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
                          selected: _tags.contains(tag),
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
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    if (selectedDate != DateTime(0)) {
                      appState.saveEntry(
                        widget.entry.id,
                        jsonEncode(
                          _noteBodyController.document.toDelta().toJson(),
                        ),
                        selectedDate,
                        _tags,
                      );
                    } else {
                      appState.saveEntry(
                        widget.entry.id,
                        jsonEncode(
                          _noteBodyController.document.toDelta().toJson(),
                        ),
                        now,
                        _tags,
                      );
                    }
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
          ],
        ),
      ),
    );
  }
}
