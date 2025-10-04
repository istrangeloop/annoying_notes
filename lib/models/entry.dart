import 'package:annoying_notes/models/reminder.dart';
import 'package:nanoid/nanoid.dart';
import 'dart:convert';

List<dynamic> blankData = [
  {'insert': '\n'},
];

enum NoteType { simple, checkbox, spaced }

class Entry {
  String id = nanoid();
  String text;
  DateTime date;
  DateTime? previousDate;
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
    this.reminders = const [],
    this.starred = false,
    this.type = NoteType.simple,
    this.previousDate,
    this.checked = false,
    this.step = 0,
  ]);

  Entry.load(
    this.id,
    this.text,
    this.date,
    this.tags,
    this.reminders,
    this.starred,
    this.type,
    this.previousDate,
    this.checked,
    this.step,
  );

  Entry.empty() : this(jsonEncode(blankData), DateTime.now(), []);

  //Entry.fromJson(json) : this();
  bool isFuture() {
    return date.isAfter(DateTime.now());
  }

  bool isStarred() {
    return starred;
  }

  factory Entry.fromJson(Map<String, dynamic> json) => Entry.load(
    json['id'] as String,
    json['text'] as String,
    json['date'] as DateTime,
    json['tags'] as List<String>,
    json['reminders'] as List<Reminder>,
    json['starred'] as bool,
    json['type'] as NoteType,
    json['previousDate'] as DateTime,
    json['checked'] as bool,
    json['step'] as int?,
  );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'date': date,
      'tags': tags,
      'reminders': reminders.map((r) => r.toJson()),
      'starred': starred,
      'checked': checked,
    };
  }
}
