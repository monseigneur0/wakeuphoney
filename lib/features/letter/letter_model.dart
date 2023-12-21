import 'dart:convert';

class LetterModel {
  final String id;
  final DateTime dateTimeNow;
  final String sender;
  final DateTime letterTime;
  final String letter;
  final String letterPhoto;
  final String letterAudio;
  final String letterVideo;

  final String reciver;
  final DateTime answerTime;
  final String answer;
  final String answerPhoto;
  final String answerAudio;
  final String answerVideo;

  LetterModel({
    required this.id,
    required this.dateTimeNow,
    required this.sender,
    required this.letterTime,
    required this.letter,
    required this.letterPhoto,
    required this.letterAudio,
    required this.letterVideo,
    required this.reciver,
    required this.answerTime,
    required this.answer,
    required this.answerPhoto,
    required this.answerAudio,
    required this.answerVideo,
  });

  LetterModel copyWith({
    String? id,
    DateTime? letterDateTime,
    String? sender,
    DateTime? letterTime,
    String? letter,
    String? letterPhoto,
    String? letterAudio,
    String? letterVideo,
    String? reciver,
    DateTime? answerTime,
    String? answer,
    String? answerPhoto,
    String? answerAudio,
    String? answerVideo,
  }) {
    return LetterModel(
      id: id ?? this.id,
      dateTimeNow: letterDateTime ?? dateTimeNow,
      sender: sender ?? this.sender,
      letterTime: letterTime ?? this.letterTime,
      letter: letter ?? this.letter,
      letterPhoto: letterPhoto ?? this.letterPhoto,
      letterAudio: letterAudio ?? this.letterAudio,
      letterVideo: letterVideo ?? this.letterVideo,
      reciver: reciver ?? this.reciver,
      answerTime: answerTime ?? this.answerTime,
      answer: answer ?? this.answer,
      answerPhoto: answerPhoto ?? this.answerPhoto,
      answerAudio: answerAudio ?? this.answerAudio,
      answerVideo: answerVideo ?? this.answerVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'letterDateTime': dateTimeNow,
      'sender': sender,
      'letterTime': letterTime,
      'letter': letter,
      'letterPhoto': letterPhoto,
      'letterAudio': letterAudio,
      'letterVideo': letterVideo,
      'reciver': reciver,
      'answerTime': answerTime,
      'answer': answer,
      'answerPhoto': answerPhoto,
      'answerAudio': answerAudio,
      'answerVideo': answerVideo,
    };
  }

  factory LetterModel.fromMap(Map<String, dynamic> map) {
    return LetterModel(
      id: map['id'] as String,
      dateTimeNow: DateTime.fromMillisecondsSinceEpoch(
          map['letterDateTime'].millisecondsSinceEpoch),
      sender: map['sender'] as String,
      letterTime: DateTime.fromMillisecondsSinceEpoch(
          map['letterTime'].millisecondsSinceEpoch),
      letter: map['letter'] as String,
      letterPhoto: map['letterPhoto'] as String,
      letterAudio: map['letterAudio'] as String,
      letterVideo: map['letterVideo'] as String,
      reciver: map['reciver'] as String,
      answerTime: DateTime.fromMillisecondsSinceEpoch(
          map['answerTime'].millisecondsSinceEpoch),
      answer: map['answer'] as String,
      answerPhoto: map['answerPhoto'] as String,
      answerAudio: map['answerAudio'] as String,
      answerVideo: map['answerVideo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LetterModel.fromJson(String source) =>
      LetterModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LetterModel(id: $id, letterDateTime: $dateTimeNow, sender: $sender, letterTime: $letterTime, letter: $letter, letterPhoto: $letterPhoto, letterAudio: $letterAudio, letterVideo: $letterVideo, reciver: $reciver, answerTime: $answerTime, answer: $answer, answerPhoto: $answerPhoto, answerAudio: $answerAudio, answerVideo: $answerVideo)';
  }

  @override
  bool operator ==(covariant LetterModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.dateTimeNow == dateTimeNow &&
        other.sender == sender &&
        other.letterTime == letterTime &&
        other.letter == letter &&
        other.letterPhoto == letterPhoto &&
        other.letterAudio == letterAudio &&
        other.letterVideo == letterVideo &&
        other.reciver == reciver &&
        other.answerTime == answerTime &&
        other.answer == answer &&
        other.answerPhoto == answerPhoto &&
        other.answerAudio == answerAudio &&
        other.answerVideo == answerVideo;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        dateTimeNow.hashCode ^
        sender.hashCode ^
        letterTime.hashCode ^
        letter.hashCode ^
        letterPhoto.hashCode ^
        letterAudio.hashCode ^
        letterVideo.hashCode ^
        reciver.hashCode ^
        answerTime.hashCode ^
        answer.hashCode ^
        answerPhoto.hashCode ^
        answerAudio.hashCode ^
        answerVideo.hashCode;
  }
}
