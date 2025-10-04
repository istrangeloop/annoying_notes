import 'package:annoying_notes/adapters/entry_adapter.dart';
import 'package:annoying_notes/adapters/tag_adapter.dart';
import 'package:annoying_notes/models/entry.dart';
import 'package:annoying_notes/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MyAppState extends ChangeNotifier {
  // this will come from  database soon
  List<Entry> entries = [];
  List<Tag> allTags = [];
  late Box notesBox;
  late Box tagsBox;

  // TODO: Hive can encrypt data. Make a settings option for this in the interface
  void initData() {
    Hive.registerAdapter<Entry>(EntryAdapter(1));
    Hive.registerAdapter<Tag>(TagAdapter(2));
    Hive.openBox<Tag>(
      "tags",
    ).then((box) => {tagsBox = box, allTags = box.values.toList()});
    Hive.openBox<Entry>(
      "notes",
    ).then((box) => {notesBox = box, entries = box.values.toList()});
  }

  void saveTags(List<String> postTags) {
    for (var tag in postTags) {
      var tagEntry = allTags.where((t) => t.text == tag).toList();
      if (tagEntry.isNotEmpty) {
        var index = allTags.indexOf(tagEntry[0]);
        allTags[index].postCount = allTags[index].postCount + 1;
      } else {
        allTags.add(Tag(tag, 1));
        tagsBox.put(tag, Tag(tag, 1));
      }
    }
    notifyListeners();
  }

  void deleteTags(List<String> postTags) {
    for (var tag in postTags) {
      var tagEntry = allTags.where((t) => t.text == tag).toList()[0];
      var index = allTags.indexOf(tagEntry);
      allTags[index].postCount = allTags[index].postCount - 1;
      if (allTags[index].postCount <= 0) {
        allTags.remove(tagEntry);
        tagsBox.delete(tagEntry.text);
      }
    }
    notifyListeners();
  }

  void saveEntry(String id, Entry entry) {
    //print(entry.reminders);
    if (entries.where((e) => e.id == id).toList().isNotEmpty) {
      entries.where((e) => e.id == id).toList()[0] = entry;
    } else {
      entries.add(entry);
      notesBox.put(entry.id, entry);
    }
    saveTags(entry.tags);
    notifyListeners();
  }

  void deleteEntry(Entry entry) {
    entries.remove(entry);
    notesBox.delete(entry.id);
    deleteTags(entry.tags);
    notifyListeners();
  }

  void toggleStar(Entry entry) {
    entry.starred = !entry.starred;
    int indexToUpdate = entries.indexWhere((item) => item.id == entry.id);

    if (indexToUpdate != -1) {
      entries[indexToUpdate] = entry; // Replace the object
      notesBox.put(entry.id, entry);
    }
    notifyListeners();
  }
}
