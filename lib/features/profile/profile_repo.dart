import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/users/user_model.dart';

final profileProvider = Provider((reg) => ProfileRepo());

class ProfileRepo {
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

  Future getUserProfile(String uid) async {
    await userCollection.doc(uid).get().then(
      (value) {
        return value.data() as UserModel;
      },
    );
    return null;
  }

  getUserList() {
    List userlist = [];
    userCollection.get().then((value) {
      for (var docSnapshot in value.docs) {
        userlist.add(docSnapshot.id);
      }
    });
    return userlist;
  }
}
