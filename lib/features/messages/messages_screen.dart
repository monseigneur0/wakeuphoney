import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final dateStateProvider =
    StateProvider<List<String>>((ref) => List<String>.generate(
        100,
        (index) => DateFormat.MMMd().format(
              DateTime.now().add(Duration(days: index)),
            )));
final dateTimeStateProvider =
    StateProvider<List<DateTime>>((ref) => List<DateTime>.generate(
          100,
          (index) => DateTime.now().add(Duration(days: index)),
        ));
final selectedDate = StateProvider<String>(
  (ref) => DateFormat.MMMd().format(DateTime.now()),
);

class MessagesScreen extends ConsumerStatefulWidget {
  static String routeName = "messages";
  static String routeURL = "/messages";

  const MessagesScreen({super.key});

  @override
  MessagesScreenState createState() => MessagesScreenState();
}

class MessagesScreenState extends ConsumerState<MessagesScreen> {
  final _blackColor = const Color(0xFF1F2123);
  final _greyColor = const Color(0xFF464A4F);
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  Future<void> _update(
      [DocumentSnapshot? documentSnapshot, String? datestring]) async {
    if (documentSnapshot != null) {
      _nameController.text = documentSnapshot['name'];
      _priceController.text = documentSnapshot['price'].toString();
    }
    final datestringview = datestring;

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
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Update'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final double? price =
                            double.tryParse(_priceController.text);
                        if (price != null) {
                          await _products
                              .doc(documentSnapshot!.id)
                              .update({"name": name, "price": price});
                          _nameController.text = '';
                          _priceController.text = '';
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    Text(datestringview ?? "no date"),
                  ],
                )
              ],
            ),
          );
        });
  }

  Future<void> _create() async {
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
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      child: const Text('Create'),
                      onPressed: () async {
                        final String name = _nameController.text;
                        final double? price =
                            double.tryParse(_priceController.text);
                        if (price != null) {
                          await _products.add({
                            "name": name,
                            "price": price,
                            "datestring": ref.read(selectedDate),
                          });

                          _nameController.text = '';
                          _priceController.text = '';
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                    Text(ref.read(selectedDate)),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final dateList100 = ref.watch(dateStateProvider);
    const title = 'Messgae_daily';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        backgroundColor: _blackColor,
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            StreamBuilder(
              stream: _products.orderBy("datestring").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: dateList100.length,
                    prototypeItem: ListTile(
                      title: Row(
                        children: [
                          Text(
                            dateList100.first,
                            style: const TextStyle(
                              fontSize: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: Container(
                          height: 30,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            color: _greyColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    ref.read(selectedDate.notifier).state =
                                        dateList100[index];
                                    print(ref.read(selectedDate));
                                    _nameController.text = '';
                                    _priceController.text = '';
                                    _create();
                                  },
                                  child: Text(
                                    dateList100[index],
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DateMessage extends StatelessWidget {
  const DateMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
