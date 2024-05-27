import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';
import 'package:wakeuphoney/common/providers/firebase_providers.dart';
import 'package:wakeuphoney/tabs/match/match_model.dart';

final matchTabRepositoryProvider = Provider((ref) => MatchTabRepository(firestore: ref.watch(firestoreProvider)));

class MatchTabRepository {
  final FirebaseFirestore _firestore;
  MatchTabRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _match => _firestore.collection(FirebaseConstants.matchCollection);

  Logger logger = Logger();

  Future<MatchModel> getFutureMatchNumber(String uid) {
    try {
      return Future(() {
        return _match.where('uid', isEqualTo: uid).get().then((snapshot) {
          if (snapshot.docs.isNotEmpty) {
            logger.d('Match number already exists ${snapshot.docs.first.get('vertifynumber')}');
            return MatchModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
          }
          final vertifyNumber = (Random().nextInt(900000) + 100000);
          logger.d('Match number Random: $vertifyNumber');
          return createMatch(uid, vertifyNumber);
        });
      });
    } catch (error) {
      // Handle the error here
      logger.e('Error getting match number: $error');
      throw ('Error getting match number');
    }
  }

  void deleteAllMatch() {
    _match.get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          logger.d('Deleting all match: ${doc.id}');
          doc.reference.delete();
        }
      }
    }).catchError((error) {
      // Handle the error here
      logger.e('Error deleting all matches: $error');
    });
  }

  void breakUp(String uid) {
    _users.doc(uid).update({"couples": []});
  }

  MatchModel createMatch(String uid, int vertifyNumber) {
    logger.d('Match number created: $vertifyNumber');
    final time = DateTime.now();
    _match.add({
      'uid': uid,
      'vertifynumber': vertifyNumber,
      'time': time,
    });

    return MatchModel(uid: uid, vertifynumber: vertifyNumber, time: time);
  }

  void deleteMatchAfterAHour() {
    _match.where('time', isLessThan: DateTime.now().subtract(const Duration(minutes: 60))).get().then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        for (final doc in snapshot.docs) {
          logger.d('Deleting old match: ${doc.id}');
          doc.reference.delete();
        }
        if (snapshot.docs.length > 1) {
          for (final doc in snapshot.docs) {
            logger.d('Deleted dup match: ${doc.id}');
            doc.reference.delete();
          }
        }
      }
    }).catchError((error) {
      // Handle the error here
      logger.e('Error deleting matches: $error');
    });
  }

  Future<bool> checkMatchWithCode(int honeyCode, String uid) async {
    return _match.where('vertifynumber', isEqualTo: honeyCode).get().then((value) {
      if (value.docs.isNotEmpty) {
        _match.doc(value.docs.first.id).delete();
        final coupleUid = MatchModel.fromMap(value.docs.first.data() as Map<String, dynamic>).uid;
        matchCoupleIdProcessDone(uid, coupleUid);
        return true;
      } else {
        return false;
      }
    }).catchError((error) {
      // Handle the error here
      logger.e('Error checking match with code: $error');
      throw ('Error checking match with code');
    });
  }

  //성공이면 uid 리턴 서로 집어넣기
  Future<void> matchCoupleIdProcessDone(String uid, String coupleId) async {
    try {
      _users.doc(uid).update({
        'couples': FieldValue.arrayUnion([coupleId]),
        'matchedDateTime': DateTime.now(),
      });
      _users.doc(coupleId).update({
        'couples': FieldValue.arrayUnion([uid]),
        'matchedDateTime': DateTime.now(),
      });
    } catch (error) {
      // Handle the error here
      logger.e('Error matching couple IDs: $error');
      throw ('Error matching couple IDs');
    }
  }
}
