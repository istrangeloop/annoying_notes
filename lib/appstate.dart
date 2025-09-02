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

List<Entry> testEntries = [
  Entry("pusheen", DateTime.parse("2025-02-27 13:27:00"), ["kitty", "big"]),
  Entry("stormy", DateTime.parse("2025-02-27 13:27:00"), ["kitty", "medium"]),
  Entry("pip", DateTime.parse("2025-02-27 13:27:00"), ["kitty", "small"]),
  Entry("rafael", DateTime.parse("2026-06-23 01:27:00"), ["human", "big"]),
  Entry("ingrid", DateTime.parse("2025-11-20 10:27:00"), ["human", "medium"]),
];

List<Tag> testTags = [
  Tag("kitty", 3),
  Tag("human", 2),
  Tag("big", 2),
  Tag("medium", 2),
  Tag("small", 1),
];

class MyAppState extends ChangeNotifier {
  // this will come from  database soon
  List<Entry> entries = testEntries;
  List<Tag> allTags = testTags;

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

  void saveEntry(text, date, tags) {
    entries.add(Entry(text, date, tags));
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
