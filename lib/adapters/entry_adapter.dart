import 'package:annoying_notes/models/entry.dart';
import 'package:annoying_notes/models/reminder.dart';
import 'package:hive_flutter/hive_flutter.dart';

class EntryAdapter extends TypeAdapter<Entry> {
  EntryAdapter(this.typeId);

  @override
  final int typeId;

  @override
  Entry read(BinaryReader reader) {
    final id = reader.read() as String;
    final text = reader.read() as String;
    final date = reader.read() as DateTime;
    final tags = reader.read() as List<String>;
    final reminders = reader.read() as List<Reminder>;
    final starred = reader.read() as bool;
    final type = reader.read() as NoteType;
    final previousDate = reader.read() as DateTime;
    final checked = reader.read() as bool;
    final step = reader.read() as int;

    return Entry.load(
      id,
      text,
      date,
      tags,
      reminders,
      starred,
      type,
      previousDate,
      checked,
      step,
    );
  }

  @override
  void write(BinaryWriter writer, Entry obj) {
    writer
      ..write(obj.id)
      ..write(obj.text)
      ..write(obj.date)
      ..write(obj.tags)
      ..write(obj.reminders)
      ..write(obj.starred)
      ..write(obj.type)
      ..write(obj.previousDate)
      ..write(obj.checked)
      ..write(obj.step);
  }
}
