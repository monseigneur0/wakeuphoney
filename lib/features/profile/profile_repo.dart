import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/core/constants/firebase_constants.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';
import 'package:wakeuphoney/features/auth/user_model.dart';
import 'package:wakeuphoney/features/chatgpt/cs_model.dart';

final profileRepositoryProvider =
    Provider((ref) => ProfileRepo(firestore: ref.watch(firestoreProvider)));

class ProfileRepo {
  final FirebaseFirestore _firestore;
  ProfileRepo({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
  CollectionReference get _feedbacks =>
      _firestore.collection(FirebaseConstants.feedbackCollection);

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

  getCoupleUid(String uid) async {
    var documentSnapshotCoupleId = await _users.doc(uid).get();
    return documentSnapshotCoupleId.data();
  }

  getCoupleUidFuture(String uid) async {
    var documentSnapshotCoupleId = await _users.doc(uid).get();
    return documentSnapshotCoupleId.data();
  }

  Future createFeedback(String uid, String contents, String imageUrl) async {
    await _feedbacks.add({
      "uid": uid,
      "contents": contents,
      "image": imageUrl,
      "time": DateTime.now(),
    });
  }

  Future<UserModel> getUserInfo(String uid) async {
    return await _users.doc(uid).get().then(
        (value) => UserModel.fromMap(value.data() as Map<String, dynamic>));
  }

  updateProfileImage(String uid, String coupleUid, String url) async {
    await _users.doc(uid).update({"photoURL": url});
    await _users.doc(coupleUid).update({"couplePhotoURL": url});
  }

  updateGPTCount(String uid) {
    _users.doc(uid).update({"chatGPTMessageCount": FieldValue.increment(1)});
  }

  createGPTCount(String uid) {
    _users.doc(uid).update({"chatGPTMessageCount": 1});
  }

  updateGPTMessages(String uid, ChatCompletionModel chatCompletionModel) {
    _users
        .doc(uid)
        .collection("chatGPTMessages")
        .add(chatCompletionModel.toMap());
  }

  updateAllUser() {
    _users.get().then((value) {
      for (var docSnapshot in value.docs) {
        _users.doc(docSnapshot.id).update({
          // "chatGPTMessageCount": 0,
          // "gender": "male",
          // "birthDate": DateTime.now(),
          // "location": const GeoPoint(37.4734153, 126.8301878),
          // "wakeUpTime": DateTime.now(),
          // "coupleGender": "male",
          // "coupleBirthDate": DateTime.now(),
          // "coupleLocation": const GeoPoint(37.4734153, 126.8301878),
          // "coupleWakeUpTime": DateTime.now(),
          "coupleWakeUpTime": DateTime(2020, 01, 01, 05, 00, 00),
        });
      }
    });
  }

  updateGender(String uid, String gender) {
    _users.doc(uid).update({"gender": gender});
  }

  updateBirthday(String uid, DateTime birthday) {
    _users.doc(uid).update({"birthDate": birthday});
  }

  updateWakeUpTime(String uid, DateTime wakeUpTime) {
    _users.doc(uid).update({"coupleWakeUpTime": wakeUpTime});
  }
}
