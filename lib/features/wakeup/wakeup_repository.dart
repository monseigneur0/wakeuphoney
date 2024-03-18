import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/wakeup/wakeup_model.dart';

import '../../core/constants/firebase_constants.dart';
import '../../core/providers/firebase_providers.dart';

final wakeUpRepositoryProvider = Provider((ref) => WakeUpRepository(firestore: ref.watch(firestoreProvider)));

class WakeUpRepository {
  final FirebaseFirestore _firestore;
  WakeUpRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _usersCollection => _firestore.collection(FirebaseConstants.usersCollection);

  Logger logger = Logger();

  createWakeUp(String uid, WakeUpModel wakeUp) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeUpCollection)
          .doc(wakeUp.wakeUpUid)
          .set(wakeUp.toMap());
    } catch (e) {
      logger.e(e.toString());
    }
  }

  createWakeUpAlarm(String uid, WakeUpModel wakeUp) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeUpAlarmCollection)
          .doc(wakeUp.wakeUpUid)
          .set(wakeUp.toMap());
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Stream<List<WakeUpModel>> getLettersList(String uid) {
    //오늘 날짜 이전으로 받는사람이 나인것만, 보낸사람이 나인건 모두 보여주기.
    //오늘 이후 받는 사람이 나인것 빼고 모두 보여주기
    //sender uid or (reciver == uid and letterTime < now)
    //날짜순 정렬하기

    try {
      logger.d("run Stream<List<WakeUpModel>> getLettersList");
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeUpCollection)
          .where(Filter.or(Filter("senderUid", isEqualTo: uid), (Filter("wakeTime", isLessThan: Timestamp.now()))))
          .snapshots()
          .map(
            (wakeUpSnapShot) => wakeUpSnapShot.docs.map((e) => WakeUpModel.fromMap(e.data())).toList()
              ..sort((a, b) => b.wakeTime.compareTo(a.wakeTime)),
          );
      // return _usersCollection
      //     .doc(uid)
      //     .collection(FirebaseConstants.wakeUpCollection)
      //     .snapshots()
      //     .map((wakeUpSnapShot) => wakeUpSnapShot.docs
      //         .map((e) => WakeUpModel.fromMap(e.data()))
      //         .toList()
      //       ..sort((a, b) => b.wakeTime.compareTo(a.wakeTime)));
    } catch (e) {
      logger.e(e.toString());
      return Stream.error(e);
    }
  }

  letterEditMessage(String uid, String letterId, String message) {
    try {
      _usersCollection.doc(uid).collection(FirebaseConstants.wakeUpCollection).doc(letterId).update({
        "letter": message,
        "modifiedTimes": DateTime.now(),
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }

  letterDeleteMessage(String uid, String letterId) {
    try {
      _usersCollection.doc(uid).collection(FirebaseConstants.wakeUpCollection).doc(letterId).delete();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<WakeUpModel> getALetterforResponse(String uid) async {
    final datetime = DateTime.now();
    final datetime10 = DateTime.now().add(10.minutes);

    try {
      return await _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeUpCollection)
          .where("reciverUid", isEqualTo: uid)
          .where("wakeTime",
              isLessThan: Timestamp(
                  DateTime(datetime.year, datetime.month, datetime.day, datetime10.hour, datetime10.minute, 0)
                          .millisecondsSinceEpoch ~/
                      1000,
                  0))
          .orderBy("wakeTime", descending: true)
          .get()
          .then(
        (value) {
          {
            if (value.docs.isEmpty) return WakeUpModel.emptyFuture();
            return WakeUpModel.fromMap(value.docs.first.data());
          }
        },
      );
    } catch (e) {
      logger.e(e.toString());
      return Future.error(e);
    }
  }

  createResponseLetter(String uid, String wakeUpUid, String message, String imageUrl) {
    try {
      _usersCollection.doc(uid).collection(FirebaseConstants.wakeUpCollection).doc(wakeUpUid).update(
          {"answer": message, "answerPhoto": imageUrl, "answerTime": DateTime.now(), "modifiedTimes": DateTime.now()});
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<WakeUpModel> getTomorrowWakeUpYou(String uid) async {
    try {
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeUpCollection)
          .where("senderUid", isEqualTo: uid)
          .where("wakeTime", isGreaterThan: Timestamp.now())
          .get()
          .then((value) {
        {
          if (value.docs.isEmpty) return WakeUpModel.emptyFuture();
          return WakeUpModel.fromMap(value.docs.first.data());
        }
      });
    } catch (e) {
      logger.e(e.toString());
      return Future.error(e);
    }
  }

  Future<WakeUpModel> getTomorrowWakeUpMe(String uid) async {
    try {
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeUpCollection)
          .where("reciverUid", isEqualTo: uid)
          .where("wakeTime", isGreaterThan: Timestamp.now())
          .get()
          .then((value) {
        {
          if (value.docs.isEmpty) return WakeUpModel.emptyFuture();
          return WakeUpModel.fromMap(value.docs.first.data());
        }
      });
    } catch (e) {
      logger.e(e.toString());
      return Future.error(e);
    }
  }

  wakeUpAprove(String uid, String wakeUpUid) {
    try {
      _usersCollection.doc(uid).collection(FirebaseConstants.wakeUpCollection).doc(wakeUpUid).update({
        "isApproved": true,
        "modifiedTimes": DateTime.now(),
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<WakeUpModel> getAWakeUpLetter(String uid) async {
    final datetime = DateTime.now();
    try {
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeUpCollection)
          .where("reciverUid", isEqualTo: uid)
          .where("wakeTime",
              isLessThan: Timestamp(
                  DateTime(datetime.year, datetime.month, datetime.day, 10, 0, 0).millisecondsSinceEpoch ~/ 1000, 0))
          .orderBy("wakeTime", descending: true)
          .get()
          .then((value) {
        {
          if (value.docs.isEmpty) return WakeUpModel.emptyFuture();
          return WakeUpModel.fromMap(value.docs.first.data());
        }
      });
    } catch (e) {
      logger.e(e.toString());
      return Future.error(e);
    }
  }
}
