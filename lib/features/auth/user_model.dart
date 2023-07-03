import 'package:flutter/foundation.dart';

class UserModel {
  final String displayName;
  final String email;
  final String photoURL;
  final String uid;

  final String couple;
  final List couples;
  final DateTime creationTime;
  final DateTime lastSignInTime;
  final bool isLoggedIn;
  UserModel({
    required this.displayName,
    required this.email,
    required this.photoURL,
    required this.uid,
    required this.couple,
    required this.couples,
    required this.creationTime,
    required this.lastSignInTime,
    required this.isLoggedIn,
  });

  UserModel copyWith({
    String? displayName,
    String? email,
    String? photoURL,
    String? uid,
    String? couple,
    List? couples,
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
      creationTime: creationTime ?? this.creationTime,
      lastSignInTime: lastSignInTime ?? this.lastSignInTime,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'uid': uid,
      'couple': couple,
      'couples': couples,
      'creationTime': creationTime,
      'lastSignInTime': lastSignInTime,
      'isLoggedIn': isLoggedIn,
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
      creationTime: (map['creationTime']).toDate(),
      lastSignInTime: (map['lastSignInTime']).toDate(),
      isLoggedIn: map['isLoggedIn'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserModel(displayName: $displayName, email: $email, photoURL: $photoURL, uid: $uid, couple: $couple, couples: $couples, creationTime: $creationTime, lastSignInTime: $lastSignInTime, isLoggedIn: $isLoggedIn)';
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
        creationTime.hashCode ^
        lastSignInTime.hashCode ^
        isLoggedIn.hashCode;
  }
}
