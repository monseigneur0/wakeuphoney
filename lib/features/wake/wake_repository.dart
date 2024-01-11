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

  createWake(String uid, String coupleUid, WakeModel wakeModel) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.wakeCollection)
          .doc(const Uuid().v4())
          .set(wakeModel.toMap());
    } catch (e) {}
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
      rethrow;
    }
  }
}
