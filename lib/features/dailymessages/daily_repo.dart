import 'package:cloud_firestore/cloud_firestore.dart';

class DaillyDatabaseService {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference coupleCollection =
      FirebaseFirestore.instance.collection('couples');

  Future creatingCouple(String coupleName, String uid) async {
    await coupleCollection.add({
      "coupleName": coupleName,
    }).then(
      (value) async => await usersCollection.doc(uid).update({
        "couples": [
          ...{value.id}
        ]
      }),
    );
  }

  Future creatingDailyMessage(String uid, String message, DateTime time) async {
    await coupleCollection.add({
      "uid": uid,
      "message": message,
      "time": time,
    });
  }

  getDailyMessages(String coupleId) async {
    return coupleCollection
        .doc(coupleId)
        .collection("dailymessages")
        .orderBy("messgaedatetime")
        .snapshots();
  }
}
