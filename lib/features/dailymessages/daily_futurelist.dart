import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wakeuphoney/core/common/loader.dart';
import 'package:wakeuphoney/core/providers/providers.dart';

import 'daily_model.dart';

class _FutureList extends StatelessWidget {
  _FutureList({
    required this.listDateTime,
    required this.ref,
    required this.listMessage,
    required TextEditingController messgaeController,
  });

  final List<DateTime> listDateTime;
  final WidgetRef ref;
  final AsyncValue<List<DailyMessageModel>> listMessage;
  final TextEditingController _messgaeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.62,
        child: ListView.builder(
          itemCount: 100,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return listMessage.when(
              data: (value) {
                return value
                            .singleWhere(
                              (element) =>
                                  element.messagedate ==
                                  DateFormat.yMMMd()
                                      .format(listDateTime[index]),
                              orElse: () => DailyMessageModel(
                                message: "메세지를 적어주세요",
                                messagedate: "messagedate",
                                messagedatetime: DateTime.now(),
                                time: DateTime.now(),
                                sender: "",
                                reciver: "",
                                photo: "",
                                audio: "",
                                video: "",
                              ),
                            )
                            .message !=
                        "메세지를 적어주세요"
                    ? Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          tileColor: Colors.black,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          title: Text(
                            value
                                .singleWhere(
                                  (element) =>
                                      element.messagedate ==
                                      DateFormat.yMMMd()
                                          .format(listDateTime[index]),
                                  orElse: () => DailyMessageModel(
                                    message: "메세지를 적어주세요",
                                    messagedate: "messagedate",
                                    messagedatetime: DateTime.now(),
                                    time: DateTime.now(),
                                    sender: "",
                                    reciver: "",
                                    photo: "",
                                    audio: "",
                                    video: "",
                                  ),
                                )
                                .message,
                            // "wow",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat.MMMd().format(listDateTime[index]),
                            style: const TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            ref.read(selectedDate.notifier).state =
                                DateFormat.yMMMd().format(listDateTime[index]);
                            // _update(uid);
                            // _messgaeController.text = message.message;
                          },
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ListTile(
                          title: Text(
                            value
                                .singleWhere(
                                  (element) =>
                                      element.messagedate ==
                                      DateFormat.yMMMd()
                                          .format(listDateTime[index]),
                                  orElse: () => DailyMessageModel(
                                    message: "메세지를 적어주세요",
                                    messagedate: "messagedate",
                                    messagedatetime: DateTime.now(),
                                    time: DateTime.now(),
                                    sender: "",
                                    reciver: "",
                                    photo: "",
                                    audio: "",
                                    video: "",
                                  ),
                                )
                                .message,
                            // "wow",
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                          subtitle: Text(
                            DateFormat.MMMd().format(listDateTime[index]),
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                      );
              },
              error: (error, stackTrace) {
                // print("error$error ");
                return null;
              },
              loading: () => const Loader(),
            );
          },
        ),
      ),
    );
  }
}
