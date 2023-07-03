import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/failure.dart';

import '../../core/type_defs.dart';
import 'daily_model.dart';

final dailyRepositoryProvider = Provider((ref) => DailyRepository());

class DailyRepository {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference _coupleCollection =
      FirebaseFirestore.instance.collection('couples');

//안씀 삭제할것

  Future creatingCouple(String coupleName, String uid) async {
    await _coupleCollection.add({
      "coupleName": coupleName,
    }).then(
      (value) async => await usersCollection.doc(uid).update({
        "couples": [
          ...{value.id}
        ]
      }),
    );
  }
//안씀 삭제할것

  Future creatingDailyMessage(String uid, String message, DateTime time) async {
    await _coupleCollection.add({
      "uid": uid,
      "message": message,
      "time": time,
    });
  }
//안씀 삭제할것

  getDailyMessages(String coupleId) async {
    return _coupleCollection
        .doc(coupleId)
        .collection("dailymessages")
        .orderBy("messagedatetime")
        .snapshots();
  }

//안씀 삭제할것
  Stream<DailyMessageModel> getDailyMessagess(String date) {
    return _coupleCollection
        .doc("93zTjlpDFqX0AO0TKvIm")
        .collection("dailymessages")
        .doc("Os7njRq3RDo04xKFg3OJ")
        .snapshots()
        .map((event) =>
            DailyMessageModel.fromMap(event.data() as Map<String, dynamic>));
  }

  Stream<DailyMessageModel> getDailyMessage(String date) {
    return _coupleCollection
        .doc("93zTjlpDFqX0AO0TKvIm")
        .collection("dailymessages")
        .where("messagedate", isEqualTo: date)
        .limit(1)
        .snapshots()
        .map((event) => event.docs
            .map((e) => DailyMessageModel.fromMap(e.data()))
            .toList()
            .first);
  }

  FutureVoid createDailyMessage(String message, String selectedDate,
      DateTime selectedDateTime, String uid) async {
    try {
      return right(_coupleCollection
          .doc("93zTjlpDFqX0AO0TKvIm")
          .collection("dailymessages")
          .add({
        "message": message,
        "time": DateTime.now(),
        "messagedate": selectedDate,
        "messagedatetime": selectedDateTime,
        "uid": uid,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  updateDailyMessage(String message, String selectedDate,
      DateTime selectedDateTime, String uid) {
    _coupleCollection
        .doc("93zTjlpDFqX0AO0TKvIm")
        .collection("dailymessages")
        .add({
      "message": message,
      "time": DateTime.now(),
      "messagedate": selectedDate,
      "messagedatetime": selectedDateTime,
      "uid": "IZZ1HICxZ8ggCiJihcJKow38LPK2"
    });
  }

//안씀 삭제할것
  Stream<List<DailyMessageModel>> getDailyMessagesListStream(String date) {
    return _coupleCollection
        .doc("93zTjlpDFqX0AO0TKvIm")
        .collection("dailymessages")
        .where("messagedate", isEqualTo: date)
        .snapshots()
        .map((event) => event.docs
            .map((e) => DailyMessageModel.fromMap(e.data()))
            .toList());
  }
}
