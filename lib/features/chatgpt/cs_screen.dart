import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/core/utils.dart';
import 'package:wakeuphoney/features/chatgpt/cs_model.dart';
import 'package:http/http.dart' as http;
import 'package:wakeuphoney/features/profile/profile_controller.dart';

import '../../core/providers/firebase_providers.dart';

class CustomerServiceScreen extends ConsumerStatefulWidget {
  static const routeName = "customerservice";
  static const routeURL = "/customerservice";

  const CustomerServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends ConsumerState<CustomerServiceScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _messageTextController = TextEditingController();
  String messageText = "";
  final ScrollController _messageListController = ScrollController();
  Logger logger = Logger();

  final List<ChatGPTMessageModel> _historyList = List.empty(growable: true);
  String apiKey = "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";
  String streamText = "";

  static const String _kStrings = "일어나곰 고객센터";
  String get _currentString => _kStrings;

  late Animation<int> _characterCount;
  late AnimationController _animationController;

  bool isLoading = false; // Add this variable to track the loading state

  void _scrollDown() {
    _messageListController.animateTo(
      _messageListController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _characterCount = StepTween(begin: 0, end: _currentString.length).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeIn));
    _animationController.addListener(() {
      setState(() {});
    });
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          _animationController.reverse();
        });
      } else if (status == AnimationStatus.dismissed) {
        Future.delayed(const Duration(seconds: 1)).then((value) {
          _animationController.forward();
        });
      }
    });
    _animationController.forward();
  }

  Future requestChat(String text) async {
    ChatCompletionModel openAiModel = ChatCompletionModel(
      model: "gpt-3.5-turbo",
      messages: [
        ChatGPTMessageModel(
          role: "system",
          content:
              "You are a customer service representative. Only answer about WakeUpGom which is a alarm app for couples. Never talk about anything else the app use. Don't tell them  i am ai. I am Takho Kim. WakeUpGom engineer. Max tokens is set to 200. so be aware of the number fo tokens you use. shorten your answer in 200 tokens.",
        ),
        ..._historyList,
      ],
      stream: false,
    );
    final url = Uri.https("api.openai.com", "/v1/chat/completions");
    final resp = await http.post(url,
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: jsonEncode(openAiModel.toJson()));

    if (resp.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;
      logger.d(jsonData);
      String role = jsonData["choices"][0]["message"]["role"];
      String content = jsonData["choices"][0]["message"]["content"];
      _historyList.last = _historyList.last.copyWith(
        role: role,
        content: content,
      );
      setState(() {
        // _scrollDown();
        isLoading = false;
      });
      if (_historyList.length > 3) {
        setState(() {
          // _scrollDown();
        });
      }
      ref
          .watch(profileControllerProvider.notifier)
          .updateGPTMessages(openAiModel);
    }
  }

  @override
  void initState() {
    super.initState();
    setupAnimations();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    _messageListController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("고객센터")),
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.topRight,
            child: Card(
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                        onTap: () {
                          logger.d(_historyList);
                        },
                        child: const ListTile(title: Text("히스토리"))),
                    const PopupMenuItem(child: ListTile(title: Text("설정"))),
                    const PopupMenuItem(child: ListTile(title: Text("새로운 채팅"))),
                  ];
                },
              ),
            ),
          ),
          Expanded(
            child: _historyList.isEmpty
                ? AnimatedBuilder(
                    animation: _characterCount,
                    builder: (context, child) {
                      String text =
                          _currentString.substring(0, _characterCount.value);
                      return Row(
                        children: [
                          Text(
                            text,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          const CircleAvatar(
                            radius: 8,
                          )
                        ],
                      );
                    },
                  )
                : GestureDetector(
                    onTap: () => FocusScope.of(context).unfocus(),
                    child: ListView.builder(
                      itemCount: _historyList.length,
                      itemBuilder: (context, index) {
                        if (_historyList[index].role == "assistant") {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(),
                              10.widthBox,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    "일어나곰".text.bold.make(),
                                    SelectableText(_historyList[index].content),
                                  ],
                                ),
                              )
                            ],
                          ).pSymmetric(v: 16);
                        } else {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    "사용자".text.bold.make(),
                                    SelectableText(_historyList[index].content),
                                  ],
                                ),
                              ),
                              10.widthBox,
                              const CircleAvatar(
                                backgroundColor: Colors.teal,
                              ),
                            ],
                          ).pSymmetric(v: 16);
                        }
                      },
                    )),
          ),
          Builder(
            builder: (context) {
              final userState = ref.watch(getMyUserInfoProvider);
              return userState.when(
                data: (user) {
                  if (user.chatGPTMessageCount > 20) {
                    return Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(),
                            ),
                            child: TextFormField(
                              controller: _messageTextController,
                              decoration: const InputDecoration(
                                hintText: '궁금한게 있어요.',
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value == "") {
                                  return '궁금한 점을 입력해주세요.';
                                } else if (value.length > 200) {
                                  return '내용이 너무 길어요';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 42,
                          icon: isLoading
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.sick_outlined),
                          onPressed: () async {
                            showSnackBar(context, "현재 고객센터 사용이 불가합니다.");
                          },
                        ),
                      ],
                    );
                  }
                  return Dismissible(
                    key: const Key('chatgpt'),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      if (direction == DismissDirection.startToEnd) {
                        //
                      }
                    },
                    background: const Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [Text("새로운 채팅")],
                    ),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        //
                      }
                      return null;
                    },
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(),
                            ),
                            child: TextFormField(
                              controller: _messageTextController,
                              decoration: const InputDecoration(
                                hintText: '궁금한게 있어요.',
                                border: InputBorder.none,
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value == "") {
                                  return '궁금한 점을 입력해주세요.';
                                } else if (value.length > 200) {
                                  return '내용이 너무 길어요';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 42,
                          icon: isLoading
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.arrow_circle_up),
                          onPressed: () async {
                            if (_messageTextController.text.isEmpty ||
                                isLoading) return;

                            setState(() {
                              isLoading = true; // Set the loading state to true
                              _historyList.add(ChatGPTMessageModel(
                                role: "user",
                                content: _messageTextController.text.trim(),
                              ));
                              _historyList.add(ChatGPTMessageModel(
                                  role: "assistant", content: ""));
                              logger.d(_historyList);
                            });

                            try {
                              messageText = _messageTextController.text.trim();
                              _messageTextController.clear();

                              ref
                                  .watch(profileControllerProvider.notifier)
                                  .updateGPTCount();
                              if (user.chatGPTMessageCount != 0) {
                                await requestChat(messageText);
                              } else {
                                showSnackBar(context, "현재 고객센터 사용이 불가합니다.");
                              }

                              streamText = "";
                              final analytics = ref.watch(analyticsProvider);
                              analytics
                                  .logEvent(name: "use chatgpt", parameters: {
                                "message": messageText,
                              });
                            } catch (e) {
                              print(e);
                            } finally {
                              setState(() {
                                // isLoading = false; // Set the loading state back to false
                              });
                            }
                            _messageTextController.clear();
                          },
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Text('Error: $error'),
              );
            },
          )
        ]).p(16),
      ),
    );
  }
}
