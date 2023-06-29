// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String name; // no changed
  final String profilePic;
  final String banner;
  final String uid;
  final bool isAuthenticated; //if guest or not
  final int karma;
  final List<String> awards;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.banner,
    required this.uid,
    required this.isAuthenticated,
    required this.karma,
    required this.awards,
  });

  UserModel copyWith({
    String? name,
    String? profilePic,
    String? banner,
    String? uid,
    bool? isAuthenticated,
    int? karma,
    List<String>? awards,
  }) {
    return UserModel(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      banner: banner ?? this.banner,
      uid: uid ?? this.uid,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      karma: karma ?? this.karma,
      awards: awards ?? this.awards,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'banner': banner,
      'uid': uid,
      'isAuthenticated': isAuthenticated,
      'karma': karma,
      'awards': awards,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] as String,
        profilePic: map['profilePic'] as String,
        banner: map['banner'] as String,
        uid: map['uid'] as String,
        isAuthenticated: map['isAuthenticated'] as bool,
        karma: map['karma'] as int,
        awards: List<String>.from(
          (map['awards'] as List<String>),
        ));
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profilePic: $profilePic, banner: $banner, uid: $uid, isAuthenticated: $isAuthenticated, karma: $karma, awards: $awards)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.profilePic == profilePic &&
        other.banner == banner &&
        other.uid == uid &&
        other.isAuthenticated == isAuthenticated &&
        other.karma == karma &&
        listEquals(other.awards, awards);
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profilePic.hashCode ^
        banner.hashCode ^
        uid.hashCode ^
        isAuthenticated.hashCode ^
        karma.hashCode ^
        awards.hashCode;
  }
}

class CoupleModel {
  final String coupleName;
  CoupleModel({
    required this.coupleName,
  });

  CoupleModel copyWith({
    String? coupleName,
  }) {
    return CoupleModel(
      coupleName: coupleName ?? this.coupleName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'coupleName': coupleName,
    };
  }

  factory CoupleModel.fromMap(Map<String, dynamic> map) {
    return CoupleModel(
      coupleName: map['coupleName'] as String,
    );
  }

  @override
  String toString() => 'CoupleModel(coupleName: $coupleName)';

  @override
  bool operator ==(covariant CoupleModel other) {
    if (identical(this, other)) return true;

    return other.coupleName == coupleName;
  }

  @override
  int get hashCode => coupleName.hashCode;
}

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

  String toJson() => json.encode(toMap());

  factory DailyMessageModel.fromJson(String source) =>
      DailyMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

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
