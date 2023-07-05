import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/constants/firebase_constants.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';
import 'package:wakeuphoney/features/profile/match_model.dart';

final profileRepositoryProvider =
    Provider((ref) => ProfileRepo(firestore: ref.watch(firestoreProvider)));

class ProfileRepo {
  final FirebaseFirestore _firestore;
  ProfileRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _couples =>
      _firestore.collection(FirebaseConstants.coupleCollection);
  CollectionReference get _matches =>
      _firestore.collection(FirebaseConstants.matchCollection);

  Stream<UserModel> getUserProfileStream(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  getUserList() {
    List userlist = [];
    _users.get().then((value) {
      for (var docSnapshot in value.docs) {
        userlist.add(docSnapshot.id);
      }
    });
    return userlist;
  }

  Future matchStartProcess(String uid, int vertifyNumber) async {
    await _matches.add({
      "uid": uid,
      "vertifynumber": vertifyNumber,
      "time": DateTime.now(),
    });
  }

  Stream<MatchModel> getMatchStartProcess(String uid) {
    return _matches.where("uid", isEqualTo: uid).snapshots().map((event) =>
        event.docs
            .map((e) => MatchModel.fromMap(e.data() as Map<String, dynamic>))
            .toList()
            .first);
  }

//코드 맞는거 반환
  Stream<MatchModel> checkMatchProcess(int honeyCode) {
    return _matches
        .where("vertifynumber", isEqualTo: honeyCode)
        .snapshots()
        .map((event) => event.docs
            .map((e) => MatchModel.fromMap(e.data() as Map<String, dynamic>))
            .toList()
            .first);
  }

  // Future<bool> checkMatchProcessbool(int honeyCode) async {
  //   return _matches
  //       .where("vertifynumber", isEqualTo: honeyCode)
  //       .snapshots()
  //       .map((event) => event.docs
  //           .map((e) => MatchModel.fromMap(e.data() as Map<String, dynamic>))
  //           .toList()
  //           .first)
  //       .isEmpty;
  // }

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
        .where("vertifynumber", isEqualTo: vertifyNumber)
        .get()
        .then((value) => value.docs.forEach((element) {
              _matches.doc(element.id).delete();
              print(element.id);
            }));
  }

  Future deleteMatches(String uid) async {
    _matches
        .where("time",
            isLessThan: DateTime.now().subtract(const Duration(minutes: 10)))
        .get()
        .then((value) => value.docs.forEach((element) {
              _matches.doc(element.id).delete();
            }));
    _matches
        .where("uid", isEqualTo: uid)
        .get()
        .then((value) => value.docs.forEach((element) {
              _matches.doc(element.id).delete();
            }));
  }
}
