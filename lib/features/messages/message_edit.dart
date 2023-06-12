import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/users/google_repo.dart';

import 'messages_screen.dart';
import 'messgaes_repo.dart';

class MessageEdit extends ConsumerStatefulWidget {
  static String routeName = "messagesedit";
  static String routeURL = "messagesedit";
  const MessageEdit({super.key});
  @override
  MessageEditState createState() => MessageEditState();
}

class MessageEditState extends ConsumerState<MessageEdit> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageContorller = TextEditingController();

  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin() async {
    await MessagesRepo()
        .getChats(FirebaseAuth.instance.currentUser!.uid)
        .then((val) {
      setState(() {
        chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(115, 112, 112, 112),
      appBar: AppBar(
        title: Text(
          ref.read(selectedDate.notifier).state,
          style: TextStyle(color: Colors.amber[200]),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Row(
              children: [
                chatMessages(),
                Expanded(
                  child: TextFormField(
                    controller: messageContorller,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Wake up messages...",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 247, 0, 255),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  chatMessages() {
    return Expanded(
      child: StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 100,
                      child: ListView(
                        children: [
                          Text(
                            snapshot.data.docs[index]['message'],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : Container();
        },
      ),
    );
  }

  sendMessage() {
    if (messageContorller.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageContorller.text,
        "time": DateTime.now().millisecondsSinceEpoch,
        "datestring": ref.read(selectedDate.notifier).state,
      };
      print(messageContorller.text);
      MessagesRepo().sendMessage(
        ref.watch(googleSignInApiProbider).user!.uid,
        chatMessageMap,
      );
      setState(() {
        messageContorller.clear();
      });
      print("sendmessage");
      print(chatMessageMap);
    }
  }
}
