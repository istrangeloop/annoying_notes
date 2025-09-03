import 'package:flutter/material.dart';
import 'package:nanoid/nanoid.dart';

class Tag {
  String text;
  int postCount;

  Tag(this.text, this.postCount);
}

class Reminder {
  DateTime ringTime;
  bool notify;
  bool alarm;

  Reminder(this.ringTime, this.notify, this.alarm);
}

enum NoteType { simple, checkbox, spaced }

class Entry {
  String id = nanoid();
  String text;
  DateTime date;
  DateTime? previous;
  List<String> tags;
  bool starred;
  List<Reminder> reminders;
  NoteType type;
  bool checked;
  int? step;

  Entry(
    this.text,
    this.date,
    this.tags, [
    this.starred = false,
    this.reminders = const [],
    this.type = NoteType.simple,
    this.previous,
    this.checked = false,
    this.step = 0,
  ]);

  bool isFuture() {
    return date.isAfter(DateTime.now());
  }

  bool isStarred() {
    return starred;
  }
}

class MyAppState extends ChangeNotifier {
  // this will come from  database soon
  List<Entry> entries = [];
  List<Tag> allTags = [];

  void saveTags(postTags) {
    for (var tag in postTags) {
      var tagEntry = allTags.where((t) => t.text == tag).toList();
      if (tagEntry.isNotEmpty) {
        var index = allTags.indexOf(tagEntry[0]);
        allTags[index].postCount = allTags[index].postCount + 1;
      } else {
        allTags.add(Tag(tag, 1));
      }
    }
    notifyListeners();
  }

  void deleteTags(postTags) {
    for (var tag in postTags) {
      var tagEntry = allTags.where((t) => t.text == tag).toList()[0];
      var index = allTags.indexOf(tagEntry);
      allTags[index].postCount = allTags[index].postCount - 1;
      if (allTags[index].postCount <= 0) {
        allTags.remove(tagEntry);
      }
    }
    notifyListeners();
  }

  void saveEntry(id, text, date, tags) {
    if (entries.where((e) => e.id == id).toList().isNotEmpty) {
      var editedEntry = entries.where((e) => e.id == id).toList()[0];
      editedEntry.text = text;
      editedEntry.date = date;
      editedEntry.tags = tags;
    } else {
      entries.add(Entry(text, date, tags));
    }
    saveTags(tags);
    notifyListeners();
  }

  void deleteEntry(entry) {
    entries.remove(entry);
    deleteTags(entry.tags);
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
