import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/letter/letter_model.dart';

import '../../core/constants/firebase_constants.dart';

final letterRepositoryProvider = Provider(
    (ref) => LetterRepository(firestore: ref.watch(firestoreProvider)));

class LetterRepository {
  final FirebaseFirestore _firestore;
  LetterRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _usersCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Logger logger = Logger();

  createLetter(LetterModel letterModel, String uid) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .doc(letterModel.letterId)
          .set(letterModel.toMap());
    } catch (e) {
      logger.e(e.toString());
    }
  }

  // createAnswer(){
  //   try {
  //     _usersCollection.doc(uid).collection(FirebaseConstants.lettersCollection).where()
  //   } catch (e) {
  //        logger.e(e.toString());
  //   }
  // }
  updateDailyMessage(String message, String selectedDate, String uid) async {
    await _usersCollection
        .doc(uid)
        .collection("messages")
        .where("messagedate", isEqualTo: selectedDate)
        .get()
        .then((value) => _usersCollection
            .doc(uid)
            .collection("messages")
            .doc(value.docs.first.id)
            .update({"message": message}));
  }

  Stream<List<LetterModel>> getLetters2List(String uid) {
    //오늘 날짜 이전으로 받는사람이 나인것만, 보낸사람이 나인건 모두 보여주기.
    //오늘 이후 받는 사람이 나인것 빼고 모두 보여주기
    //sender uid or (reciver == uid and letterTime < now)
    //날짜순 정렬하기

    try {
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .where(Filter.or(Filter("sender", isEqualTo: uid),
              (Filter("letterTime", isLessThan: Timestamp.now()))))
          .snapshots()
          .map(
            (letterSnapShot) => letterSnapShot.docs
                .map((e) => LetterModel.fromMap(e.data()))
                .toList()
              ..sort((a, b) => b.letterTime.compareTo(a.letterTime)),
          );
    } catch (e) {
      logger.e(e.toString());
      return Stream.error(e);
    }
  }

  Future<LetterModel> getALetter(String uid) async {
    final datetime = DateTime.now();
    try {
      final letter = await _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .where("reciver", isEqualTo: uid)
          .where("letterTime",
              isLessThan: Timestamp(
                  DateTime(datetime.year, datetime.month, datetime.day, 10, 0,
                              0)
                          .millisecondsSinceEpoch ~/
                      1000,
                  0))
          .orderBy("letterTime", descending: true)
          .get();
      // if (datetime.isAfter(
      //     DateTime(datetime.year, datetime.month, datetime.day, 5, 0, 0))) {
      return LetterModel.fromMap(letter.docs.first.data());
      // } else {
      //   return LetterModel.fromMap(letter.docs.elementAt(1).data());
      // }
      //새벽 6시면 10시 이전 즉 9시 편지를 찾아서 보여준다
      //없으면 이전날꺼 그대로 보여준다. 사람 이름으로 찾아야겠는데
      //새벽 4시면 10시 이전 즉 9시 편지를 찾아서 지만 이전껄 보여주는데 오늘 날짜게 없으면 전전날이네
    } catch (e) {
      logger.e(e.toString());
      return LetterModel(
          letterId: "PyY5skHRgPJP0CMgI2Qp",
          sender: "PyY5skHRgPJP0CMgI2Qp",
          dateTimeNow: DateTime.now(),
          letterTime: DateTime.now(),
          letter: "PyY5skHRgPJP0CMgI2Qp",
          letterPhoto: "PyY5skHRgPJP0CMgI2Qp",
          letterAudio: "PyY5skHRgPJP0CMgI2Qp",
          letterVideo: "PyY5skHRgPJP0CMgI2Qp",
          reciver: "PyY5skHRgPJP0CMgI2Qp",
          answer: "PyY5skHRgPJP0CMgI2Qp",
          answerTime: DateTime.now(),
          answerPhoto: "PyY5skHRgPJP0CMgI2Qp",
          answerAudio: "PyY5skHRgPJP0CMgI2Qp",
          answerVideo: "PyY5skHRgPJP0CMgI2Qp");
    }
  }

  letterEditMessage(String uid, String letterId, String message) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .doc(letterId)
          .update({"letter": message, "dateTimeNow": Timestamp.now()});
    } catch (e) {
      logger.e(e.toString());
    }
  }

  letterDelete(String uid, String letterId) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .doc(letterId)
          .delete();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  createResponseLetter(
      String uid, String letterUid, String message, String imageUrl) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .doc(letterUid)
          .update({
        "answer": message,
        "answerTime": Timestamp.now(),
        "answerPhoto": imageUrl
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
