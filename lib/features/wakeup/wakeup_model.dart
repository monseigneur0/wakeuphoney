import 'dart:convert';

class WakeUpModel {
  final String wakeUpUid;
  final DateTime createdTime;
  final DateTime modifiedTimes;
  //alarm
  final int alarmId;
  final DateTime wakeTime;
  final String assetAudioPath;
  final bool loopAudio;
  final bool vibrate;
  final double volume;
  final double fadeDuration;
  final String notificationTitle;
  final String notificationBody;
  final bool enableNotificationOnKill;
  final bool androidFullScreenIntent;
  final bool isDeleted;
  final bool isApproved;
  final DateTime? approveTime;
  //letter send
  final String senderUid;
  final String letter;
  final String letterPhoto;
  final String letterAudio;
  final String letterVideo;
  //letter answer
  final String reciverUid;
  final DateTime? answerTime;
  final String answer;
  final String answerPhoto;
  final String answerAudio;
  final String answerVideo;
  WakeUpModel({
    required this.wakeUpUid,
    required this.createdTime,
    required this.modifiedTimes,
    required this.alarmId,
    required this.wakeTime,
    required this.assetAudioPath,
    required this.loopAudio,
    required this.vibrate,
    required this.volume,
    required this.fadeDuration,
    required this.notificationTitle,
    required this.notificationBody,
    required this.enableNotificationOnKill,
    required this.androidFullScreenIntent,
    required this.isDeleted,
    required this.isApproved,
    this.approveTime,
    required this.senderUid,
    required this.letter,
    required this.letterPhoto,
    required this.letterAudio,
    required this.letterVideo,
    required this.reciverUid,
    this.answerTime,
    required this.answer,
    required this.answerPhoto,
    required this.answerAudio,
    required this.answerVideo,
  });

  WakeUpModel copyWith({
    String? wakeUpUid,
    DateTime? createdTime,
    DateTime? modifiedTimes,
    int? alarmId,
    DateTime? wakeTime,
    String? assetAudioPath,
    bool? loopAudio,
    bool? vibrate,
    double? volume,
    double? fadeDuration,
    String? notificationTitle,
    String? notificationBody,
    bool? enableNotificationOnKill,
    bool? androidFullScreenIntent,
    bool? isDeleted,
    bool? isApproved,
    DateTime? approveTime,
    String? senderUid,
    String? letter,
    String? letterPhoto,
    String? letterAudio,
    String? letterVideo,
    String? reciverUid,
    DateTime? answerTime,
    String? answer,
    String? answerPhoto,
    String? answerAudio,
    String? answerVideo,
  }) {
    return WakeUpModel(
      wakeUpUid: wakeUpUid ?? this.wakeUpUid,
      createdTime: createdTime ?? this.createdTime,
      modifiedTimes: modifiedTimes ?? this.modifiedTimes,
      alarmId: alarmId ?? this.alarmId,
      wakeTime: wakeTime ?? this.wakeTime,
      assetAudioPath: assetAudioPath ?? this.assetAudioPath,
      loopAudio: loopAudio ?? this.loopAudio,
      vibrate: vibrate ?? this.vibrate,
      volume: volume ?? this.volume,
      fadeDuration: fadeDuration ?? this.fadeDuration,
      notificationTitle: notificationTitle ?? this.notificationTitle,
      notificationBody: notificationBody ?? this.notificationBody,
      enableNotificationOnKill:
          enableNotificationOnKill ?? this.enableNotificationOnKill,
      androidFullScreenIntent:
          androidFullScreenIntent ?? this.androidFullScreenIntent,
      isDeleted: isDeleted ?? this.isDeleted,
      isApproved: isApproved ?? this.isApproved,
      approveTime: approveTime ?? this.approveTime,
      senderUid: senderUid ?? this.senderUid,
      letter: letter ?? this.letter,
      letterPhoto: letterPhoto ?? this.letterPhoto,
      letterAudio: letterAudio ?? this.letterAudio,
      letterVideo: letterVideo ?? this.letterVideo,
      reciverUid: reciverUid ?? this.reciverUid,
      answerTime: answerTime ?? this.answerTime,
      answer: answer ?? this.answer,
      answerPhoto: answerPhoto ?? this.answerPhoto,
      answerAudio: answerAudio ?? this.answerAudio,
      answerVideo: answerVideo ?? this.answerVideo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wakeUpUid': wakeUpUid,
      'createdTime': createdTime,
      'modifiedTimes': modifiedTimes,
      'alarmId': alarmId,
      'wakeTime': wakeTime,
      'assetAudioPath': assetAudioPath,
      'loopAudio': loopAudio,
      'vibrate': vibrate,
      'volume': volume,
      'fadeDuration': fadeDuration,
      'notificationTitle': notificationTitle,
      'notificationBody': notificationBody,
      'enableNotificationOnKill': enableNotificationOnKill,
      'androidFullScreenIntent': androidFullScreenIntent,
      'isDeleted': isDeleted,
      'isApproved': isApproved,
      'approveTime': approveTime,
      'senderUid': senderUid,
      'letter': letter,
      'letterPhoto': letterPhoto,
      'letterAudio': letterAudio,
      'letterVideo': letterVideo,
      'reciverUid': reciverUid,
      'answerTime': answerTime,
      'answer': answer,
      'answerPhoto': answerPhoto,
      'answerAudio': answerAudio,
      'answerVideo': answerVideo,
    };
  }

