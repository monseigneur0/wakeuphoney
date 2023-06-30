import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'daily_model.dart';

final dailyRepositoryProvider = Provider((ref) => DailyRepository());

final dateStateProvider = StateProvider<List<String>>(
  (ref) => List<String>.generate(
    100,
    (index) => DateFormat.yMMMd().format(
      DateTime.now().add(
        Duration(days: index),
      ),
    ),
  ),
);

final dateTimeStateProvider =
    StateProvider<List<DateTime>>((ref) => List<DateTime>.generate(
          100,
          (index) => DateTime.now().add(Duration(days: index)),
        ));

final selectedDate = StateProvider<String>(
  (ref) => DateFormat.yMMMd().format(DateTime.now()),
);
final selectedDateTime = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

class DailyRepository {
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

  // Stream<DailyMessageModel> getDailyMessage(String date) {
  //   return coupleCollection
  //       .doc("93zTjlpDFqX0AO0TKvIm")
  //       .collection("dailymessages")
  //       .doc("Os7njRq3RDo04xKFg3OJ")
  //       .snapshots()
  //       .map((event) =>
  //           DailyMessageModel.fromMap(event.data() as Map<String, dynamic>));
  // }
  Stream<DailyMessageModel> getDailyMessage(String date) {
    return coupleCollection
        .doc("93zTjlpDFqX0AO0TKvIm")
        .collection("dailymessages")
        .where("messagedate", isEqualTo: date)
        .orderBy("time")
        .snapshots()
        .map((event) => event.docs
            .map((e) => DailyMessageModel.fromMap(e.data()))
            .toList()
            .first);
  }

  Stream<List<DailyMessageModel>> getDailyMessagesListStream(String date) {
    return coupleCollection
        .doc("93zTjlpDFqX0AO0TKvIm")
        .collection("dailymessages")
        .where("messagedate", isEqualTo: date)
        .snapshots()
        .map((event) => event.docs
            .map((e) => DailyMessageModel.fromMap(e.data()))
            .toList());
  }
}
