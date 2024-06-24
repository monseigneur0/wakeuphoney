import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserModel {
  final String displayName;
  final String email;
  final String photoURL;
  final String uid;
  final String? loginType;
  final String? fcmToken;

  final String gender;
  final DateTime birthDate;
  final GeoPoint location;
  final DateTime wakeUpTime;

  final String? couple;
  final List? couples;
  final String? coupleDisplayName;
  final String? couplePhotoURL;

  final String? coupleGender;
  final DateTime? coupleBirthDate;
  final GeoPoint? coupleLocation;
  final DateTime? coupleWakeUpTime;

  final DateTime creationTime;
  final DateTime? matchedDateTime;
  final DateTime lastSignInTime;
  final bool isLoggedIn;

  final int chatGPTMessageCount;
  UserModel({
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.uid,
    this.loginType,
    this.fcmToken,
    this.couple,
    this.couples,
    this.coupleDisplayName,
    this.couplePhotoURL,
    required this.creationTime,
    this.matchedDateTime,
    required this.lastSignInTime,
    required this.isLoggedIn,
    required this.chatGPTMessageCount,
    required this.gender,
    required this.birthDate,
    required this.location,
    required this.wakeUpTime,
    this.coupleGender,
    this.coupleBirthDate,
    this.coupleLocation,
    this.coupleWakeUpTime,
  });

  UserModel copyWith({
    String? displayName,
    String? email,
    String? photoURL,
    String? uid,
    String? fcmToken,
    String? loginType,
    String? couple,
    List? couples,
    String? coupleDisplayName,
    String? couplePhotoURL,
    DateTime? creationTime,
    DateTime? matchedDateTime,
    DateTime? lastSignInTime,
    bool? isLoggedIn,
    int? chatGPTMessageCount,
    String? gender,
    DateTime? birthDate,
    GeoPoint? location,
    DateTime? wakeUpTime,
    String? coupleGender,
    DateTime? coupleBirthDate,
    GeoPoint? coupleLocation,
    DateTime? coupleWakeUpTime,
  }) {
    return UserModel(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      uid: uid ?? this.uid,
      loginType: loginType ?? this.loginType,
      fcmToken: fcmToken ?? this.fcmToken,
      couple: couple ?? this.couple,
      couples: couples ?? this.couples,
      coupleDisplayName: coupleDisplayName ?? this.coupleDisplayName,
      couplePhotoURL: couplePhotoURL ?? this.couplePhotoURL,
      creationTime: creationTime ?? this.creationTime,
      matchedDateTime: matchedDateTime ?? this.matchedDateTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      chatGPTMessageCount: chatGPTMessageCount ?? this.chatGPTMessageCount,
      gender: gender ?? this.gender,
      birthDate: birthDate ?? this.birthDate,
      location: location ?? this.location,
      wakeUpTime: wakeUpTime ?? this.wakeUpTime,
      coupleGender: coupleGender ?? this.coupleGender,
      coupleBirthDate: coupleBirthDate ?? this.coupleBirthDate,
      coupleLocation: coupleLocation ?? this.coupleLocation,
      coupleWakeUpTime: coupleWakeUpTime ?? this.coupleWakeUpTime,
    );
  }

//.millisecondsSinceEpoch to int
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'uid': uid,
      'loginType': loginType,
      'fcmToken': fcmToken,
      'couple': couple,
      'couples': couples,
      'coupleDisplayName': coupleDisplayName,
      'couplePhotoURL': couplePhotoURL,
      'creationTime': creationTime,
      'matchedDateTime': matchedDateTime,
      'lastSignInTime': lastSignInTime,
      'isLoggedIn': isLoggedIn,
      'chatGPTMessageCount': chatGPTMessageCount,
      'gender': gender,
      'birthDate': birthDate,
      'location': location,
      'wakeUpTime': wakeUpTime,
      'coupleGender': coupleGender,
      'coupleBirthDate': coupleBirthDate,
      'coupleLocation': coupleLocation,
      'coupleWakeUpTime': coupleWakeUpTime,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      photoURL: map['photoURL'] as String,
      uid: map['uid'] as String,
      loginType: map['loginType'] as String?,
      fcmToken: map['fcmToken'] as String?,
      couple: map['couple'] as String,
      couples: List.from((map['couples'] as List)),
      coupleDisplayName: map['coupleDisplayName'] as String,
      couplePhotoURL: map['couplePhotoURL'] as String,
      creationTime: (map['creationTime']).toDate(),
      matchedDateTime: (map['matchedDateTime'])?.toDate(),
      lastSignInTime: (map['lastSignInTime']).toDate(),
      isLoggedIn: map['isLoggedIn'] as bool,
      chatGPTMessageCount: map['chatGPTMessageCount'] as int,
      gender: map['gender'] as String,
      birthDate: map['birthDate'].toDate(),
      location: map['location'] as GeoPoint,
      wakeUpTime: map['wakeUpTime'].toDate(),
      coupleGender: map['coupleGender'] as String,
      coupleBirthDate: map['coupleBirthDate'].toDate(),
      coupleLocation: map['coupleLocation'] as GeoPoint,
      coupleWakeUpTime: map['coupleWakeUpTime'].toDate(),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.displayName == displayName &&
        other.email == email &&
        other.photoURL == photoURL &&
        other.uid == uid &&
        other.loginType == loginType &&
        other.fcmToken == fcmToken &&
        other.couple == couple &&
        listEquals(other.couples, couples) &&
        other.coupleDisplayName == coupleDisplayName &&
        other.couplePhotoURL == couplePhotoURL &&
        other.creationTime == creationTime &&
        other.matchedDateTime == matchedDateTime &&
        other.lastSignInTime == lastSignInTime &&
        other.isLoggedIn == isLoggedIn;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        email.hashCode ^
        photoURL.hashCode ^
        uid.hashCode ^
        loginType.hashCode ^
        fcmToken.hashCode ^
        couple.hashCode ^
        couples.hashCode ^
        coupleDisplayName.hashCode ^
        couplePhotoURL.hashCode ^
        creationTime.hashCode ^
        matchedDateTime.hashCode ^
        lastSignInTime.hashCode ^
        isLoggedIn.hashCode;
  }

  static UserModel empty() {
    return UserModel(
      displayName: '',
      email: '',
      photoURL: '',
      uid: '',
      loginType: 'email',
      fcmToken: '',
      couple: '',
      couples: [],
      coupleDisplayName: '',
      couplePhotoURL: '',
      creationTime: DateTime.now(),
      matchedDateTime: DateTime.now(),
      lastSignInTime: DateTime.now(),
      isLoggedIn: false,
      chatGPTMessageCount: 0,
      gender: 'male',
      birthDate: DateTime.now(),
      location: const GeoPoint(0, 0),
      wakeUpTime: DateTime.now(),
      coupleGender: '',
      coupleBirthDate: null,
      coupleLocation: null,
      coupleWakeUpTime: null,
    );
  }
}
