import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wakeuphoney/features/dailymessages/daily_controller.dart';

class LetterFeed2Screen extends ConsumerStatefulWidget {
  static String routeName = "letterfeed2screen";
  static String routeURL = "/letterfeed2screen";
  const LetterFeed2Screen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LetterFeed2ScreenState();
}

class _LetterFeed2ScreenState extends ConsumerState<LetterFeed2Screen> {
  final logger = Logger();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final letterList = ref.watch(getLettersList0Provider);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      // appBar: AppBar(title: const Text('우리의 편지2')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 10,
                      height: 30,
                      child: Center(
                        child: Container(
                          width: 10,
                          height: 10,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black),
                        ),
                      ),
                    ).pSymmetric(h: 15),
                    Transform.translate(
                      offset: const Offset(0, -10),
                      child: Container(
                        width: 2,
                        height: MediaQuery.of(context).size.width * 2 + 80,
                        decoration: const BoxDecoration(color: Colors.black),
                      ).pSymmetric(h: 15),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    '2023, 12, 17'.text.size(20).make(),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              offset: const Offset(8, 8),
                              color: Colors.black.withOpacity(0.3))
                        ],
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  'https://picsum.photos/id/600/200/200',
                                ),
                              ),
                              10.widthBox,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 160,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        '이영희'.text.bold.size(20).make(),
                                        SizedBox(
                                          height: 32,
                                          child: PopupMenuButton(
                                              iconSize: 20,
                                              itemBuilder:
                                                  (BuildContext context) {
                                                return [
                                                  const PopupMenuItem(
                                                    child: Text('수정'),
                                                  ),
                                                  const PopupMenuItem(
                                                    child: Text('삭제'),
                                                  ),
                                                ];
                                              }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  '오늘 우리는 어떘고 이래서 좋았고 그래서 아침에 오늘 뭐 먹고 갈지 그리고 앞으로 어떨지 궁금하고 기대 돼'
                                      .text
                                      .size(16)
                                      .make()
                                      .box
                                      .width(MediaQuery.of(context).size.width -
                                          160)
                                      .make(),
                                ],
                              ),
                            ],
                          ),
                          10.heightBox,
                          Container(
                              width: MediaQuery.of(context).size.width - 90,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                'https://picsum.photos/id/610/200/200',
                                fit: BoxFit.fill,
                              )),
                          Container(
                            width: MediaQuery.of(context).size.width - 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.grey.shade200,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 20,
                                    offset: const Offset(8, 8),
                                    color: Colors.black.withOpacity(0.3))
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                        'https://picsum.photos/id/620/200/200',
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        '박철수'.text.bold.size(16).make(),
                                        '오늘 점심 맛있었다.오늘 점심 맛있었다.오늘 점심 맛있었다.'
                                            .text
                                            .make()
                                            .box
                                            .width(MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                190)
                                            .make(),
                                      ],
                                    ).pSymmetric(h: 10),
                                  ],
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width - 90,
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Image.network(
                                    'https://picsum.photos/id/630/200/200',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ).p(20),
                          ).pSymmetric(v: 20)
                        ],
                      ).p(20),
                    ).pOnly(right: 10),
                  ],
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true, //scroll imposible
              physics: const NeverScrollableScrollPhysics(),
              itemCount: feedDataList.length,
              itemBuilder: ((context, index) =>
                  FeedItem(feedData: feedDataList[index])),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedData {
  final String userName;
  final int likeCount;
  final String content;

  FeedData(
      {required this.userName, required this.likeCount, required this.content});
}

final feedDataList = [
  FeedData(
      userName: "User1",
      likeCount: 50,
      content:
          " 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다. 오늘 점심 맛있었다."),
  FeedData(userName: "User2", likeCount: 1253, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User3", likeCount: 32, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User4", likeCount: 50, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User5", likeCount: 24, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User6", likeCount: 535, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User7", likeCount: 57, content: "오늘 점심 맛있었다."),
  FeedData(userName: "User8", likeCount: 6, content: "오늘 점심 맛있었다."),
];

class FeedList extends ConsumerWidget {
  const FeedList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      shrinkWrap: true, //scroll imposible
      physics: const NeverScrollableScrollPhysics(),
      itemCount: feedDataList.length,
      itemBuilder: ((context, index) =>
          FeedItem(feedData: feedDataList[index])),
    );
  }
}

class FeedItem extends ConsumerWidget {
  final FeedData feedData;
  const FeedItem({required this.feedData, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.blue.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(feedData.userName),
                ],
              ),
              const Icon(Icons.more_vert)
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Container(
          width: double.infinity,
          height: 280,
          color: Colors.indigo.shade300,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.favorite_outline)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.chat_bubble)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(CupertinoIcons.paperplane)),
              ],
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(CupertinoIcons.bookmark)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '좋아요 ${feedData.likeCount}개',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                    text: feedData.userName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: feedData.content),
              ],
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 16)
      ],
    );
  }
}
