import 'dart:convert';

class WakeModel {
  final String wakeUid;
  final DateTime createdTime;
  final DateTime modifiedTimes;

  //alarm
  final int alarmId;
  final DateTime alarmTime;
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
  final String wakeMessage;
  final String wakePhoto;
  final String wakeAudio;
  final String wakeVideo;

  //letter answer
  final bool isAnswered;
  final String reciverUid;
  final DateTime? answerTime;
  final String answerMessage;
  final String answerPhoto;
  final String answerAudio;
  final String answerVideo;

  WakeModel({
    required this.wakeUid,
    required this.createdTime,
    required this.modifiedTimes,
    required this.alarmId,
    required this.alarmTime,
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
    required this.wakeMessage,
    required this.wakePhoto,
    required this.wakeAudio,
    required this.wakeVideo,
    required this.reciverUid,
    this.answerTime,
    required this.answerMessage,
    required this.answerPhoto,
    required this.answerAudio,
    required this.answerVideo,
    required this.isAnswered,
  });

  WakeModel copyWith({
    String? wakeUid,
    DateTime? createdTime,
    DateTime? modifiedTimes,
    int? alarmId,
    DateTime? alarmTime,
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
    String? wakeMessage,
    String? wakePhoto,
    String? wakeAudio,
    String? wakeVideo,
    String? reciverUid,
    DateTime? answerTime,
    String? answerMessage,
    String? answerPhoto,
    String? answerAudio,
    String? answerVideo,
    bool? isAnswered,
  }) {
    return WakeModel(
      wakeUid: wakeUid ?? this.wakeUid,
      createdTime: createdTime ?? this.createdTime,
      modifiedTimes: modifiedTimes ?? this.modifiedTimes,
      alarmId: alarmId ?? this.alarmId,
      alarmTime: alarmTime ?? this.alarmTime,
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
      wakeMessage: wakeMessage ?? this.wakeMessage,
      wakePhoto: wakePhoto ?? this.wakePhoto,
      wakeAudio: wakeAudio ?? this.wakeAudio,
      wakeVideo: wakeVideo ?? this.wakeVideo,
      reciverUid: reciverUid ?? this.reciverUid,
      answerTime: answerTime ?? this.answerTime,
      answerMessage: answerMessage ?? this.answerMessage,
      answerPhoto: answerPhoto ?? this.answerPhoto,
      answerAudio: answerAudio ?? this.answerAudio,
      answerVideo: answerVideo ?? this.answerVideo,
      isAnswered: isAnswered ?? this.isAnswered,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wakeUid': wakeUid,
      'createdTime': createdTime,
      'modifiedTimes': modifiedTimes,
      'alarmId': alarmId,
      'alarmTime': alarmTime,
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
      'wakeMessage': wakeMessage,
      'wakePhoto': wakePhoto,
      'wakeAudio': wakeAudio,
      'wakeVideo': wakeVideo,
      'reciverUid': reciverUid,
      'answerTime': answerTime,
      'answerMessage': answerMessage,
      'answerPhoto': answerPhoto,
      'answerAudio': answerAudio,
      'answerVideo': answerVideo,
      'isAnswered': isAnswered,
    };
  }

  factory WakeModel.fromMap(Map<String, dynamic> map) {
    return WakeModel(
      wakeUid: map['wakeUid'] as String,
      createdTime: (map['createdTime'].toDate()),
      modifiedTimes: (map['modifiedTimes'].toDate()),
      alarmId: map['alarmId'] as int,
      alarmTime: (map['alarmTime'].toDate()),
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
      approveTime:
          map['approveTime'] != null ? (map['approveTime'].toDate()) : null,
      senderUid: map['senderUid'] as String,
      wakeMessage: map['wakeMessage'] as String,
      wakePhoto: map['wakePhoto'] as String,
      wakeAudio: map['wakeAudio'] as String,
      wakeVideo: map['wakeVideo'] as String,
      reciverUid: map['reciverUid'] as String,
      answerTime:
          map['answerTime'] != null ? (map['answerTime'].toDate()) : null,
      answerMessage: map['answerMessage'] as String,
      answerPhoto: map['answerPhoto'] as String,
      answerAudio: map['answerAudio'] as String,
      answerVideo: map['answerVideo'] as String,
      isAnswered: map['isAnswered'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory WakeModel.fromJson(String source) =>
      WakeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WakeModel(wakeUid: $wakeUid, createdTime: $createdTime, modifiedTimes: $modifiedTimes, alarmId: $alarmId, alarmTime: $alarmTime, assetAudioPath: $assetAudioPath, loopAudio: $loopAudio, vibrate: $vibrate, volume: $volume, fadeDuration: $fadeDuration, notificationTitle: $notificationTitle, notificationBody: $notificationBody, enableNotificationOnKill: $enableNotificationOnKill, androidFullScreenIntent: $androidFullScreenIntent, isDeleted: $isDeleted, isApproved: $isApproved, approveTime: $approveTime, senderUid: $senderUid, wakeMessage: $wakeMessage, wakePhoto: $wakePhoto, wakeAudio: $wakeAudio, wakeVideo: $wakeVideo, reciverUid: $reciverUid, answerTime: $answerTime, answerMessage: $answerMessage, answerPhoto: $answerPhoto, answerAudio: $answerAudio, answerVideo: $answerVideo, isAnswered: $isAnswered)';
  }

  @override
  bool operator ==(covariant WakeModel other) {
    if (identical(this, other)) return true;

    return other.wakeUid == wakeUid &&
        other.createdTime == createdTime &&
        other.modifiedTimes == modifiedTimes &&
        other.alarmId == alarmId &&
        other.alarmTime == alarmTime &&
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
        other.wakeMessage == wakeMessage &&
        other.wakePhoto == wakePhoto &&
        other.wakeAudio == wakeAudio &&
        other.wakeVideo == wakeVideo &&
        other.reciverUid == reciverUid &&
        other.answerTime == answerTime &&
        other.answerMessage == answerMessage &&
        other.answerPhoto == answerPhoto &&
        other.answerAudio == answerAudio &&
        other.answerVideo == answerVideo &&
        other.isAnswered == isAnswered;
  }

  @override
  int get hashCode {
    return wakeUid.hashCode ^
        createdTime.hashCode ^
        modifiedTimes.hashCode ^
        alarmId.hashCode ^
        alarmTime.hashCode ^
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
        wakeMessage.hashCode ^
        wakePhoto.hashCode ^
        wakeAudio.hashCode ^
        wakeVideo.hashCode ^
        reciverUid.hashCode ^
        answerTime.hashCode ^
        answerMessage.hashCode ^
        answerPhoto.hashCode ^
        answerAudio.hashCode ^
        answerVideo.hashCode ^
        isAnswered.hashCode;
  }

  static Future<WakeModel> emptyFuture() async {
    return WakeModel(
      wakeUid: "",
      createdTime: DateTime.now(),
      modifiedTimes: DateTime.now(),
      alarmId: 10,
      alarmTime: DateTime.now(),
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
      approveTime: null,
      senderUid: "",
      wakeMessage: "",
      wakePhoto: "",
      wakeAudio: "",
      wakeVideo: "",
      isAnswered: false,
      reciverUid: "",
      answerTime: null,
      answerMessage: "",
      answerPhoto: "",
      answerAudio: "",
      answerVideo: "",
    );
  }
}
