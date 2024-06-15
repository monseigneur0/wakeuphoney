import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/firebase_providers.dart';
import 'package:wakeuphoney/tabs/wake/wake_model.dart';

final wakeRepositoryProvider = Provider((ref) => WakeRepository(firestore: ref.watch(firestoreProvider)));

class WakeRepository {
  final FirebaseFirestore _firestore;
  WakeRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Logger logger = Logger();

  bool createWakeUp(uid, wakeModel) {
    try {
      _users.doc(uid).collection(FirebaseConstants.alarmCollection).doc(wakeModel.wakeUid).set(wakeModel.toMap());
      return true;
    } catch (e) {
      logger.e(e.toString());
      return false;
    }
  }

  Future<List<WakeModel>> fetchWakeList(String uid) async {
    try {
      final snapshot = await _users.doc(uid).collection(FirebaseConstants.alarmCollection).get();
      return snapshot.docs.map((e) => WakeModel.fromMap(e.data())).toList();
    } catch (e) {
      logger.e(e.toString());
      return [];
    }
  }

  Stream<List<WakeModel>> fetchWakeListStream(String uid) {
    try {
      return _users
          .doc(uid)
          .collection(FirebaseConstants.alarmCollection)
          .where('senderUid', isEqualTo: uid)
          .orderBy('wakeTime', descending: true)
          .snapshots()
          .map((wakeUpSnapShot) => wakeUpSnapShot.docs.map((e) => WakeModel.fromMap(e.data())).toList());
    } catch (e) {
      logger.e(e.toString());
      return Stream.error(e);
    }
  }

  Stream<List<WakeModel>> fetchAlarmListStream(String uid) {
    try {
      return _users
          .doc(uid)
          .collection(FirebaseConstants.alarmCollection)
          .where('reciverUid', isEqualTo: uid)
          .orderBy('wakeTime', descending: true)
          .snapshots()
          .map((wakeUpSnapShot) => wakeUpSnapShot.docs.map((e) => WakeModel.fromMap(e.data())).toList());
    } catch (e) {
      logger.e(e.toString());
      return Stream.error(e);
    }
  }

  deleteWakeUp(String uid, String wakeUid) {
    try {
      _users.doc(uid).collection(FirebaseConstants.alarmCollection).doc(wakeUid).delete();
    } catch (e) {
      logger.e(e.toString());
    }
  }

  acceptWakeUp(String uid, String wakeUid) {
    try {
      _users.doc(uid).collection(FirebaseConstants.alarmCollection).doc(wakeUid).update({'isApproved': true});
    } catch (e) {
      logger.e(e.toString());
    }
  }

  reply(String uid, String wakeUid, String reply, String imageUrl, String voiceUrl, String videoUrl) {
    try {
      _users.doc(uid).collection(FirebaseConstants.alarmCollection).doc(wakeUid).update({
        'answer': reply,
        'answerTime': DateTime.now(),
        'answerPhoto': imageUrl,
        'answerAudio': voiceUrl,
        'answerVideo': videoUrl,
      });
    } catch (e) {
      logger.e(e.toString());
    }
  }
}