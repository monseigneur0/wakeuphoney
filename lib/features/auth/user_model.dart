// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class UserModel {
  final String displayName;
  final String email;
  final String photoURL;
  final String uid;

  final String couple;
  final List couples;
  final String? coupleDisplayName;
  final String? couplePhotoURL;

  final DateTime creationTime;
  final DateTime lastSignInTime;
  final bool isLoggedIn;

  final int? chatGPTMessageCount;
  UserModel({
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.uid,
    required this.couple,
    required this.couples,
    this.coupleDisplayName,
    this.couplePhotoURL,
    required this.creationTime,
    required this.lastSignInTime,
    required this.isLoggedIn,
    this.chatGPTMessageCount,
  });

  UserModel copyWith({
    String? displayName,
    String? email,
    String? photoURL,
    String? uid,
    String? couple,
    List? couples,
    String? coupleDisplayName,
    String? couplePhotoURL,
    DateTime? creationTime,
    DateTime? lastSignInTime,
    bool? isLoggedIn,
  }) {
    return UserModel(
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      uid: uid ?? this.uid,
      couple: couple ?? this.couple,
      couples: couples ?? this.couples,
      coupleDisplayName: coupleDisplayName ?? this.coupleDisplayName,
      couplePhotoURL: couplePhotoURL ?? this.couplePhotoURL,
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

//.millisecondsSinceEpoch to int
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'uid': uid,
      'couple': couple,
      'couples': couples,
      'coupleDisplayName': coupleDisplayName,
      'couplePhotoURL': couplePhotoURL,
      'creationTime': creationTime,
      'lastSignInTime': lastSignInTime,
      'isLoggedIn': isLoggedIn,
      'chatGPTMessageCount': chatGPTMessageCount,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      photoURL: map['photoURL'] as String,
      uid: map['uid'] as String,
      couple: map['couple'] as String,
      couples: List.from((map['couples'] as List)),
      coupleDisplayName: map['coupleDisplayName'] != null
          ? map['coupleDisplayName'] as String
          : null,
      couplePhotoURL: map['couplePhotoURL'] != null
          ? map['couplePhotoURL'] as String
          : null,
      creationTime: (map['creationTime']).toDate(),
      lastSignInTime: (map['lastSignInTime']).toDate(),
      isLoggedIn: map['isLoggedIn'] as bool,
      chatGPTMessageCount: map['chatGPTMessageCount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(displayName: $displayName, email: $email, photoURL: $photoURL, uid: $uid, couple: $couple, couples: $couples, coupleDisplayName: $coupleDisplayName, couplePhotoURL: $couplePhotoURL, creationTime: $creationTime, lastSignInTime: $lastSignInTime, isLoggedIn: $isLoggedIn)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.displayName == displayName &&
        other.email == email &&
        other.photoURL == photoURL &&
        other.uid == uid &&
        other.couple == couple &&
        listEquals(other.couples, couples) &&
        other.coupleDisplayName == coupleDisplayName &&
        other.couplePhotoURL == couplePhotoURL &&
        other.creationTime == creationTime &&
        other.lastSignInTime == lastSignInTime &&
        other.isLoggedIn == isLoggedIn;
  }

  @override
  int get hashCode {
    return displayName.hashCode ^
        email.hashCode ^
        photoURL.hashCode ^
        uid.hashCode ^
        couple.hashCode ^
        couples.hashCode ^
        coupleDisplayName.hashCode ^
        couplePhotoURL.hashCode ^
        creationTime.hashCode ^
        lastSignInTime.hashCode ^
        isLoggedIn.hashCode;
  }
}
