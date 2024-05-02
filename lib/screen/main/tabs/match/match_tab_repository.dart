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

  Stream<String> getMatchNumber(String uid) {
    return _match.where('uid', isEqualTo: uid).snapshots().map((snapshot) => snapshot.docs.first.get(['vertifynumber']));
  }

  void createMatch(String uid, int vertifyNumber) {
    _match.add({
      'uid': uid,
      'vertifynumber': vertifyNumber,
      'time': DateTime.now(),
    });
  }
}
