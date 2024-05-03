import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/common.dart';

import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/oldauth/user_model.dart';
import 'package:wakeuphoney/features/oldmatch/match_model.dart';
import 'package:wakeuphoney/screen/auth/login_controller.dart';

final matchTabRepositoryProvider = Provider((ref) => MatchTabRepository(firestore: ref.watch(firestoreProvider)));

class MatchTabRepository {
  final FirebaseFirestore _firestore;
  MatchTabRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _match => _firestore.collection(FirebaseConstants.matchCollection);

  Logger logger = Logger();

  Stream<MatchModel> getMatchNumber(String uid) {
    try {
      return _match.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          logger.d('Match number already exists ${snapshot.docs.first.get('vertifynumber')}');
          return MatchModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
        }
        final vertifyNumber = (Random().nextInt(900000) + 100000);
        logger.d('Match number Random: $vertifyNumber');
        return createMatch(uid, vertifyNumber);
      });
    } catch (error) {
      // Handle the error here
      logger.e('Error getting match number: $error');
      return Stream.error('Error getting match number');
    }
  }

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
    _match.where('time', isLessThan: DateTime.now().subtract(const Duration(minutes: 5))).get().then((snapshot) {
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

  Future<void> checkMatchProcess(int honeyCode, String uid) {
    // Add a return statement at the end
    return Future(() {
      _match.where('vertifynumber', isEqualTo: honeyCode).snapshots().map((snapshot) {
        //null 아니면 성공
        if (snapshot.docs.isNotEmpty) {
          logger.d('Match found: ${snapshot.docs.first.id}');

          //성공이면 uid 리턴 서로 집어넣기
          final coupleuid = snapshot.docs.first.get('uid');
          _users.doc(uid).update({
            'couples': [coupleuid],
          });
          _users.doc(coupleuid).update({
            'couples': [uid],
          });

          return MatchModel.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
        }
        return null;
      });
    });
  }
}
