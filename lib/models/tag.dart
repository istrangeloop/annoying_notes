class Tag {
  String text;
  int postCount;

  Tag(this.text, this.postCount);

  factory Tag.fromJson(Map<String, dynamic> json) =>
      Tag(json['text'] as String, json['postCount'] as int);

  Map<String, dynamic> toJson() {
    return {'text': text, 'postCount': postCount};
  }
}
