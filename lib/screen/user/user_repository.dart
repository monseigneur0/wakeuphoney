import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/common/constants/firebase_constants.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/screen/auth/user_model.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(firestore: ref.watch(firestoreProvider));
});

class UserRepository {
  final FirebaseFirestore _firestore;
  UserRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Stream<UserModel> getUser(String uid) {
    return _users.doc(uid).snapshots().map((snapshot) => UserModel.fromMap(snapshot.data() as Map<String, dynamic>));
  }
}
