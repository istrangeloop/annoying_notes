import 'package:annoying_notes/models/tag.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TagAdapter extends TypeAdapter<Tag> {
  TagAdapter(this.typeId);

  @override
  final int typeId;

  @override
  Tag read(BinaryReader reader) {
    final text = reader.read() as String;
    final postCount = reader.read() as int;

    return Tag(text, postCount);
  }

  @override
  void write(BinaryWriter writer, Tag obj) {
    writer
      ..write(obj.text)
      ..write(obj.postCount);
  }
}
