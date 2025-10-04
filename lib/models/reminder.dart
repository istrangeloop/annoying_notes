class Reminder {
  DateTime ringTime;
  bool notify;
  bool alarm;
  bool email;

  Reminder(this.ringTime, this.notify, this.alarm, this.email);

  Reminder.empty() : this(DateTime(0), false, false, false);

  factory Reminder.fromJson(Map<String, dynamic> json) => Reminder(
    json['ringTime'] as DateTime,
    json['notify'] as bool,
    json['alarm'] as bool,
    json['email'] as bool,
  );

  Map<String, dynamic> toJson() {
    return {
      'ringTime': ringTime,
      'notify': notify,
      'alarm': alarm,
      'email': email,
    };
  }
}
