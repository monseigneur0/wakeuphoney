import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/letter/letter_model.dart';

import '../../core/constants/firebase_constants.dart';

final letterRepositoryProvider = Provider(
    (ref) => LetterRepository(firestore: ref.watch(firestoreProvider)));

class LetterRepository {
  final FirebaseFirestore _firestore;
  LetterRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  CollectionReference get _usersCollection =>
      _firestore.collection(FirebaseConstants.usersCollection);

  Logger logger = Logger();

  createLetter(LetterModel letterModel, String uid) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .doc(letterModel.letterId)
          .set(letterModel.toMap());
    } catch (e) {
      logger.e(e.toString());
    }
  }

  // createAnswer(){
  //   try {
  //     _usersCollection.doc(uid).collection(FirebaseConstants.lettersCollection).where()
  //   } catch (e) {
  //        logger.e(e.toString());
  //   }
  // }
  updateDailyMessage(String message, String selectedDate, String uid) async {
    await _usersCollection
        .doc(uid)
        .collection("messages")
        .where("messagedate", isEqualTo: selectedDate)
        .get()
        .then((value) => _usersCollection
            .doc(uid)
            .collection("messages")
            .doc(value.docs.first.id)
            .update({"message": message}));
  }

  Stream<List<LetterModel>> getLettersList(String uid) {
    try {
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .snapshots()
          .map(
            (event) =>
                event.docs.map((e) => LetterModel.fromMap(e.data())).toList()
                  ..sort((a, b) => b.letterTime.compareTo(a.letterTime)),
          );
    } catch (e) {
      logger.e(e.toString());
      return Stream.error(e);
    }
  }

  Future<List<LetterModel>> getLettersFeedList(String uid) {
    try {
      return _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .get()
          .then(
            (event) =>
                event.docs.map((e) => LetterModel.fromMap(e.data())).toList()
                  ..sort((a, b) => b.letterTime.compareTo(a.letterTime)),
          );
    } catch (e) {
      logger.e(e.toString());
      return Future.error(e);
    }
  }

  letterEditMessage(String uid, String letterId, String message) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .doc(letterId)
          .update({"letter": message, "dateTimeNow": Timestamp.now()});
    } catch (e) {
      logger.e(e.toString());
    }
  }

  letterDelete(String uid, String letterId) {
    try {
      _usersCollection
          .doc(uid)
          .collection(FirebaseConstants.lettersCollection)
          .doc(letterId)
          .delete();
    } catch (e) {
      logger.e(e.toString());
    }
  }
}
