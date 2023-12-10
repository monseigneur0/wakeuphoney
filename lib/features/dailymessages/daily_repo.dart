import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/failure.dart';

import '../../core/constants/firebase_constants.dart';
import '../../core/providers/firebase_providers.dart';
import '../../core/type_defs.dart';
import 'daily_model.dart';

final dailyRepositoryProvider =
    Provider((ref) => DailyRepository(firestore: ref.watch(firestoreProvider)));

class DailyRepository {
  final FirebaseFirestore _firestore;
  DailyRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _usersCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Stream<DailyMessageModel> getDailyMessage(
      String uid, String date, String coupleUid) {
    return _usersCollection
        .doc(uid)
        .collection("messages")
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
        _usersCollection.doc(uid).collection("messages").add(
              dailyMessageModel.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  //23.11.30
  Stream<List<DailyMessageModel>> getLettersList(String uid) {
    return _usersCollection.doc(uid).collection("messages").snapshots().map(
        (event) =>
            event.docs.map((e) => DailyMessageModel.fromMap(e.data())).toList()
              ..sort(
                (a, b) => b.messagedatetime.compareTo(a.messagedatetime),
              ));
  }

  Stream<List<DailyMessageModel>> getDailyMessageList(String uid) {
    return _usersCollection.doc(uid).collection("messages").snapshots().map(
        (event) =>
            event.docs.map((e) => DailyMessageModel.fromMap(e.data())).toList()
              ..sort((a, b) => a.messagedatetime.compareTo(b.messagedatetime)));
  }

  Stream<List<DailyMessageModel>> getHistoryMessageList(String uid) {
    return _usersCollection
        .doc(uid)
        .collection("messages")
        .where("messagedatetime", isLessThan: DateTime.now())
        .snapshots()
        .map((event) =>
            event.docs.map((e) => DailyMessageModel.fromMap(e.data())).toList()
              ..sort((a, b) => a.messagedatetime.compareTo(b.messagedatetime)));
  }

  Stream<List<DailyMessageModel>> getDailyMessageHistoryList(String uid) {
    return _usersCollection.doc(uid).collection("messages").snapshots().map(
          (event) => event.docs
              .map((e) => DailyMessageModel.fromMap(e.data()))
              .toList()
            // ..where((element) => element.messagedatetime.isBefore(DateTime.now()
            //     .subtract(Duration(
            //         seconds: DateTime.now().hour * 3600 +
            //             DateTime.now().minute * 60 +
            //             DateTime.now().second))))
            ..sort((a, b) => b.messagedatetime.compareTo(a.messagedatetime)),
        );
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

  deleteDailyMessage(String selectedDate, String uid) async {
    await _usersCollection
        .doc(uid)
        .collection("messages")
        .where("messagedate", isEqualTo: selectedDate)
        .get()
        .then((value) => _usersCollection
            .doc(uid)
            .collection("messages")
            .doc(value.docs.first.id)
            .delete());
  }

  updateDailyImage(String image, String selectedDate, String uid) async {
    await _usersCollection
        .doc(uid)
        .collection("messages")
        .where("messagedate", isEqualTo: selectedDate)
        .get()
        .then((value) => _usersCollection
            .doc(uid)
            .collection("messages")
            .doc(value.docs.first.id)
            .update({"photo": image}));
  }

  createResponseMessage(
      DailyMessageModel messagehere, String uid, String coupleUid) async {
    await _usersCollection
        .doc(coupleUid)
        .collection("messages")
        .add(messagehere.toMap());
  }
}
