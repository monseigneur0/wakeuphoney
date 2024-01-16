import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import 'package:wakeuphoney/core/constants/firebase_constants.dart';

import '../../core/providers/firebase_providers.dart';
import 'wake_model.dart';

final wakeRepositoryProvider =
    Provider((ref) => WakeRepository(firestore: ref.watch(firestoreProvider)));

class WakeRepository {
  final FirebaseFirestore _firestore;
  WakeRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _usersCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Logger logger = Logger();

  createWake(String uid, WakeModel wakeModel) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeCollection)
          .doc(wakeModel.uid)
          .set(wakeModel.toMap())
          .then((value) => logger.i("wake created $uid"));
    } catch (e) {
      logger.e(e.toString());
    }
  }

  approveWake(String uid, String alarmUid) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeCollection)
          .doc(alarmUid)
          .update({"approveTime": DateTime.now(), "isApproved": true});
    } catch (e) {
      logger.e(e.toString());
    }
  }

  deleteWake(String uid, String alarmUid) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeCollection)
          .doc(alarmUid)
          .delete();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Stream<List<WakeModel>> getWakes(uid) {
    try {
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeCollection)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => WakeModel.fromMap(doc.data()))
              .toList());
    } catch (e) {
      logger.e(e.toString());
      rethrow;
    }
  }
}
