import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:wakeuphoney/features/couples/couples_repo.dart';

class CouplesListScreen extends ConsumerStatefulWidget {
  static String routeName = "couplelist";
  static String routeURL = "/couplelist";
  const CouplesListScreen({super.key});

  @override
  CouplesListScreenState createState() => CouplesListScreenState();
}

class CouplesListScreenState extends ConsumerState<CouplesListScreen> {
  bool _isLoading = false;
  String coupleId = "";
  Stream? groups;
  late Stream<QuerySnapshot> streamData;
  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    streamData = db.collection('users').snapshots();
    gettingUserData();
  }

  gettingUserData() async {
    await CouplesRepo(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroups()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List userlist = ref.watch(userListProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(Icons.connecting_airports_outlined))
        ],
        title: const Text("Couple list"),
      ),
      body: Column(
        children: [
          const Center(
              child: Icon(
            Icons.add,
            size: 100,
          )),
          const Text("you need to match a couple"),
          Expanded(
            child: ListView.separated(
              itemCount: userlist.length,
              itemBuilder: (context, index) {
                return Text("user id : ${userlist[index]}");
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 10,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: Colors.green[200],
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: const Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                          color: Colors.red,
                        ))
                      : TextField(
                          onChanged: (val) {
                            setState(() {
                              coupleId = val;
                            });
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                  borderRadius: BorderRadius.circular(20))),
                        ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (coupleId != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      CouplesRepo(uid: FirebaseAuth.instance.currentUser!.uid)
                          .createCouple(FirebaseAuth.instance.currentUser!.uid)
                          .whenComplete((_) {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackbar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: const Text("CREATE"),
                )
              ],
            );
          }));
        });
  }

  coupleIist() {
    return SizedBox(
      height: 200,
      child: Expanded(
        child: StreamBuilder(
          stream: groups,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print("has data");
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < 3) {
                    return Text(
                      snapshot.data['groups'][index],
                      style: const TextStyle(fontSize: 40),
                    );
                  }
                  return null;
                },
              );
            } else {
              print("has No data");

              return const Center(
                child: CircularProgressIndicator(color: Colors.red),
              );
            }
          },
        ),
      ),
    );
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popUpDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text(
            "You've not joined any groups, tap on the add icon to create a group or also search from top search button.",
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  void showSnackbar(context, color, message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: "OK",
          onPressed: () {},
          textColor: Colors.white,
        ),
      ),
    );
  }
}
