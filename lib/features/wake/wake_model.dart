import 'dart:convert';

class WakeModel {
  final String uid;
  final int alarmId;
  final DateTime dateTime;
  final String assetAudioPath;
  final bool loopAudio;
  final bool vibrate;
  final double volume;
  final double fadeDuration;
  final String notificationTitle;
  final String notificationBody;
  final bool enableNotificationOnKill;
  final bool androidFullScreenIntent;
  final bool isApproved;
  final DateTime requestTime;
  final DateTime? approveTime;
  final bool isDeleted;
  final String sender;
  final String reciver;
  final List<bool> days;
  WakeModel({
    required this.uid,
    required this.alarmId,
    required this.dateTime,
    required this.assetAudioPath,
    required this.loopAudio,
    required this.vibrate,
    required this.volume,
    required this.fadeDuration,
    required this.notificationTitle,
    required this.notificationBody,
    required this.enableNotificationOnKill,
    required this.androidFullScreenIntent,
    required this.isApproved,
    required this.requestTime,
    this.approveTime,
    required this.isDeleted,
    required this.sender,
    required this.reciver,
    required this.days,
  });

  WakeModel copyWith({
    String? uid,
    int? alarmId,
    DateTime? dateTime,
    String? assetAudioPath,
    bool? loopAudio,
    bool? vibrate,
    double? volume,
    double? fadeDuration,
    String? notificationTitle,
    String? notificationBody,
    bool? enableNotificationOnKill,
    bool? androidFullScreenIntent,
    bool? isApproved,
    DateTime? requestTime,
    DateTime? approveTime,
    bool? isDeleted,
    String? sender,
    String? reciver,
    List<bool>? days,
  }) {
    return WakeModel(
      uid: uid ?? this.uid,
      alarmId: alarmId ?? this.alarmId,
      dateTime: dateTime ?? this.dateTime,
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
      isApproved: isApproved ?? this.isApproved,
      requestTime: requestTime ?? this.requestTime,
      approveTime: approveTime ?? this.approveTime,
      isDeleted: isDeleted ?? this.isDeleted,
      sender: sender ?? this.sender,
      reciver: reciver ?? this.reciver,
      days: days ?? this.days,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'alarmId': alarmId,
      'dateTime': dateTime,
      'assetAudioPath': assetAudioPath,
      'loopAudio': loopAudio,
      'vibrate': vibrate,
      'volume': volume,
      'fadeDuration': fadeDuration,
      'notificationTitle': notificationTitle,
      'notificationBody': notificationBody,
      'enableNotificationOnKill': enableNotificationOnKill,
      'androidFullScreenIntent': androidFullScreenIntent,
      'isApproved': isApproved,
      'requestTime': requestTime,
      'approveTime': approveTime,
      'isDeleted': isDeleted,
      'sender': sender,
      'reciver': reciver,
      'days': days,
    };
  }

  factory WakeModel.fromMap(Map<String, dynamic> map) {
    return WakeModel(
      uid: map['uid'] as String,
      alarmId: map['alarmId'] as int,
      dateTime: map['dateTime'].toDate(),
      assetAudioPath: map['assetAudioPath'] as String,
      loopAudio: map['loopAudio'] as bool,
      vibrate: map['vibrate'] as bool,
      volume: map['volume'] as double,
      fadeDuration: map['fadeDuration'] as double,
      notificationTitle: map['notificationTitle'] as String,
      notificationBody: map['notificationBody'] as String,
      enableNotificationOnKill: map['enableNotificationOnKill'] as bool,
      androidFullScreenIntent: map['androidFullScreenIntent'] as bool,
      isApproved: map['isApproved'] as bool,
      requestTime: map['requestTime'].toDate(),
      approveTime: map['approveTime']?.toDate(),
      isDeleted: map['isDeleted'] as bool,
      sender: map['sender'] as String,
      reciver: map['reciver'] as String,
      days: List<bool>.from(map['days'] as List<dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory WakeModel.fromJson(String source) =>
      WakeModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'WakeModel(uid: $uid, alarmId: $alarmId, dateTime: $dateTime, assetAudioPath: $assetAudioPath, loopAudio: $loopAudio, vibrate: $vibrate, volume: $volume, fadeDuration: $fadeDuration, notificationTitle: $notificationTitle, notificationBody: $notificationBody, enableNotificationOnKill: $enableNotificationOnKill, androidFullScreenIntent: $androidFullScreenIntent, isApproved: $isApproved, requestTime: $requestTime, approveTime: $approveTime, isDeleted: $isDeleted)';
  }

  @override
  bool operator ==(covariant WakeModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.alarmId == alarmId &&
        other.dateTime == dateTime &&
        other.assetAudioPath == assetAudioPath &&
        other.loopAudio == loopAudio &&
        other.vibrate == vibrate &&
        other.volume == volume &&
        other.fadeDuration == fadeDuration &&
        other.notificationTitle == notificationTitle &&
        other.notificationBody == notificationBody &&
        other.enableNotificationOnKill == enableNotificationOnKill &&
        other.androidFullScreenIntent == androidFullScreenIntent &&
        other.isApproved == isApproved &&
        other.requestTime == requestTime &&
        other.approveTime == approveTime &&
        other.isDeleted == isDeleted &&
        other.sender == sender &&
        other.reciver == reciver &&
        other.days == days;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        alarmId.hashCode ^
        dateTime.hashCode ^
        assetAudioPath.hashCode ^
        loopAudio.hashCode ^
        vibrate.hashCode ^
        volume.hashCode ^
        fadeDuration.hashCode ^
        notificationTitle.hashCode ^
        notificationBody.hashCode ^
        enableNotificationOnKill.hashCode ^
        androidFullScreenIntent.hashCode ^
        isApproved.hashCode ^
        requestTime.hashCode ^
        approveTime.hashCode ^
        isDeleted.hashCode ^
        sender.hashCode ^
        reciver.hashCode ^
        days.hashCode;
  }
}