  factory WakeUpModel.fromMap(Map<String, dynamic> map) {
    return WakeUpModel(
      wakeUpUid: map['wakeUpUid'] as String,
      createdTime: map['createdTime'].toDate(),
      modifiedTimes: map['modifiedTimes'].toDate(),
      alarmId: map['alarmId'] as int,
      wakeTime: map['wakeTime'].toDate(),
      assetAudioPath: map['assetAudioPath'] as String,
      loopAudio: map['loopAudio'] as bool,
      vibrate: map['vibrate'] as bool,
      volume: map['volume'] as double,
      fadeDuration: map['fadeDuration'] as double,
      notificationTitle: map['notificationTitle'] as String,
      notificationBody: map['notificationBody'] as String,
      enableNotificationOnKill: map['enableNotificationOnKill'] as bool,
      androidFullScreenIntent: map['androidFullScreenIntent'] as bool,
      isDeleted: map['isDeleted'] as bool,
      isApproved: map['isApproved'] as bool,
      approveTime: map['approveTime']?.toDate(),
      senderUid: map['senderUid'] as String,
      letter: map['letter'] as String,
      letterPhoto: map['letterPhoto'] as String,
      letterAudio: map['letterAudio'] as String,
      letterVideo: map['letterVideo'] as String,
      reciverUid: map['reciverUid'] as String,
      answerTime: map['answerTime']?.toDate(),
      answer: map['answer'] as String,
      answerPhoto: map['answerPhoto'] as String,
      answerAudio: map['answerAudio'] as String,
      answerVideo: map['answerVideo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WakeUpModel.fromJson(String source) =>
      WakeUpModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WakeUpModel(wakeUpUid: $wakeUpUid, createdTime: $createdTime, modifiedTimes: $modifiedTimes, alarmId: $alarmId, wakeTime: $wakeTime, assetAudioPath: $assetAudioPath, loopAudio: $loopAudio, vibrate: $vibrate, volume: $volume, fadeDuration: $fadeDuration, notificationTitle: $notificationTitle, notificationBody: $notificationBody, enableNotificationOnKill: $enableNotificationOnKill, androidFullScreenIntent: $androidFullScreenIntent, isDeleted: $isDeleted, isApproved: $isApproved, approveTime: $approveTime, senderUid: $senderUid, letter: $letter, letterPhoto: $letterPhoto, letterAudio: $letterAudio, letterVideo: $letterVideo, reciverUid: $reciverUid, answerTime: $answerTime, answer: $answer, answerPhoto: $answerPhoto, answerAudio: $answerAudio, answerVideo: $answerVideo)';
  }

  @override
  bool operator ==(covariant WakeUpModel other) {
    if (identical(this, other)) return true;

    return other.wakeUpUid == wakeUpUid &&
        other.createdTime == createdTime &&
        other.modifiedTimes == modifiedTimes &&
        other.alarmId == alarmId &&
        other.wakeTime == wakeTime &&
        other.assetAudioPath == assetAudioPath &&
        other.loopAudio == loopAudio &&
        other.vibrate == vibrate &&
        other.volume == volume &&
        other.fadeDuration == fadeDuration &&
        other.notificationTitle == notificationTitle &&
        other.notificationBody == notificationBody &&
        other.enableNotificationOnKill == enableNotificationOnKill &&
        other.androidFullScreenIntent == androidFullScreenIntent &&
        other.isDeleted == isDeleted &&
        other.isApproved == isApproved &&
        other.approveTime == approveTime &&
        other.senderUid == senderUid &&
        other.letter == letter &&
        other.letterPhoto == letterPhoto &&
        other.letterAudio == letterAudio &&
        other.letterVideo == letterVideo &&
        other.reciverUid == reciverUid &&
        other.answerTime == answerTime &&
        other.answer == answer &&
        other.answerPhoto == answerPhoto &&
        other.answerAudio == answerAudio &&
        other.answerVideo == answerVideo;
  }

  @override
  int get hashCode {
    return wakeUpUid.hashCode ^
        createdTime.hashCode ^
        modifiedTimes.hashCode ^
        alarmId.hashCode ^
        wakeTime.hashCode ^
        assetAudioPath.hashCode ^
        loopAudio.hashCode ^
        vibrate.hashCode ^
        volume.hashCode ^
        fadeDuration.hashCode ^
        notificationTitle.hashCode ^
        notificationBody.hashCode ^
        enableNotificationOnKill.hashCode ^
        androidFullScreenIntent.hashCode ^
        isDeleted.hashCode ^
        isApproved.hashCode ^
        approveTime.hashCode ^
        senderUid.hashCode ^
        letter.hashCode ^
        letterPhoto.hashCode ^
        letterAudio.hashCode ^
        letterVideo.hashCode ^
        reciverUid.hashCode ^
        answerTime.hashCode ^
        answer.hashCode ^
        answerPhoto.hashCode ^
        answerAudio.hashCode ^
        answerVideo.hashCode;
  }

  static Future<WakeUpModel> emptyFuture() async {
    return WakeUpModel(
      wakeUpUid: "",
      createdTime: DateTime.now(),
      modifiedTimes: DateTime.now(),
      alarmId: 10,
      wakeTime: DateTime.now(),
      assetAudioPath: "assets/marimba.mp3",
      loopAudio: false,
      vibrate: false,
      volume: 0.8,
      fadeDuration: 0.1,
      notificationTitle: "Alarm",
      notificationBody: "Alarm rings",
      enableNotificationOnKill: true,
      androidFullScreenIntent: true,
      isDeleted: false,
      isApproved: false,
      senderUid: "",
      letter: "",
      letterPhoto: "",
      letterAudio: "",
      letterVideo: "",
      reciverUid: "",
      answer: "",
      answerPhoto: "",
      answerAudio: "",
      answerVideo: "",
    );
  }
}
