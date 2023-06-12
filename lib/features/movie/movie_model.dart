// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class Movie {
  final String title;
  final String keyword;
  final String poster;
  final bool like;
  final DocumentReference ref;

  Movie.fromMap(Map<String, dynamic> map, {required this.ref})
      : title = map['title'],
        keyword = map['keyword'],
        poster = map['poster'],
        like = map['like'];

  Movie.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.get('moives'), ref: snapshot.reference);

  @override
  String toString() {
    return 'Movie(title: $title, keyword: $keyword, poster: $poster, like: $like, ref: $ref)';
  }

  @override
  bool operator ==(covariant Movie other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.keyword == keyword &&
        other.poster == poster &&
        other.like == like &&
        other.ref == ref;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        keyword.hashCode ^
        poster.hashCode ^
        like.hashCode ^
        ref.hashCode;
  }
}
