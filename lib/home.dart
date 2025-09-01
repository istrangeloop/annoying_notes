import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:witchy_diary/appstate.dart';
import 'package:witchy_diary/datetime_selector.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, Entry? entry});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _noteBodyController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();

  DateTime selectedDate = DateTime(0);
  List<String> _tags = [];

  @override
  void dispose() {
    _noteBodyController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  void resetState() {
    _noteBodyController.text = "";
    _tagsController.text = "";
    setState(() {
      selectedDate = DateTime(0);
      _tags = [];
    });
  }

  void _addTag(String tag) {
    setState(() {
      _tags.add(tag.trim());
      _tagsController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    DateTime now = DateTime.now();

    String formattedDate = DateFormat('kk:mm:ss - EEE d MMM').format(now);
    String formattedSelectedDate = DateFormat(
      'kk:mm:ss - EEE d MMM',
    ).format(selectedDate);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: _noteBodyController,
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              alignLabelWithHint: true,
              labelText: "write a note",
              border: OutlineInputBorder(),
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
          if (selectedDate.isAfter(DateTime.now())) ...[
            Row(
              children: [
                Text("Set reminder?"),
                Text("30 minutes before"),
                Text("Notification"),
                Text("Alarm"),
              ],
            ),
          ],
          Column(
            children: [
              TextField(
                controller: _tagsController,
                decoration: InputDecoration(
                  labelText: 'Add a tag',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_tagsController.text.isNotEmpty) {
                        _addTag(_tagsController.text);
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
              Wrap(
                spacing: 8.0,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    onDeleted: () => _removeTag(tag),
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
                      _noteBodyController.text,
                      selectedDate,
                      _tags,
                    );
                  } else {
                    appState.saveEntry(_noteBodyController.text, now, _tags);
                    appState.saveTags(_tags);
                  }
                  resetState();
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
    );
  }
}
