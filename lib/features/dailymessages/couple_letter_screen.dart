import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/providers/firebase_providers.dart';

import '../../core/common/loader.dart';
import '../../core/providers/providers.dart';
import 'daily_controller.dart';

class CoupleLetterScreen extends ConsumerStatefulWidget {
  static String routeName = "coupleLetter";
  static String routeURL = "/coupleLetter";
  const CoupleLetterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CoupleLetterScreenState();
}

class _CoupleLetterScreenState extends ConsumerState<CoupleLetterScreen> {
  List allMessages = [];

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(authProvider).currentUser!.uid;

    final List<DateTime> listDateTime = ref.watch(dateTimeStateProvider);

    final listMessageHistory =
        ref.watch(getDailyCoupleMessageHistoryListProvider).whenData(
              (value) => value
                  .filter((t) => t.messagedatetime.isBefore(DateTime.now().add(
                      Duration(
                          seconds: 24 * 60 * 60 -
                              DateTime.now().hour * 3600 -
                              DateTime.now().minute * 60 -
                              DateTime.now().second))))
                  .toList(),
            );

    allMessages = [listMessageHistory, ...listDateTime];

    return Scaffold(
      appBar: AppBar(
        title: const Text("my answers for honey"),
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(color: Colors.grey[800]),
          ),
          listMessageHistory.when(
            data: (value) {
              return Expanded(
                child: ListView.builder(
                  itemCount: listMessageHistory.value!.length,
                  itemBuilder: (context, index) {
                    return value[index].sender == uid
                        ? Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: value[index].photo.isNotEmpty
                                    ? Image.network(value[index].photo)
                                    : Container(),
                              ),
                              ListTile(
                                title: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      value[index].message,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      DateFormat.MMMd()
                                          .format(value[index].messagedatetime),
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: Colors.grey[600]),
                              ),
                              Container(
                                height: 5,
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 40,
                                child: value[index].photo.isNotEmpty
                                    ? Image.network(value[index].photo)
                                    : Container(),
                              ),
                              ListTile(
                                title: Text(
                                  value[index].message,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                subtitle: Text(
                                  DateFormat.MMMd()
                                      .format(value[index].messagedatetime),
                                  style:
                                      const TextStyle(color: Color(0xFFD72499)),
                                ),
                              ),
                              Container(
                                height: 1,
                                decoration:
                                    BoxDecoration(color: Colors.grey[600]),
                              ),
                              Container(
                                height: 5,
                              ),
                            ],
                          );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              print("error$error ");
              return const Text("error");
            },
            loading: () => const Loader(),
          ),
          Container(
            height: 1,
            decoration: const BoxDecoration(color: Colors.white),
          ),
          const SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }
}
