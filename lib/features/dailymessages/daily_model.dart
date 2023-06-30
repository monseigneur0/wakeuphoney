class DailyMessageModel {
  final String message;
  final String messagedate;
  final DateTime messgaedatetime;
  final DateTime time;
  final String uid;
  DailyMessageModel({
    required this.message,
    required this.messagedate,
    required this.messgaedatetime,
    required this.time,
    required this.uid,
  });

  DailyMessageModel copyWith({
    String? message,
    String? messagedate,
    DateTime? messgaedatetime,
    DateTime? time,
    String? uid,
  }) {
    return DailyMessageModel(
      message: message ?? this.message,
      messagedate: messagedate ?? this.messagedate,
      messgaedatetime: messgaedatetime ?? this.messgaedatetime,
      time: time ?? this.time,
      uid: uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'messagedate': messagedate,
      'messgaedatetime': messgaedatetime.millisecondsSinceEpoch,
      'time': time.millisecondsSinceEpoch,
      'uid': uid,
    };
  }

  factory DailyMessageModel.fromMap(Map<String, dynamic> map) {
    return DailyMessageModel(
      message: map['message'] as String,
      messagedate: map['messagedate'] as String,
      messgaedatetime: DateTime.fromMillisecondsSinceEpoch(
          map['messgaedatetime'].millisecondsSinceEpoch),
      time: DateTime.fromMillisecondsSinceEpoch(
          map['time'].millisecondsSinceEpoch),
      uid: map['uid'] as String,
    );
  }

  @override
  String toString() {
    return 'DailyMessageModel(message: $message, messagedate: $messagedate, messgaedatetime: $messgaedatetime, time: $time, uid: $uid)';
  }

  @override
  bool operator ==(covariant DailyMessageModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.messagedate == messagedate &&
        other.messgaedatetime == messgaedatetime &&
        other.time == time &&
        other.uid == uid;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        messagedate.hashCode ^
        messgaedatetime.hashCode ^
        time.hashCode ^
        uid.hashCode;
  }
}
