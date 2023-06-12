import 'dart:convert';

class MessageModel {
  final String message;
  final String senderid;
  final DateTime date;
  final String image;
  final String voice;
  final String video;

  MessageModel({
    required this.message,
    required this.senderid,
    required this.date,
    required this.image,
    required this.voice,
    required this.video,
  });

  MessageModel copyWith({
    String? message,
    String? senderid,
    DateTime? date,
    String? image,
    String? voice,
    String? video,
  }) {
    return MessageModel(
      message: message ?? this.message,
      senderid: senderid ?? this.senderid,
      date: date ?? this.date,
      image: image ?? this.image,
      voice: voice ?? this.voice,
      video: video ?? this.video,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'senderid': senderid,
      'date': date.millisecondsSinceEpoch,
      'image': image,
      'voice': voice,
      'video': video,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      message: map['message'] as String,
      senderid: map['senderid'] as String,
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      image: map['image'] as String,
      voice: map['voice'] as String,
      video: map['video'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageModel.fromJson(String source) =>
      MessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MessageModel(message: $message, senderid: $senderid, date: $date, image: $image, voice: $voice, video: $video)';
  }

  @override
  bool operator ==(covariant MessageModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.senderid == senderid &&
        other.date == date &&
        other.image == image &&
        other.voice == voice &&
        other.video == video;
  }

  @override
  int get hashCode {
    return message.hashCode ^
        senderid.hashCode ^
        date.hashCode ^
        image.hashCode ^
        voice.hashCode ^
        video.hashCode;
  }
}
