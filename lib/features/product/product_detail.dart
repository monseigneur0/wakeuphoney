import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../messages/messages_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  static String routeName = "productdetail";
  static String routeURL = "/productdetail";
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Firestore',
      home: HomeProductPage(),
    );
  }
}

class HomeProductPage extends ConsumerStatefulWidget {
  const HomeProductPage({Key? key}) : super(key: key);

  @override
  HomeProductPageState createState() => HomeProductPageState();
}

class HomeProductPageState extends ConsumerState<HomeProductPage> {
// text fields' controllers
  final TextEditingController _nameController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');
  final CollectionReference _coupleCollection =
      FirebaseFirestore.instance.collection('couples');

  Future<void> _create() async {
    _nameController.clear();
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name hoho'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Create'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    await _products.add({"name": name, "price": 1});

                    _nameController.clear();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _update(
      [DocumentSnapshot? documentSnapshot, DateTime? dateTime]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
    }

    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Update'),
                  onPressed: () async {
                    final String name = _nameController.text;
                    await _products
                        .doc(documentSnapshot!.id)
                        .update({"name": name, "price": 12});
                    await _coupleCollection
                        .doc("93zTjlpDFqX0AO0TKvIm")
                        .collection("dailymessages")
                        .add({
                      "uid": "IZZ1HICxZ8ggCiJihcJKow38LPK2",
                      "message": name,
                      "time": dateTime
                    });
                    _nameController.clear();
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });
  }

  Future<void> _delete(String productId) async {
    await _products.doc(productId).delete();

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You have successfully deleted a product')));
  }

  @override
  Widget build(BuildContext context) {
    final dateList100 = ref.watch(dateTimeStateProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Center(child: Text('Firebase Firestore Detail')),
          actions: const [],
        ),
        body: StreamBuilder(
          stream: _products.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      title: Text(documentSnapshot['name']),
                      subtitle: Text(
                        dateList100[index].toString(),
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => _update(
                                    documentSnapshot, dateList100[index])),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => _delete(documentSnapshot.id)),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
// Add new product
        floatingActionButton: FloatingActionButton(
          onPressed: () => _create(),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat);
  }
}
