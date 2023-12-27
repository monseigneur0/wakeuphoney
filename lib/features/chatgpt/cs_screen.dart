import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/chatgpt/cs_model.dart';
import 'package:http/http.dart' as http;

class CustomerServiceScreen extends ConsumerStatefulWidget {
  const CustomerServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CustomerServiceScreenState();
}

class _CustomerServiceScreenState extends ConsumerState<CustomerServiceScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageTextController = TextEditingController();
  final ScrollController _messageListController = ScrollController();
  Logger logger = Logger();

  final List<ChatGPTMessageModel> _historyList = List.empty(growable: true);
  String apiKey = "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";
  String streamText = "";

  static const String _kStrings = "일어나곰 고객센터";
  String get _currentString => _kStrings;

  late Animation<int> _characterCount;
  late AnimationController _animationController;

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
          content: "You are a heplful assistant.",
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

    print(resp.body);
    logger.d(resp.body);
    if (resp.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(resp.bodyBytes)) as Map;
      logger.d(jsonData);
      String role = jsonData["choices"][0]["text"] as String;
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
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.topRight,
            child: Card(
              child: PopupMenuButton(
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(child: ListTile(title: Text("히스토리"))),
                    const PopupMenuItem(child: ListTile(title: Text("설정"))),
                    const PopupMenuItem(child: ListTile(title: Text("새로운 채팅"))),
                  ];
                },
              ),
            ),
          ),
          Expanded(
              child: AnimatedBuilder(
            animation: _characterCount,
            builder: (context, child) {
              String text = _currentString.substring(0, _characterCount.value);
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
              //  Container(
              //     child: ListView.builder(
              //   itemCount: 10,
              //   itemBuilder: (context, index) {
              //     if (index % 2 == 0) {
              //       return Row(
              //         children: [
              //           const CircleAvatar(),
              //           10.widthBox,
              //           const Expanded(
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("일어나곰"),
              //                 Text("안녕하세요. 일어나곰입니다."),
              //               ],
              //             ),
              //           )
              //         ],
              //       ).pSymmetric(v: 16);
              //     }
              //     return Row(children: [
              //       const Expanded(
              //         child: Column(
              //           crossAxisAlignment: CrossAxisAlignment.end,
              //           children: [
              //             Text("사용자"),
              //             Text("모시모시 OpenAI OpenAI"),
              //           ],
              //         ),
              //       ),
              //       10.widthBox,
              //       const CircleAvatar(),
              //     ]).pSymmetric(v: 16);
              //   },
              // )),
              ),
          Dismissible(
            key: const Key('chatgpt'),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                //
              }
            },
            background: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("새로운 채팅")]),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                //
              }
              return null;
            },
            child: Row(children: [
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
                  ),
                ),
              ),
              IconButton(
                  iconSize: 42,
                  icon: const Icon(Icons.arrow_circle_up),
                  onPressed: () async {
                    if (_messageTextController.text.isEmpty) return;
                    setState(() {
                      _historyList.add(ChatGPTMessageModel(
                          role: "user",
                          content: _messageTextController.text.trim()));
                      //일어나곰은 커플을 위한 알람앱입니다. 커플의 진정한 소통을 위해 기능을 추천해주고 마케팅 방법을 알려주세요. 이 앱을 SNS에 광고하며 인플루언서가 되는 방법을 알려주세요
                      _historyList.add(
                          ChatGPTMessageModel(role: "assistant", content: ""));
                    });

                    try {
                      await requestChat(_messageTextController.text.trim());
                      _messageTextController.clear();
                      streamText = "";
                    } catch (e) {
                      print(e);
                    }
                  }),
            ]),
          )
        ]).p(16),
      ),
    );
  }
}
