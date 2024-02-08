import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wakeuphoney/core/constants/firebase_constants.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';

final mainRepositoryProvider = Provider<MainRepository>((ref) {
  return MainRepository(firestore: ref.watch(firestoreProvider));
});

class MainRepository {
  final FirebaseFirestore _firestore;
  MainRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _usersCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Future<UserModel> getMeUserModel(String uid) async {
    return await _usersCollection.doc(uid).get().then(
        (value) => UserModel.fromMap(value.data() as Map<String, dynamic>));
  }
}
