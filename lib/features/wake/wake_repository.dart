import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';

import '../../core/constants/firebase_constants.dart';
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

  createWake(String uid, WakeModel wake) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeCollection)
          .doc(wake.wakeUid)
          .set(wake.toMap());
    } catch (e) {
      logger.e(e.toString());
    }
  }

  Future<List<WakeModel>> getWakesList(String uid) {
    try {
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeCollection)
          .where(Filter.or(Filter("senderUid", isEqualTo: uid),
              (Filter("alarmTime", isLessThan: Timestamp.now()))))
          .orderBy("alarmTime", descending: true)
          .get()
          .then((querySnapshot) {
        List<WakeModel> wakesList = [];
        for (var doc in querySnapshot.docs) {
          wakesList.add(WakeModel.fromMap(doc.data()));
        }
        return wakesList;
      });
    } catch (e) {
      logger.e(e.toString());
      return Future.error(e);
    }
  }

  wakeDelete(String uid, String wakeUid) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeCollection)
          .doc(wakeUid)
          .delete();
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
