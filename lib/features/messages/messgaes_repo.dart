import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/messages/message_model.dart';

final steamMessageServiceProvider =
    Provider<MessagesRepo>((ref) => MessagesRepo());

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

  Stream<MessageModel> getChatsStream(String groupId) {
    return coupleCollection
        .doc(groupId)
        .collection("dailymessages")
        .orderBy("time")
        .snapshots()
        .map((event) =>
            MessageModel.fromMap(event.docs as Map<String, dynamic>));
  }

  getChats(String groupId) async {
    return coupleCollection
        .doc(groupId)
        .collection("dailymessages")
        .orderBy("time")
        .snapshots();
  }

  Stream<List<MessageModel>> getMessageOfDay(String date) {
    return coupleCollection
        .doc("93zTjlpDFqX0AO0TKvIm")
        .collection("dailymessages")
        .where(
          "messagedate",
          isEqualTo: date,
        )
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var doc in event.docs) {
        messages.add(MessageModel.fromMap(doc.data()));
      }
      return messages;
    });
  }
}


// final steamServiceProvider = Provider<StreamService>((ref) => StreamService());

// class StreamService {
//   Stream<int> getStream() {
//     return Stream.periodic(const Duration(seconds: 1), (i) => i).take(10);
//   }
// }

