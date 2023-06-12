import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userListProvider = Provider<List>((ref) {
  return CouplesRepo().getUserList();
});

final couplesRepo = Provider<CouplesRepo>((reg) => CouplesRepo());

class CouplesRepo {
  final String? uid;
  CouplesRepo({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  getUserList() {
    List userlist = [];
    userCollection.get().then((value) {
      for (var docSnapshot in value.docs) {
        userlist.add(docSnapshot.id);
        print('${docSnapshot.id} => ${docSnapshot.data()}');
      }
    });
    print(userlist);
    return userlist;
  }

  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);

    return await userDocumentReference.update({
      "couples":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  createCouple(String id) {
    userCollection.doc(uid).update({
      "couples": FieldValue.arrayUnion([uid]),
    });
  }
}
