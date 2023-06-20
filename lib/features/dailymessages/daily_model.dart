// ignore_for_file: public_member_api_docs, sort_constructors_first

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
  final String sender;
  final DateTime time;
  DailyMessageModel({
    required this.message,
    required this.sender,
    required this.time,
  });

  DailyMessageModel copyWith({
    String? message,
    String? sender,
    DateTime? time,
  }) {
    return DailyMessageModel(
      message: message ?? this.message,
      sender: sender ?? this.sender,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'sender': sender,
      'time': time.millisecondsSinceEpoch,
    };
  }

  factory DailyMessageModel.fromMap(Map<String, dynamic> map) {
    return DailyMessageModel(
      message: map['message'] as String,
      sender: map['sender'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
    );
  }

  @override
  String toString() =>
      'DailyMessageModel(message: $message, sender: $sender, time: $time)';

  @override
  bool operator ==(covariant DailyMessageModel other) {
    if (identical(this, other)) return true;

    return other.message == message &&
        other.sender == sender &&
        other.time == time;
  }

  @override
  int get hashCode => message.hashCode ^ sender.hashCode ^ time.hashCode;
}
