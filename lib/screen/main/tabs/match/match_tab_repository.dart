import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/constants/firebase_constants.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';

final matchTabRepositoryProvider = Provider((ref) => MatchTabRepository(firestore: ref.watch(firestoreProvider)));

class MatchTabRepository {
  final FirebaseFirestore _firestore;
  MatchTabRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _match => _firestore.collection(FirebaseConstants.matchCollection);

  Stream<String> getMatchNumber(String uid) async* {
    yield* _match.where('uid', isEqualTo: uid).snapshots().map((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.get('vertifynumber');
      }
      return (Random().nextInt(900000) + 100000).toString();
    });
  }

  void createMatch(String uid, String vertifyNumber) {
    _match.add({
      'uid': uid,
      'vertifynumber': vertifyNumber,
      'time': DateTime.now(),
    });
  }
}
