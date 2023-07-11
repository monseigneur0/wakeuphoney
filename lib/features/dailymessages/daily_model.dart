class DailyMessageModel {
  final String message;
  final String messagedate;
  final DateTime messagedatetime;
  final DateTime time;
  final String sender;
  final String reciver;
  final String photo;
  final String audio;
  final String video;

  DailyMessageModel({
    required this.message,
    required this.messagedate,
    required this.messagedatetime,
    required this.time,
    required this.sender,
    required this.reciver,
    required this.photo,
    required this.audio,
    required this.video,
  });

  DailyMessageModel copyWith({
    String? message,
    String? messagedate,
    DateTime? messagedatetime,
    DateTime? time,
    String? sender,
    String? reciver,
    String? photo,
    String? audio,
    String? video,
  }) {
    return DailyMessageModel(
      message: message ?? this.message,
      messagedate: messagedate ?? this.messagedate,
      messagedatetime: messagedatetime ?? this.messagedatetime,
      time: time ?? this.time,
      sender: sender ?? this.sender,
      reciver: reciver ?? this.reciver,
      photo: photo ?? this.photo,
      audio: audio ?? this.audio,
      video: video ?? this.video,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'messagedate': messagedate,
      'messagedatetime': messagedatetime,
      'time': time,
      'sender': sender,
      'reciver': reciver,
      'photo': photo,
      'audio': audio,
      'video': video,
    };
  }

  factory DailyMessageModel.fromMap(Map<String, dynamic> map) {
    return DailyMessageModel(
      message: map['message'] as String,
      messagedate: map['messagedate'] as String,
      messagedatetime: DateTime.fromMillisecondsSinceEpoch(
          map['messagedatetime'].millisecondsSinceEpoch),
      time: DateTime.fromMillisecondsSinceEpoch(
          map['time'].millisecondsSinceEpoch),
      sender: map['sender'] as String,
      reciver: map['reciver'] as String,
      photo: map['photo'] as String,
      audio: map['audio'] as String,
      video: map['video'] as String,
    );
  }

  @override
  String toString() {
    return 'DailyMessageModel(message: $message, messagedate: $messagedate, messagedatetime: $messagedatetime, time: $time, sender: $sender, reciver: $reciver, photo: $photo, audio: $audio, video: $video)';
  }

  @override
  bool operator ==(covariant DailyMessageModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.messagedate == messagedate &&
        other.messagedatetime == messagedatetime &&
        other.time == time &&
        other.sender == sender &&
        other.reciver == reciver &&
        other.photo == photo &&
        other.audio == audio &&
        other.video == video;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        messagedate.hashCode ^
        messagedatetime.hashCode ^
        time.hashCode ^
        sender.hashCode ^
        reciver.hashCode ^
        photo.hashCode ^
        audio.hashCode ^
        video.hashCode;
  }
}
