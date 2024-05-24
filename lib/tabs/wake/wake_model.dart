import 'dart:convert';

class WakeModel {
  final String wakeUid;
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
  final bool isRejected;
  final DateTime? approveTime;

  //message send
  final String senderUid;
  final String message;
  final String messagePhoto;
  final String messageAudio;
  final String messageVideo;

  //message answer
  final String reciverUid;
  final DateTime? answerTime;
  final String answer;
  final String answerPhoto;
  final String answerAudio;
  final String answerVideo;

  WakeModel({
    required this.wakeUid,
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
    required this.isRejected,
    this.approveTime,
    required this.senderUid,
    required this.message,
    required this.messagePhoto,
    required this.messageAudio,
    required this.messageVideo,
    required this.reciverUid,
    this.answerTime,
    required this.answer,
    required this.answerPhoto,
    required this.answerAudio,
    required this.answerVideo,
  });

  WakeModel copyWith({
    String? wakeUid,
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
    bool? isRejected,
    DateTime? approveTime,
    String? senderUid,
    String? message,
    String? messagePhoto,
    String? messageAudio,
    String? messageVideo,
    String? reciverUid,
    DateTime? answerTime,
    String? answer,
    String? answerPhoto,
    String? answerAudio,
    String? answerVideo,
  }) {
    return WakeModel(
      wakeUid: wakeUid ?? this.wakeUid,
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
      enableNotificationOnKill: enableNotificationOnKill ?? this.enableNotificationOnKill,
      androidFullScreenIntent: androidFullScreenIntent ?? this.androidFullScreenIntent,
      isDeleted: isDeleted ?? this.isDeleted,
      isApproved: isApproved ?? this.isApproved,
      isRejected: isRejected ?? this.isRejected,
      approveTime: approveTime ?? this.approveTime,
      senderUid: senderUid ?? this.senderUid,
      message: message ?? this.message,
      messagePhoto: messagePhoto ?? this.messagePhoto,
      messageAudio: messageAudio ?? this.messageAudio,
      messageVideo: messageVideo ?? this.messageVideo,
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
      'wakeUid': wakeUid,
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
      'isRejected': isRejected,
      'approveTime': approveTime,
      'senderUid': senderUid,
      'message': message,
      'messagePhoto': messagePhoto,
      'messageAudio': messageAudio,
      'messageVideo': messageVideo,
      'reciverUid': reciverUid,
      'answerTime': answerTime,
      'answer': answer,
      'answerPhoto': answerPhoto,
      'answerAudio': answerAudio,
      'answerVideo': answerVideo,
    };
  }

  factory WakeModel.fromMap(Map<String, dynamic> map) {
    return WakeModel(
      wakeUid: map['wakeUid'] as String,
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
      isRejected: map['isRejected'] as bool,
      approveTime: map['approveTime']?.toDate(),
      senderUid: map['senderUid'] as String,
      message: map['message'] as String,
      messagePhoto: map['messagePhoto'] as String,
      messageAudio: map['messageAudio'] as String,
      messageVideo: map['messageVideo'] as String,
      reciverUid: map['reciverUid'] as String,
      answerTime: map['answerTime']?.toDate(),
      answer: map['answer'] as String,
      answerPhoto: map['answerPhoto'] as String,
      answerAudio: map['answerAudio'] as String,
      answerVideo: map['answerVideo'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory WakeModel.fromJson(String source) => WakeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WakeModel(wakeUid: $wakeUid, createdTime: $createdTime, modifiedTimes: $modifiedTimes, alarmId: $alarmId, wakeTime: $wakeTime, assetAudioPath: $assetAudioPath, loopAudio: $loopAudio, vibrate: $vibrate, volume: $volume, fadeDuration: $fadeDuration, notificationTitle: $notificationTitle, notificationBody: $notificationBody, enableNotificationOnKill: $enableNotificationOnKill, androidFullScreenIntent: $androidFullScreenIntent, isDeleted: $isDeleted, isApproved: $isApproved, isRejected: $isRejected, approveTime: $approveTime, senderUid: $senderUid, message: $message, messagePhoto: $messagePhoto, messageAudio: $messageAudio, messageVideo: $messageVideo, reciverUid: $reciverUid, answerTime: $answerTime, answer: $answer, answerPhoto: $answerPhoto, answerAudio: $answerAudio, answerVideo: $answerVideo)';
  }

  @override
  bool operator ==(covariant WakeModel other) {
    if (identical(this, other)) return true;

    return other.wakeUid == wakeUid &&
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
        other.isRejected == isRejected &&
        other.approveTime == approveTime &&
        other.senderUid == senderUid &&
        other.message == message &&
        other.messagePhoto == messagePhoto &&
        other.messageAudio == messageAudio &&
        other.messageVideo == messageVideo &&
        other.reciverUid == reciverUid &&
        other.answerTime == answerTime &&
        other.answer == answer &&
        other.answerPhoto == answerPhoto &&
        other.answerAudio == answerAudio &&
        other.answerVideo == answerVideo;
  }

  @override
  int get hashCode {
    return wakeUid.hashCode ^
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
        isRejected.hashCode ^
        approveTime.hashCode ^
        senderUid.hashCode ^
        message.hashCode ^
        messagePhoto.hashCode ^
        messageAudio.hashCode ^
        messageVideo.hashCode ^
        reciverUid.hashCode ^
        answerTime.hashCode ^
        answer.hashCode ^
        answerPhoto.hashCode ^
        answerAudio.hashCode ^
        answerVideo.hashCode;
  }

  static Future<WakeModel> emptyFuture() async {
    return WakeModel(
      wakeUid: "",
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
      isRejected: false,
      senderUid: "",
      message: "",
      messagePhoto: "",
      messageAudio: "",
      messageVideo: "",
      reciverUid: "",
      answer: "",
      answerPhoto: "",
      answerAudio: "",
      answerVideo: "",
    );
  }

  static WakeModel empty() {
    return WakeModel(
      wakeUid: "",
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
      isRejected: false,
      senderUid: "",
      message: "",
      messagePhoto: "",
      messageAudio: "",
      messageVideo: "",
      reciverUid: "",
      answer: "",
      answerPhoto: "",
      answerAudio: "",
      answerVideo: "",
    );
  }

  static WakeModel sample() {
    return WakeModel(
      wakeUid: "",
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
      isRejected: false,
      senderUid: "",
      message: "",
      messagePhoto: "",
      messageAudio: "",
      messageVideo: "",
      reciverUid: "",
      answer: "",
      answerPhoto: "",
      answerAudio: "",
      answerVideo: "",
    );
  }
}
