import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

class Reminder {
  DateTime setTime;
  bool notify;
  bool alarm;

  Reminder(this.setTime, this.notify, this.alarm);
}

class Entry {
  String id = nanoid();
  String text;
  DateTime date;
  List<String> tags;
  bool starred;
  List<Reminder> reminders;

  Entry(
    this.text,
    this.date,
    this.tags, [
    this.starred = false,
    this.reminders = const [],
  ]);

  bool isFuture() {
    return date.isAfter(DateTime.now());
  }

  bool isStarred() {
    return starred;
  }
}

class MyAppState extends ChangeNotifier {
  List<Entry> entries = [];
  List<String> tags = [];

  // if tag is not already present, of course
  // make this check
  void saveTags(tags) {
    tags.addAll(tags);
    notifyListeners();
  }

  // if every post with a tag gets deleted,
  // the tag should be automatically deleted too
  // implement this in state somehow
  // maybe after setting up database
  void deleteTags(tags) {
    for (var tag in tags) {
      tags.remove(tag);
    }
    notifyListeners();
  }

  void saveEntry(text, date, tags) {
    entries.add(Entry(text, date, tags));
    notifyListeners();
  }

  void deleteEntry(entry) {
    entries.remove(entry);
    notifyListeners();
  }

  void toggleStar(entry) {
    entry.starred = !entry.starred;

    int indexToUpdate = entries.indexWhere((item) => item.id == entry.id);

    if (indexToUpdate != -1) {
      entries[indexToUpdate] = entry; // Replace the object
    }

    notifyListeners();
  }
}
