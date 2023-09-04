import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/constants/firebase_constants.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';

import 'match_model.dart';

final matchRepositoryProvider = Provider((ref) {
  return MatchRepository(firestore: ref.watch(firestoreProvider));
});

class MatchRepository {
  final FirebaseFirestore _firestore;
  MatchRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _matches =>
      _firestore.collection(FirebaseConstants.matchCollection);

  Future matchStartProcess(String uid, int vertifyNumber) async {
    await _matches.add({
      "uid": uid,
      "vertifynumber": vertifyNumber,
      "time": DateTime.now(),
    });
  }

  Stream<MatchModel> checkMatchProcess(int honeyCode) {
    return _matches
        .where("vertifynumber", isEqualTo: honeyCode)
        .snapshots()
        .map((event) => event.docs
            .map((e) => MatchModel.fromMap(e.data() as Map<String, dynamic>))
            .toList()
            .first);
  }

  Future<MatchModel?> getMatchCodeFuture(String uid, int honeyCode) async {
    await _matches
        .where("time",
            isLessThan: DateTime.now().subtract(const Duration(minutes: 60)))
        .get()
        .then((value) => value.docs.forEach((element) {
              _matches.doc(element.id).delete();
            }));

    try {
      final wow =
          await _matches.where("uid", isEqualTo: uid).get().then((event) {
        if (event.docs.isNotEmpty) {
          return event.docs
              .map((e) => MatchModel.fromMap(e.data() as Map<String, dynamic>))
              .toList()
              .first;
        }
      });
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  Future matchCoupleIdProcessDone(
      String uid, String coupleId, int vertifyNumber) async {
    //나한테 상대 아이디 등록
    await _users.doc(uid).update({
      "couples": [
        ...{coupleId}
      ]
    });
    await _users.doc(uid).update({
      "couple": coupleId,
    });

    //상대에 내 아이디 등록
    await _users.doc(coupleId).update({
      "couples": [
        ...{uid}
      ]
    });
    await _users.doc(coupleId).update({
      "couple": uid,
    });

    //삭제
    await _matches
        .where("uid", isEqualTo: uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              _matches.doc(element.id).delete();
              print(element.id);
            }));
  }

  Future deleteMatches(String uid) async {
    _matches
        .where("time",
            isLessThan: DateTime.now().subtract(const Duration(minutes: 60)))
        .get()
        .then((value) => value.docs.forEach((element) {
              _matches.doc(element.id).delete();
            }));
    // _matches
    //     .where("uid", isEqualTo: uid)
    //     .get()
    //     .then((value) => value.docs.forEach((element) {
    //           _matches.doc(element.id).delete();
    //         }));
  }
}
