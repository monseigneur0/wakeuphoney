import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/failure.dart';

import '../../core/type_defs.dart';
import 'daily_model.dart';

final dailyRepositoryProvider = Provider((ref) => DailyRepository());

class DailyRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Stream<DailyMessageModel> getDailyMessage(
      String uid, String date, String coupleUid) {
    return _usersCollection
        .doc(uid)
        .collection(coupleUid)
        .where("messagedate", isEqualTo: date)
        .limit(1)
        .snapshots()
        .map((event) => event.docs
            .map((e) => DailyMessageModel.fromMap(e.data()))
            .toList()
            .first);
  }

  FutureVoid createDailyMessage(String message, String selectedDate,
      DateTime selectedDateTime, String coupleId, String uid) async {
    try {
      return right(
        _usersCollection.doc(uid).collection(coupleId).add({
          "message": message,
          "time": DateTime.now(),
          "messagedate": selectedDate,
          "messagedatetime": selectedDateTime,
          "uid": uid,
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
