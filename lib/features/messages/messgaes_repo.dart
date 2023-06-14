import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesRepo {
  FirebaseFirestore db = FirebaseFirestore.instance;

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference coupleCollection =
      FirebaseFirestore.instance.collection("couples");

  sendMessage(String userId, Map<String, dynamic> chatMessageData) async {
    userCollection.doc(userId).collection("messages").add(chatMessageData);
    print(userId);
  }

  getChats(String groupId) async {
    return userCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }
}


// final steamServiceProvider = Provider<StreamService>((ref) => StreamService());

// class StreamService {
//   Stream<int> getStream() {
//     return Stream.periodic(const Duration(seconds: 1), (i) => i).take(10);
//   }
// }

