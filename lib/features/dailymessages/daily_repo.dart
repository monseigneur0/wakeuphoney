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

  FutureVoid createDailyMessage(
      DailyMessageModel dailyMessageModel, String uid) async {
    try {
      return right(
        _usersCollection
            .doc(uid)
            .collection("messages")
            .add(dailyMessageModel.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<DailyMessageModel>> getDailyMessageList(String uid) {
    return _usersCollection.doc(uid).collection("messages").snapshots().map(
        (event) =>
            event.docs.map((e) => DailyMessageModel.fromMap(e.data())).toList()
              ..sort((a, b) => a.messagedatetime.compareTo(b.messagedatetime)));
  }

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

  createResponseMessage(
      DailyMessageModel messagehere, String uid, String coupleUid) async {
    await _usersCollection
        .doc(coupleUid)
        .collection("messages")
        .add(messagehere.toMap());
  }
}
